class VoiceController < ApplicationController
  include Webhookable
  after_filter :set_header
  skip_before_action :verify_authenticity_token

  WILLS_CELL = "415-894-9455"

  def start
    response = Twilio::TwiML::Response.new do |response|
      response.Gather(numDigits: '4', timeout: '10', action: check_voice_path, method: 'get') do |g|
        g.Say "Please enter your four digit code, or please stay on the line", voice: 'alice'
      end
      response.Redirect(real_human_voice_path, method: 'get')
    end

    render_twiml response
  end

  def check
    response = Twilio::TwiML::Response.new

    if params['Digits'] == "1234"
      response.Play(digits:"wwww99999")
    else
      response.Say("The code you entered, #{paprams['Digits']}, is not valid, please try again.", voice: 'alice')
      response.Redirect(start_voice_path, method: 'get')
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
