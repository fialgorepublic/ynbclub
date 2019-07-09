class MediumBlogsService
  include HTTParty

  attr_reader :doc, :next_page, :tag, :blogs_urls, :blogs_slugs, :blogs

  BASE_URL             = 'https://medium.com/search'
  JSON_BASE_URL        = 'https://medium.com/search/posts?format=json'
  BLOGS_XPATH          = "//div[contains(@class, 'js-postListHandle')]/div[contains(@class, 'js-block')]"
  BLOGS_CONTENT_XPATH  = "//div[contains(@class, 'postArticle-content')]//div[contains(@class, 'section-content')]"
  SECOND_CONTECT_XPATH = "//section[contains(@class, 'li')]//div[contains(@class, 'lk')]"

  def initialize(tag, page)
    @tag = tag
    @next_page = page
  end

  def get_blogs
    @blogs_urls  = []
    @blogs_slugs = []
    @blogs       = []
    search_blogs
  end

  private

  def search_blogs
    get_json_from_medium
    get_blogs_by_slugs
    puts "Blogs URLS", blogs_urls
    get_blogs_content
    [blogs, next_page, next_page - 2]
  end

  def get_json_from_medium
    json_response = HTTParty.get("#{JSON_BASE_URL}&#{query_params}")
    set_page_count(json_response)
  end

  def query_params
    "q=#{tag}&page=#{next_page}"
  end

  def set_page_count(json_response)
    json_response.to_s.slice!('])}')
    json_response.to_s.slice!('while(1)')
    json_response.to_s.slice!('</x>')

    json_response = JSON.parse(json_response.to_s[1..-1])

    paging = json_response['payload']['paging']
    next_obj = paging['next'].presence
    get_slugs(json_response['payload']['value']) if json_response['payload']['value'].present?
    # get_blogs_by_slugs
    # get_blogs_content
    if next_obj.present?
      @next_page = next_obj['page']
    else
      @next_page = 0
    end
  end

  def get_slugs(blogs)
    blogs.each { |blog| blogs_slugs << blog['slug'] }
  end

  def get_blogs_by_slugs
    blogs_slugs.each do |slug|
      http_reposne = HTTParty.get(URI.parse(URI.escape("#{BASE_URL}?q=#{slug}")))
      doc = Nokogiri::HTML(http_reposne)
      get_blogs_urls(doc)
    end
  end

  def get_blogs_urls(doc)
    return unless doc
    div_element = doc.xpath(BLOGS_XPATH)[0]#.each_with_index do |div_element, index|
    blogs_urls << div_element.css('.postArticle-content').css('a')[0]['href'] if div_element.present?
  end

  def get_blogs_content
    blogs_urls.each do |blog_page_url|
      begin
        doc = Nokogiri::HTML(open("#{blog_page_url}"))
        create_blog(medium_own_format_scrape(doc))
      rescue OpenURI::HTTPError => ex
        puts "URL not found"
      end
    end
  end

  # def other_format_scrape(content_div)
  #   blog_title  = content_div.css('.graf--title')&.text()
  #   content_div.search('img').remove
  #   content_div.search('h1').remove
  #   content_div.search('.js-postMetaLockup').remove
  #   content_div.search('.graf-after--h3').remove
  #   [blog_title, content_div.to_html]
  # end

  def medium_own_format_scrape(doc)
    sections = doc.css('#root').css('section')
    content = ''
    sections.shift
    sections.each do |section|
      next if section.inner_text.blank?
      children = section.children
      break if children.first.name == 'ul' && (children.first.classes.any? { |class_name| class_name.in? ['bl', 'bm', 'bk'] } || children.last.inner_text.include?('responses'))
      content << section.inner_text
    end
    title     = doc.css("meta[property='og:title']").attr('content').value.split(' - ')[0]
    image_url = doc.css("meta[property='og:image']").attr('content').value
    { title: title, content: content, image_url: image_url }
  end

  def create_blog(blog_params)
    blogs << Blog.find_or_create_by(title: blog_params[:title]) do |blog|
      blog.description = blog_params[:content]
      blog_params[:image_url].present? ? download_and_attach_image(blog, blog_params[:image_url]) : blog.attach_default_image
    end
  end

  def download_and_attach_image(blog, image_url)
    downloaded_image = open(image_url)
    blog.avatar.attach(io: downloaded_image, filename: image_url.split('/').last, content_type: downloaded_image.content_type)
  end
end
