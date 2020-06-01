class UnsplashService
  PER_PAGE = 10
  
  attr_reader :name, :page
  
  def initialize(name:, page:)
    @name = name
    @page = page
  end
  
  def fetch_image
    begin
      Unsplash::Photo.search(name, page, PER_PAGE)
    rescue Exception => e
      []
    end
  end
end
