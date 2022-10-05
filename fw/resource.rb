require 'yaml'

class Resource < Action
  @_schema = {}
  def load_schema(_s)
    if File.file?("./lib/schemas/#{params['resource']}.yml")
      set_schema(YAML.load_file("./lib/schemas/#{params['resource']}.yml"))
      return true
    else
      return false
    end
  end
  def set_schema(_s)
    @_schema = _s
  end
  def schema
    return @_schema
  end
  def foreign_keys
    _fk = {}
    if schema.has_key?('foreign_keys')
      _fk = schema['foreign_keys']
    end
    return _fk
  end
  def where_from_params
    _where = {}
    if params.has_key?('where')
      params['where'].each do |_w|
        if _w.has_key?('key') && _w.has_key?('value') && schema['fields'].include?(_w['key'])
          _where[_w['key']] = _w['value']
        end
      end
    end
    return _where
  end
  def where_from_access
    _where = {}
    if schema.has_key?('where')
      if schema['where'].has_key?('anyone') && !session.is_admin
        schema['where']['anyone'].each do |k, v|
          _where[k] = eval(v)
        end
      end
    end
    return _where
  end
  def where
    _where = {}
    where_from_params.merge(where_from_access).each do |_k, _v|
      if foreign_keys.has_key?(_k)
        _foreign_entity = eval(foreign_keys[_k]['entity']).where(foreign_keys[_k]['external'].to_sym => _v).first
        if _foreign_entity != nil
          _where[_k.to_sym] = foreign_entity[foreign_keys[_k]['internal'].to_sym]
        else
          _where[_k.to_sym] = nil
        end
      else
        _where[_k.to_sym] = _v
      end
    end
    return _where
  end
  def model
    return schema.has_key?('entity') ? eval(schema['entity']) : nil
  end
  def filtered_fields(_e)
    _r = {}
    schema['fields'].each do |_f|
      if foreign_keys.has_key?(_f) && _e[_f.to_sym] != nil
        _r[_f] = eval("_e.#{foreign_keys[_f]['property']}.#{foreign_keys[_f]['external']}")
      else
        _r[_f] = _e[_f.to_sym]
      end
    end
    return _r
  end
  def _create
    _collection = []
    if params.has_key?('data')
      params['data'].each do |_entity_data|
        _input = {}
        _entity_data.each do |_k, _v|
          if schema['writable'].include?(_k)
            if foreign_keys.has_key?(_k)
              _foreign_entity = eval(foreign_keys[_k]['entity']).where(foreign_keys[_k]['external'].to_sym => _v).first
              if _foreign_entity != nil
                _input[_k.to_sym] = _foreign_entity[foreign_keys[_k]['internal'].to_sym]
              else
                _input[_k.to_sym] = nil
              end
            else
              _input[_k.to_sym] = _v
            end
          end
        end
        _input.merge!(where)
        _e = model.create(_input)
        if _e != nil
          _collection << filtered_fields(_e)
        end
      end
    end
    return _collection
  end
  def _delete
    _collection = []
    model.where(where).each do |_e|
      _collection << _e[schema['external_key'].to_sym]
    end
    model.where(where).destroy
    return _collection
  end
  def _read
    _collection = []
    _db_res = model.where(where).each do |_e|
       _collection << filtered_fields(_e)
    end
    return _collection
  end
  def _update
    _collection = []
    if params.has_key?('data') && schema.has_key?('writable')
      _input = {}
      params['data'].each do |_k,_v|
        if schema['writable'].include?(_k)
          if foreign_keys.has_key?(_k)
            _foreign_entity = eval(foreign_keys[_k]['entity']).where(foreign_keys[_k]['external'].to_sym => _v).first
            if _foreign_entity != nil
              _input[_k.to_sym] = _foreign_entity[foreign_keys[_k]['internal'].to_sym]
            else
              _input[_k.to_sym] = nil
            end
          else
            _input[_k.to_sym] = _v
          end
        end
      end
      _input.merge!(where)
      model.where(where).each do |_e|
        _e.update(_input)
        _collection << filtered_fields(_e)
      end
    end
    return _collection
  end
  def execute
    _result = false
    if params.has_key?('operation') && params.has_key?('resource') && load_schema(params['resource']) && model != nil
      case params['operation']
      when 'create'
        _data = _create
      when 'delete'
        _data = _delete
      when 'read'
        _data = _read
      when 'update'
        _data = _update
      end
      _result = {
        :action => 'resource',
        :operation => params['operation'],
        :resource => params['resource'],
        :data => _data
      }
    end
    return _result
  end
end
