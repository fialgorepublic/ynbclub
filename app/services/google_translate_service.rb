class GoogleTranslateService

  attr_reader :translate, :text, :second_text, :third_text, :fourth_text

  ENV["CLOUD_PROJECT_ID"] = 'saintlbeau'
  ENV["GOOGLE_APPLICATION_CREDENTIALS"] = 'config/google_cloud.json'

  def initialize(text, second_text, third_text, fourth_text)
    project_id   = ENV["CLOUD_PROJECT_ID"]
    @translate   = Google::Cloud::Translate.new version: :v2, project_id: project_id
    @text        = text
    @second_text = second_text
    @third_text  = third_text
    @fourth_text = fourth_text
  end

  def translate_text
    translate.translate "#{text}", to: "vi"
  end
end
