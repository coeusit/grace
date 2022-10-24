if @params.has_key?('uuid')
  u = User.where(:uuid => @params['uuid']).first
  if u != nil && (u.uuid == @session.user_id || @session.is_admin)
    _inp = {}
    ['first_name','last_name','email','phone','country_code','city_name','region_name','address_line_1','address_line_2','address_line_3','enabled','admin'].each do |column|
      if @params.has_key?(column)
        case column
        when 'country_code'
          c = Country.where(:code => @params['country_code']).first
          if c != nil
            _inp[:country_id] = c.id
            _inp[:country_name] = c.name
          end
        when 'city_name'
          c = City.where(:name => @params['city_name']).first
          if c != nil
            _inp[:city_id] = c.id
          end
          _inp[:city_name] = @params['city_name']
        when 'enabled'
          if @session.is_admin
            _inp[column.to_sym] = @params[column]
          end
        when 'admin'
          if @session.is_admin
            _inp[column.to_sym] = @params[column]
          end
        else
          _inp[column.to_sym] = @params[column]
        end
      end
    end
    u.update(_inp)
    @response = {
      :action => 'update_user',
      :response => {
        :user => [{
          :uuid => u.uuid,
          :first_name => u.first_name,
          :last_name => u.last_name,
          :company => u.company,
          :email => u.email,
          :phone => u.phone,
          :enabled => u.enabled,
          :admin => u.admin,
          :address_line_1 => u.address_line_1,
          :address_line_2 => u.address_line_2,
          :address_line_3 => u.address_line_3,
          :city_name => u.city_name,
          :region_name => u.region_name,
          :country_code => u.country.code,
          :avatar => u.avatar,
          :otp_enabled => u.otp_secret == nil ? false : true
          }]
      }
    }
  end
end
