if @session.is_authenticated != nil
  u = User.where(:uuid => @session.user_id).first
  if u != nil
    otp_secret = ROTP::Base32.random
    totp = ROTP::TOTP.new(otp_secret, issuer: ENV['OTP_ISSUER'])
    @response = {
      :action => 'set_otp',
      :response => {
        :otp_secret => otp_secret,
        :otp_uri => totp.provisioning_uri(u.email)
      }
    }
  end
end
