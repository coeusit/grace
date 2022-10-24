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
    :organization_id => (_user.organization_id != nil ? _user.organization.uuid : nil),
    :user_id => (_user != nil ? _user.uuid : nil),
    :first_name => (_user != nil ? _user.first_name : nil),
    :email => (_user != nil ? _user.email : nil),
    :locale => (_user != nil ? _user.language.code : nil),
    :is_admin => (_user != nil ? _user.admin : false),
    :otp_passed => @session.otp_passed,
    :otp_enabled => @session.otp_enabled
  }
}
