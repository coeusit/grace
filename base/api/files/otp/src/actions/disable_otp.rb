if @session.is_authenticated && @params.has_key?('otp_attempt')
  u = User.where(:uuid => @session.user_id).first
  if u != nil
    otp_secret = u.otp_secret
    totp = ROTP::TOTP.new( otp_secret, issuer: ENV['OTP_ISSUER'] )
    last_otp_at = totp.verify( @params['otp_attempt'], after: u.last_otp_at, drift_behind: 15 )
    if last_otp_at
      u.update(:otp_secret => nil, :last_otp_at => nil)
      @session.set_otp_passed(false)
      @session.set_otp_enabled(false)
      @response = [{
        :action => 'server_notice',
        :response => {
          :msg => 'OTP disabled',
          :color => 'red'
        }
      },{
        :action => 'set_otp',
        :response => {
          :otp_enabled => false,
          :otp_passed => false
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
