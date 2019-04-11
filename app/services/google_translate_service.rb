class GoogleTranslateService

  attr_reader :translate, :text

  def initialize(text)
    project_id = ENV["CLOUD_PROJECT_ID"]
    @translate = Google::Cloud::Translate.new project: project_id
    @text      = text
  end

  def translate_text
    translate.translate "#{text}", to: "vi"
  end
end
