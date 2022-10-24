if @session.is_admin
  if @params['uuid'] == nil
    mi = Page.create(
      :uri => @params['uri'],
      :public => @params['public']
    )
  else
    mi = Page.where(:uuid => @params['uuid']).first
    if mi != nil
      mi.update(
        :uri => @params['uri'],
        :public => @params['public']
      )
    end
  end
  if mi != nil
    @response = {
      :action => 'update_page',
      :response => {
        :page => [{
          :uuid => mi.uuid,
          :uri => mi.uri,
          :public => mi.public
          }]
      }
    }
  end
end
