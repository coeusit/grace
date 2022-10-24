if @session.is_authenticated && @params.has_key?('new_pwd') && @params.has_key?('old_pwd')
  u = User.where(:uuid => @session.user_id).first
  if u != nil
    if u.authenticate(@params['old_pwd'])
      if u.otp_secret == nil
        u.update(:password => @params['new_pwd'])
        @response = {
          :action => 'server_notice',
          :response => {
            :msg => 'Password updated',
            :color => 'primary'
          }
        }
      elsif @params.has_key?('otp_code')
      end
    else
      @response = {
        :action => 'server_notice',
        :response => {
          :msg => 'Incorrect password',
          :color => 'red'
        }
      }
    end
  end
end
