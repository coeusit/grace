@response = {
  :action => 'authenticate_user',
  :response => {
    :user_id => nil,
    :first_name => nil,
    :email => nil,
    :locale => nil,
    :is_admin => false,
    :otp_passed => false,
    :otp_enabled => false
  }
}
if @params.has_key?('email') && @params.has_key?('password')
  _user = nil
  _u = User.where(:email => @params['email'])
  if _u.count > 0
    _user = _u.first
  end
  if _user != nil && _user.authenticate(@params['password'])
    @session.set_admin(_user.admin)
    @session.set_user_id(_user.uuid)
    @session.set_otp_enabled(_user.otp_secret != nil)
    @session.set_otp_passed(false)
    @session.set_auth(true)
    _r = {
      :user_id => _user.uuid,
      :first_name => _user.first_name,
      :email => _user.email,
      :locale => _user.language != nil ? _user.language.code : nil,
      :is_admin => _user.admin,
      :otp_passed => false,
      :otp_enabled => _user.otp_secret != nil
    }
    @response = {
      :action => 'authenticate_user',
      :response => _r
    }
  end
end
