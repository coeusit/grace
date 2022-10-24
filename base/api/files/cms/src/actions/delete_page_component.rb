if @session.is_admin && @params.has_key?('uuid')
  PageComponent.where(:uuid => @params['uuid']).destroy
  @response = {
    :action => 'delete_page_component',
    :response => {
      :uuid => @params['uuid']
    }
  }
end
