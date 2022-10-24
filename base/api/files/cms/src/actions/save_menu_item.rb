if @session.is_admin
  _parent_id = nil
  if @params['parent_id'] != nil
    _pi = MenuItem.where(:uuid => @params['parent_id']).first
    if _pi != nil
      _parent_id = _pi.id
    end
  end
  if @params['uuid'] == nil
    _sorted_order = MenuItem.where(:parent_id => _parent_id).max(:sorted_order)
    if _sorted_order == nil
      _sorted_order = 0
    else
      _sorted_order = _sorted_order + 1
    end
    mi = MenuItem.create(
      :uri => @params['uri'] == nil ? '' : @params['uri'],
      :caption => @params['caption'],
      :subtitle => @params['subtitle'],
      :icon => @params['icon'],
      :sorted_order => _sorted_order,
      :public => @params['public'],
      :parent_id => _parent_id
    )
  else
    mi = MenuItem.where(:uuid => @params['uuid']).first
    if mi != nil
      mi.update(
        :uri => @params['uri'] == nil ? '' : @params['uri'],
        :caption => @params['caption'],
        :sorted_order => @params['sorted_order'],
        :subtitle => @params['subtitle'],
        :icon => @params['icon'],
        :public => @params['public'],
        :parent_id => _parent_id
      )
    end
  end
  if mi != nil
    @response = {
      :action => 'update_menu_item',
      :response => {
        :menu_item => [{
          :uuid => mi.uuid,
          :uri => mi.uri,
          :caption => mi.caption,
          :subtitle => mi.subtitle,
          :icon => mi.icon,
          :public => mi.public,
          :sorted_order => mi.sorted_order,
          :parent_id => mi.parent == nil ? nil : mi.parent.uuid
          }]
      }
    }
  end
end
