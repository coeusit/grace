if @params.has_key?('message') && @params.has_key?('user_id') && (@session.is_admin || @params['user_id'] == @session.user_id)
  u = User.where(:uuid => @params['user_id']).first
  if u != nil
    _inp = {
      :user_id => u.id,
      :content => @params['message'],
      :outgoing => @session.is_admin
    }
    _sm = SupportMessage.create(_inp)
    @response = {
      :action => 'update_support_message',
      :response => {
        :support_message => [{
          :uuid => _sm.uuid,
          :user_id => _sm.user.uuid,
          :content => _sm.content,
          :sent_at => _sm.sent_at,
          :read_at => _sm.read_at,
          :deleted => _sm.deleted,
          :outgoing => _sm.outgoing
          }]
      }
    }
    u_admin = User.where(:admin => true).first
    admin_id = (u_admin == nil ? nil : u_admin.uuid)
    _push = {
      :user_id => (_sm.outgoing ? _sm.user.uuid : admin_id),
      :message => _response
    }
    $ch.push _push
  end
end
