class GoogleTranslateService

  attr_reader :translate, :text

  ENV["CLOUD_PROJECT_ID"] = 'saintlbeau'
  ENV["GOOGLE_APPLICATION_CREDENTIALS"] = 'config/google_cloud.json'

  def initialize(text)
    project_id = ENV["CLOUD_PROJECT_ID"]
    @translate = Google::Cloud::Translate.new version: :v2, project_id: project_id
    @text      = text
  end

  def translate_text
    translate.translate "#{text}", to: "vi"
  end
end
