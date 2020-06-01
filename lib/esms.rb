require 'httparty'

class Esms
  class << self
    API_URL = 'http://rest.esms.vn/MainService.svc/json/SendMultipleMessage_V4_get'
    API_KEY = Rails.application.credentials.esms[:api_key]
    SECRET_KEY = Rails.application.credentials.esms[:secret_key]
    BRAND_NAME = 'NhacLichhen'
    SMS_TYPE = 2

    def send_sms(to:, content:)
      response = HTTParty.get(API_URL+"?Phone=#{to}&Content=#{content}&ApiKey=#{API_KEY}&SecretKey=#{SECRET_KEY}&SmsType=#{SMS_TYPE}&Brandname=#{BRAND_NAME}")
      code_result = response["CodeResult"]
      message = code_result == "100" ? "Message sent to #{to} successfully" : response["ErrorMessage"]

      [code_result, message]
    end

  end
end
