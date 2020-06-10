require 'httparty'

class Esms
  class << self

    API_URL = 'http://rest.esms.vn/MainService.svc/json/SendMultipleMessage_V4_get'
    API_KEY = Rails.application.credentials.esms[:api_key]
    SECRET_KEY = Rails.application.credentials.esms[:secret_key]
    SMS_TYPE = 8

    def send_sms(to:, content:)
      begin
        response = HTTParty.get(API_URL+"?Phone=#{to}&Content=#{content}&ApiKey=#{API_KEY}&SecretKey=#{SECRET_KEY}&SmsType=#{SMS_TYPE}")
        code_result = response["CodeResult"]
        message = code_result == "100" ? "Message sent to #{to} successfully" : response["ErrorMessage"]
        [code_result, message]
      rescue => ex
        [500, ex.message]
      end
    end

  end
end
