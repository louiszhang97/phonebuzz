require 'twilio-ruby'

class LogEntryController < ApplicationController
  skip_before_action :verify_authenticity_token

  def replay
    puts params
    @response = Twilio::TwiML::VoiceResponse.new
    @entry = LogEntry.find(params[:id])
    (1..@entry.number.to_i).each do |i|
      puts fizzbuzz(i)
      @response.say(fizzbuzz(i))
    end
    render :xml => @response.to_xml
  end

  def fizzbuzz(n)
    if n % 3 == 0 && n % 5 == 0
      return 'fizzbuzz'
    elsif n % 3 == 0
      return 'fizz'
    elsif n % 5 == 0
      return 'buzz'
    else
      return n.to_s
    end
  end

end
