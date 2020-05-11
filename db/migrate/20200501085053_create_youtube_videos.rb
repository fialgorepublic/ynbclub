class CreateYoutubeVideos < ActiveRecord::Migration[5.2]
  def change
    create_table :youtube_videos do |t|
      t.string :title
      t.string :url
      t.string :thumbnail

      t.timestamps
    end
  end
end
