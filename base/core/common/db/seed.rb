require 'yaml'
require 'json'
require './lib/common/db.rb'
require 'faker'
@config = YAML.load_file('./config/grace.yml')

langs = {}
countries = {}

if Language.all.count == 0
  j_language = JSON.parse(File.read('./lib/common/db/seed/languages.json'))
  j_language.each do |c_code,c_vals|
    langs[c_code.downcase] = Language.create(
      name: c_vals['name'],
      is_fallback: c_vals['is_fallback'],
      code: c_code.downcase
    )
    @logger.info "Generated language #{c_vals['name']}"
  end

  j_country = JSON.parse(File.read('./lib/common/db/seed/geo_data.json'))
  j_country.each do |country_code,country|
    if (ENV['RUBY_ENV'] == 'development' && country_code == @config['seed_dev_country'] || ENV['RUBY_ENV'] != 'development')
      countries[country_code.downcase] = Country.create(
        name: country['name'],
        language_id: langs[country['lang'].downcase].id,
        code: country_code
      )
      @logger.info "Generated country #{country['name']}"
      if country['regions'] != nil
        country['regions'].each do |region_name, cities|
          region = Region.create(
            name: region_name,
            country_id: countries[country_code.downcase].id
          )
          @logger.info "Generated region #{region.name}"
          cities.each do |city|
            _c = City.create(
              name: city,
              region_id: region.id
            )
            @logger.info "Generated city #{_c.name}"
          end
        end
      end
    end
  end
  case ENV['RUBY_ENV']
  when 'development'
    require './lib/common/db/seed.development.rb'
  when 'staging'
    require './lib/common/db/seed.staging.rb'
  when 'production'
    require './lib/common/db/seed.production.rb'
  end
end
