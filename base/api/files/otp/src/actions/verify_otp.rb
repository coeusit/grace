if @session.authenticated && @params.has_key?('otp_attempt')
  u = User.where(:uuid => @session.user_id).first
  if u != nil
    otp_secret = u.otp_secret
    totp = ROTP::TOTP.new( otp_secret, issuer: ENV['OTP_ISSUER'] )
    last_otp_at = totp.verify( @params['otp_attempt'], after: u.last_otp_at, drift_behind: 15 )
    if last_otp_at
      u.update(:otp_secret => otp_secret, :last_otp_at => last_otp_at)
      @session.set_otp_passed(true)
      @response = [{
        :action => 'server_notice',
        :response => {
          :msg => 'OTP passed',
          :color => 'primary'
        }
      },{
        :action => 'set_otp',
        :response => {
          :otp_enabled => true,
          :otp_passed => true
        }
      }]
    else
      @response = {
        :action => 'server_notice',
        :response => {
          :msg => 'OTP code incorrect',
          :color => 'red'
        }
      }
    end
  end
end
