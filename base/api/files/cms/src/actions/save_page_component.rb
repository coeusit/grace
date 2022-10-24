if @session.is_admin
  page = Page.where(:uuid => @params['page_id']).first
  if page != nil
    if @params['uuid'] == nil
      mi = PageComponent.create(
        :page_id => page.id,
        :parameters => @params['parameters'],
        :sorted_order => @params['sorted_order']
      )
    else
      mi = PageComponent.where(:uuid => @params['uuid']).first
      if mi != nil
        mi.update(
          :page_id => page.id,
          :uuid => @params['uuid'],
          :parameters => @params['parameters'],
          :sorted_order => @params['sorted_order']
        )
      end
    end
    if mi != nil
      @response = {
        :action => 'update_page_component',
        :response => {
          :page_component => [{
            :uuid => mi.uuid,
            :parameters => mi.parameters,
            :page_id => mi.page.uuid,
            :sorted_order => mi.sorted_order
            }]
        }
      }
    end
  end
end
