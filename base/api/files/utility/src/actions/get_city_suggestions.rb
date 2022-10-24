if @params.has_key?('phrase')
  suggestions = []
  results = City.where(Sequel.like(:name, "#{@params['phrase']}%", case_insensitive: true)).order(:name).limit(5)
  results.each do |_c|
    suggestions << _c[:name]
  end
  @response = {
    :action => 'update_city_suggestions',
    :response => suggestions
  }
end
