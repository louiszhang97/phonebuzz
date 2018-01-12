require 'twilio-ruby'
require 'phonelib'
require 'rufus-scheduler'
class PhonebuzzController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index

  end

  def dial
    puts params
    delay_min = Integer(params[:delay_min]) rescue false
    delay_seconds = Integer(params[:delay_seconds]) rescue false
    if delay_min && delay_seconds
      if Phonelib.valid? params[:phone_num]
        scheduler = Rufus::Scheduler.new
        delay_in_seconds = (delay_min * 60 + delay_seconds).to_s + 's'
        puts delay_in_seconds + ' delay'
        flash[:success] = 'Phonebuzz will call you ' + delay_in_seconds + ' from ' + Time.now.to_formatted_s(:db)

        scheduler.in delay_in_seconds do
          @client = Twilio::REST::Client.new(Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_account_auth_token)
          @call = @client.calls.create(
            url: Rails.application.secrets.application_url + '/phonebuzz/call',
            to: params[:phone_num],
            from: '+15102414092'
          )
          puts 'calling'
        end
      else
        puts 'invalid num'
        flash[:alert] = 'Please enter a valid phone 10-digit number'
      end
    else
      flash[:alert] = 'Please enter a valid delay time to call you'
    end
    redirect_to '/'
  end

  def handle_request
    @request_validator = Twilio::Security::RequestValidator.new(Rails.application.secrets.twilio_account_auth_token)
    request_params = params.reject {|k| k.downcase == k}
    x_twilio_sig = request.headers['HTTP_X_TWILIO_SIGNATURE']

    @response = Twilio::TwiML::VoiceResponse.new
    if @request_validator.validate(request.original_url, request_params, x_twilio_sig)
      # response.say('Please enter a number.')
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
    (1..params['Digits'].to_i).each do |i|
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
