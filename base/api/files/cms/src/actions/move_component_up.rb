if @session.is_admin && @params.has_key?('uuid')
  pc = PageComponent.where(:uuid => @params['uuid']).first
  if pc != nil
    if pc.sorted_order > 0
      npc = PageComponent.where(:page_id => pc.page_id, :sorted_order => pc.sorted_order - 1).first
      _components = []
      if npc != nil
        npc.update(:sorted_order => npc.sorted_order + 1)
        _components.push({
          :uuid => npc.uuid,
          :parameters => npc.parameters,
          :page_id => npc.page.uuid,
          :sorted_order => npc.sorted_order
          })
      end
      pc.update(:sorted_order => pc.sorted_order - 1)
      _components.push({
        :uuid => pc.uuid,
        :parameters => pc.parameters,
        :page_id => pc.page.uuid,
        :sorted_order => pc.sorted_order
        })
      @response = {
        :action => 'update_page_component',
        :response => {
          :page_component => _components
        }
      }
    end
  end
end
