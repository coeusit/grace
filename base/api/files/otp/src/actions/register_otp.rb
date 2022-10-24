if @session.is_authenticated && @params.has_key?('otp_attempt') && @params.has_key?('otp_secret')
  u = User.where(:uuid => @session.user_id).first
  if u != nil
    otp_secret = @params['otp_secret']
    totp = ROTP::TOTP.new(otp_secret, issuer: ENV['OTP_ISSUER'])
    last_otp_at = totp.verify(@params['otp_attempt'], drift_behind: 15)
    if last_otp_at
      u.update(:otp_secret => otp_secret, :last_otp_at => last_otp_at)
      @session.set_otp_passed(true)
      @session.set_otp_enabled(true)
      @response = [{
        :action => 'server_notice',
        :response => {
          :msg => 'OTP enabled',
          :color => 'green'
        }
      },{
        :action => 'set_otp',
        :response => {
          :otp_passed => true,
          :otp_enabled => true
        }
      }]
    else
      @response = {
        :action => 'server_notice',
        :response => {
          :msg => 'OTP verification failed',
          :color => 'red'
        }
      }
    end
  end
end
