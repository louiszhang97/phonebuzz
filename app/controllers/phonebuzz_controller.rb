require 'twilio-ruby'
require 'phonelib'
require 'rufus-scheduler'
class PhonebuzzController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @log_entries = LogEntry.all.order(date: :desc)
  end

  def replay
    @log_entry = LogEntry.find(params[:log_id])
    @client = Twilio::REST::Client.new(Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_account_auth_token)
    @call = @client.calls.create(
      url: Rails.application.secrets.application_url + '/log_entry/replay/' + @log_entry.id.to_s,
      to: @log_entry.phone_num,
      from: Rails.application.secrets.twilio_phone_number
    )
    flash[:success] = 'Dialing ' + @log_entry.phone_num + ' and replaying Fizzbuzz up to ' + @log_entry.number.to_s
    LogEntry.create(:date => Time.now.to_formatted_s(:db), :delay => 0, :number => @log_entry.number, :direction => 'Outgoing (Replay)', :phone_num => @log_entry.phone_num)
    redirect_to '/'
  end

  def dial
    delay_min = Integer(params[:delay_min]) rescue false
    delay_seconds = Integer(params[:delay_seconds]) rescue false
    if delay_min && delay_seconds && params[:phone_num].length == 10
      if Phonelib.valid? params[:phone_num]
        scheduler = Rufus::Scheduler.new
        delay_in_seconds = delay_min * 60 + delay_seconds
        flash[:success] = 'Phonebuzz will call you ' + delay_in_seconds.to_s + ' seconds from ' + Time.now.to_formatted_s(:db)
        scheduler.in (delay_in_seconds.to_s + 's') do
          LogEntry.create(:date => Time.now.to_formatted_s(:db), :delay => delay_in_seconds, :direction => 'Outgoing', :phone_num => '+1' + params[:phone_num])

          @client = Twilio::REST::Client.new(Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_account_auth_token)
          @call = @client.calls.create(
            url: Rails.application.secrets.application_url + '/phonebuzz/connect_outgoing_call',
            to: params[:phone_num],
            from: Rails.application.secrets.twilio_phone_number
          )
        end
      else
        flash[:alert] = 'Please enter a valid phone 10-digit number'
      end
    else
      flash[:alert] = 'Please enter a valid delay time to call you'
    end
    redirect_to '/'
  end

  def connect_outgoing_call
    @response = Twilio::TwiML::VoiceResponse.new
    @response.gather(input: 'dtmf', action: 'get_all_fizzbuzz', timeout: 5) do |gather|
      gather.say('Please enter a number to play Fizzbuzz.')
    end
    render :xml => @response.to_xml
  end

  def handle_incoming_call
    @request_validator = Twilio::Security::RequestValidator.new(Rails.application.secrets.twilio_account_auth_token)
    request_params = params.reject {|k| k.downcase == k}
    x_twilio_sig = request.headers['HTTP_X_TWILIO_SIGNATURE']

    @response = Twilio::TwiML::VoiceResponse.new
    if @request_validator.validate(request.original_url, request_params, x_twilio_sig)
      # response.say('Please enter a number.')
      LogEntry.create(:date => Time.now.to_formatted_s(:db), :delay => 0, :direction => 'Incoming', :phone_num => params['From'])
      @response.gather(input: 'dtmf', action: 'get_all_fizzbuzz', timeout: 5) do |gather|
        gather.say('Please enter a number to play Fizzbuzz.')
      end
      render :xml => @response.to_xml
    else
      @response.say('Error, Invalid request. Ending phone call')
      render @response.to_s
    end
  end

  def get_all_fizzbuzz
    @response = Twilio::TwiML::VoiceResponse.new
    entered_number = Integer(params['Digits']) rescue false
    if entered_number
      LogEntry.last.update_attribute(:number, entered_number)
      (1..params['Digits'].to_i).each do |i|
        @response.say(fizzbuzz(i))
      end
    else
      @response.say('Error. Invalid digits entered. Ending phone call')
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
