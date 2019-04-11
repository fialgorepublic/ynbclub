class MediumBlogsService
  include HTTParty

  attr_reader :doc, :next_page, :tag, :blogs_urls, :blogs_slugs, :blogs

  BASE_URL            = 'https://medium.com/search'
  JSON_BASE_URL       = 'https://medium.com/search/posts?format=json'
  BLOGS_XPATH         = "//div[contains(@class, 'js-postListHandle')]/div[contains(@class, 'js-block')]"
  BLOGS_CONTENT_XPATH = "//div[contains(@class, 'postArticle-content')]//div[contains(@class, 'section-content')]"

  def initialize(tag)
    @tag = tag
  end

  def get_blogs
    @next_page   = 1
    @blogs_urls  = []
    @blogs_slugs = []
    @blogs       = []
    search_blogs
  end

  private

  def search_blogs
    # while next_page >= 1 do
    #   get_json_from_medium
    # end
    get_blogs_by_slugs
    puts "Blogs URLS", blogs_urls

    get_blogs_content
    blogs
  end

  # def get_json_from_medium
  #   json_response = HTTParty.get("#{JSON_BASE_URL}&#{query_params}")
  #   set_page_count(json_response)
  # end

  # def query_params
  #   "q=#{tag}&page=#{next_page}"
  # end

  # def set_page_count(json_response)
  #   json_response.to_s.slice!('])}')
  #   json_response.to_s.slice!('while(1)')
  #   json_response.to_s.slice!('</x>')

  #   json_response = JSON.parse(json_response.to_s[1..-1])

  #   paging = json_response['payload']['paging']
  #   next_obj = paging['next'].presence
  #   get_slugs(json_response['payload']['value']) if json_response['payload']['value'].present?
  #   get_blogs_by_slugs
  #   get_blogs_content
  #   if next_obj.present?
  #     @next_page  = next_obj['page']
  #   else
  #     @next_page = 0
  #   end
  # end

  # def get_slugs(blogs)
  #   blogs.each { |blog| blogs_slugs << blog['slug'] }
  #   puts "blogs_slugs", blogs_slugs
  # end

  def get_blogs_by_slugs
    # blogs_slugs.each do |slug|

    http_reposne = HTTParty.get(URI.parse(URI.escape("#{BASE_URL}?q=#{tag}")))
    doc = Nokogiri::HTML(http_reposne)
    get_blogs_urls(doc)
    # end
  end

  def get_blogs_urls(doc)
    return unless doc
    doc.xpath(BLOGS_XPATH).each_with_index do |div_element, index|
      puts "Index", index
      blogs_urls << div_element.css('.postArticle-content').css('a')[0]['href']
      puts "blogs_urls", blogs_urls
    end
  end

  def get_blogs_content
    blogs_urls.each do |blog_page_url|
      doc = Nokogiri::HTML(open("#{blog_page_url}"))
      content_div    = doc.xpath(BLOGS_CONTENT_XPATH)
      blog_image_div = content_div.css('.graf--figure').first
      image_url      = blog_image_div.css('img')[0]['src'] if blog_image_div.present? && blog_image_div.css('img').present?
      blog_title     = content_div.css('.graf--title')&.text()
      content_div.search('h1').remove
      content_div.search('.js-postMetaLockup').remove
      content_div.search('.graf-after--h3').remove
      create_blog({title: blog_title, image_url: image_url, content: content_div.to_html})
    end
  end

  def create_blog(blogs_params)
    blogs << Blog.find_or_create_by(title: blogs_params[:title], user: User.first) do |blog|
      blog.description = blogs_params[:content]
      blog.avatar      = URI.parse(blogs_params[:image_url]) if blogs_params[:image_url].present?
      blog.save
    end
  end
end
