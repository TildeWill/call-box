class VoiceController < ApplicationController
  include Webhookable
  after_filter :set_header
  skip_before_action :verify_authenticity_token

  WILLS_CELL = "415-894-9455"

  def start
    response = Twilio::TwiML::Response.new do |response|
      response.Gather(numDigits: '4', timeout: '10', action: check_voice_path, method: 'get') do |gather|
        gather.Say "Please enter your four digit code, or please stay on the line", voice: 'woman'
      end
      response.Redirect(real_human_voice_path, method: 'get')
    end

    render_twiml response
  end

  def check
    response = Twilio::TwiML::Response.new do |response|
      if code = Code.find_by_code(params['Digits'])
        response.Say("Thank you #{code.name}!", voice: 'woman')
        response.Play(digits: "ww99999")
      else
        response.Say("The code you entered, #{params['Digits']}, is not valid.", voice: 'woman')
        response.Redirect(start_voice_path, method: 'get')
      end
    end
    render_twiml response
  end

  def real_human
    response = Twilio::TwiML::Response.new do |response|
      response.Dial(WILLS_CELL)
    end

    render_twiml response
  end
end
