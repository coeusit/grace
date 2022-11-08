_user = nil
if @params.has_key?('session_id') && @params.has_key?('session_key')
  if @session.verify_key(@params['session_id'], @params['session_key'])
    @session.set_uuid(@params['session_id'])
    @session.set_key(@params['session_key'])
  end
end
if @session.is_authenticated
  _user = User.where(:uuid => @session.user_id).first
end
@response = {
  :action => 'init',
  :response => {
    :session_id => @session.uuid,
    :session_key => @session.key,
    :user_id => (_user != nil ? _user.uuid : nil),
    :is_admin => (_user != nil ? _user.admin : false),
    :otp_passed => @session.otp_passed,
    :otp_enabled => @session.otp_enabled
  }
}
