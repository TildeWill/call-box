class VoiceController < ApplicationController
  include Webhookable

  after_filter :set_header

  skip_before_action :verify_authenticity_token

  def start
    response = Twilio::TwiML::Response.new do |response|
      # check if window, buzz in if so
      # else prompty for code
      # let them get patched through to Will's cell

      response.Gather :numDigits => '4', :action => check_voice_path, :method => 'get' do |g|
        g.Say 'Please enter your four digit code', voice: 'alice'
      end
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
end
