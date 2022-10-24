if @session.authenticated
  @session.deauth
end
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
