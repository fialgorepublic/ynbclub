desc "Get video from youtube"
namespace :get_youtube_video do
      require 'open-uri'
  task youtube_video: :environment do
    @videos = YoutubeService.get_channel_videos
    @videos.each do |video|
      puts "=================================>>>>>>>>>>>>>>>>>>>>>>>>"
      youtube_video = YoutubeVideo.find_or_create_by(url: video.id) do |youtube|
      youtube.title = video.snippet.title
      url = video.snippet.thumbnails["high"]["url"]
      filename = File.basename(URI.parse(url).path)
      file = open(url)
      youtube.thumbnail.attach(io: file, filename: filename) 
      end
    end
  end
end