class VoiceController < ApplicationController
  include Webhookable
  after_filter :set_header
  skip_before_action :verify_authenticity_token

  def start
    response = Twilio::TwiML::Response.new do |response|
      response.Gather(numDigits: '4', timeout: '10', action: check_voice_path, method: 'get') do |gather|
        gather.Say "To buzz in, please enter your four digit code, or stay on the line", voice: 'woman'
      end
      response.Redirect(real_human_voice_path, method: 'get')
    end

    render_twiml response
  end

  def check
    response = Twilio::TwiML::Response.new do |response|
      if code = Code.find_by_code(params['Digits'])
        response.Say("Thank you #{code.name}!", voice: 'woman')
        response.Play(digits: ENV['BUZZ_KEYS'])
      else
        response.Say("The code you entered, #{params['Digits']}, is not valid.", voice: 'woman')
        response.Redirect(start_voice_path, method: 'get')
      end
    end
    render_twiml response
  end

  def real_human
    response = Twilio::TwiML::Response.new do |response|
      response.Dial(ENV['FALL_THROUGH_PHONE_NUMBER'])
    end

    render_twiml response
  end
end
