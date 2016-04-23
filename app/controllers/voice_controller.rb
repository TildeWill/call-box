class VoiceController < ApplicationController
  include Webhookable

  after_filter :set_header

  skip_before_action :verify_authenticity_token

  def start
    response = Twilio::TwiML::Response.new do |response|
      # check if window, buzz in if so

      # else prompt for code
      response.Gather(numDigits: '4', timeout: '10', action: check_voice_path, method: 'get') do |g|
        g.Say 'Please enter your four digit code', voice: 'alice'
      end
      response.Redirect(real_human_voice_path, method: 'get') # let them get patched through to Will's cell
    end

    render_twiml response
  end

  def check
    return redirect_to start_voice_path unless params['Digits'] == "1234"
    response = Twilio::TwiML::Response.new do |response|
      response.Play(digits:"wwww99999")
    end

    render_twiml response
  end

  def real_human
    response = Twilio::TwiML::Response.new do |response|
      response.Dial("415-894-9455")
    end

    render_twiml response
  end
end
