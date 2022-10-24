if @session.is_admin && @params.has_key?('uuid')
  Page.where(:uuid => @params['uuid']).destroy
  @response = {
    :action => 'delete_page',
    :response => {
      :uuid => @params['uuid']
    }
  }
end
