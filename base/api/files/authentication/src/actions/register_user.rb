@response = {
  :action => 'registration_response',
  :response => {
    :status => false
  }
}
if !@session.is_authenticated
  if @params.has_key?('email') && @params.has_key?('password')
    if User.where(:email => @params['email']).count == 0
      lang_en = Language.where(:code => 'en').first
      lang_id = (lang_en == nil ? nil : lang_en.id)
      city = City.where(:name => @params['city']).first
      city_id = (city == nil ? nil : city.id)
      country = Country.where(:code => @params['country']).first
      country_id = (country == nil ? nil : country.id)
      u = User.create(
        :first_name => @params['first_name'],
        :last_name => @params['last_name'],
        :company => @params['company'],
        :phone => @params['phone'],
        :address_line_1 => @params['address_line_1'],
        :address_line_2 => @params['address_line_2'],
        :address_line_3 => @params['address_line_3'],
        :password => @params['password'],
        :enabled => true,
        :admin => false,
        :city_id => city_id,
        :city_name => @params['city'],
        :region_name => (city == nil ? nil : city.region.name),
        :country_id => country_id,
        :language_id => lang_id,
        :email => @params['email']
      )
      if u != nil
        @response = {
          :action => 'registration_response',
          :response => {
            :status => true
          }
        }
      end
    end
  end
end
