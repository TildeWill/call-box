class CallBoxCallsController < ApplicationController
  include Webhookable

  after_filter :set_header

  skip_before_action :verify_authenticity_token

  def create
    response = Twilio::TwiML::Response.new do |response|
      response.Say "Hello?", :voice => 'alice'
      response.Say "Okay, I'll buzz you in!", :voice => 'alice'
      
      response.Play 'http://linode.rabasa.com/cantina.mp3'
    end

    render_twiml response
  end
end
