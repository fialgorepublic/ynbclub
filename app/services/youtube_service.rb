class YoutubeService
  CHANNEL_ID = "UCwKS0IH1Kw2fkGYNHlOKLNQ"

  def self.get_channel_videos
    channel = Yt::Channel.new id: CHANNEL_ID
    channel.videos
  end
end
