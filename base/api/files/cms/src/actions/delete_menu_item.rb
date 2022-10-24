if @session.is_admin && @params.has_key?('uuid')
  MenuItem.where(:uuid => @params['uuid']).destroy
  @response = {
    :action => 'delete_menu_item',
    :response => {
      :uuid => @params['uuid']
    }
  }
end
