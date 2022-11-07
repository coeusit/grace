tmpl_path = "#{File.dirname(__FILE__)}/files"
default_ws_port = 42001
default_rest_port = 80
service_modes = []
if (enable_ws = ask('Enable Websocket? [Y/n] ').downcase) != 'n'
  if (ws_port = ask("Websocket port? (#{default_ws_port}) ").to_i) == 0
    ws_port = default_ws_port
  end
  if ws_port == 80
    default_rest_port = 81
  end
  enable_ws = true
  service_modes << 'websocket'
else
  enable_ws = false
end
if (enable_rest = ask('Enable REST? [y/N] ').downcase) == 'y'
  if (rest_port = ask("REST port? (#{default_rest_port.to_s})").to_i) == 0
    rest_port = default_rest_port
  end
  enable_rest = true
  service_modes << 'rest'
else
  enable_rest = false
end
enable_resource = ask('Enable Resource? [Y/n] ').downcase == 'n' ? false : true
enable_auth = ask('Add authentication functions? [Y/n] ').downcase == 'n' ? false : true
enable_otp = ask('Add OTP functions? [Y/n] ').downcase == 'n' ? false : true
enable_chat = ask('Add chat functions? [Y/n] ').downcase == 'n' ? false : true
enable_contact = ask('Add contact functions? [Y/n] ').downcase == 'n' ? false : true
enable_gstorage = ask('Add Gcloud Storage functions? [Y/n] ').downcase == 'n' ? false : true
if enable_gstorage
  gcloud_storage_name = ask('Gcloud Storage project name: ')
  gcloud_storage_bucket = ask('Main Gcloud Storage bucket: ')
end
enable_cms = ask('Add CMS functions? [Y/n] ').downcase == 'n' ? false : true
enable_utility = ask('Add utility functions? [Y/n] ').downcase == 'n' ? false : true
seed_admin_email = ask('Admin email? ')
seed_admin_pwd_dev = ask('Admin password in development? ')
seed_admin_pwd_prod = ask('Initial admin pasword in production? ')
seed_dev_country = ask('Country for development? [US] ').upcase
if seed_dev_country == ''
  seed_dev_country = 'US'
end

Dir.mkdir("./#{@s_name}")
FileUtils.cp_r("#{tmpl_path}/base/.","./#{@s_name}")
src = File.read("./#{@s_name}/Dockerfile")
src.gsub!('#name', @s_name)
File.open("./#{@s__name}/Dockerfile", 'w') {|f| f.puts src }
@logger.info "Installed base"
if enable_resource
  FileUtils.cp_r("#{tmpl_path}/resource/.","./#{@s_name}")
  @logger.info "Installed resource"
end
if enable_auth
  FileUtils.cp_r("#{tmpl_path}/authentication/.","./#{@s_name}")
  @logger.info "Installed auth"
end
if enable_chat
  FileUtils.cp_r("#{tmpl_path}/chat/.","./#{@s_name}")
  @logger.info "Installed chat"
end
if enable_cms
  FileUtils.cp_r("#{tmpl_path}/cms/.","./#{@s_name}")
  @logger.info "Installed cms"
end
if enable_otp
  FileUtils.cp_r("#{tmpl_path}/otp/.","./#{@s_name}")
  @logger.info "Installed otp"
end
if enable_utility
  FileUtils.cp_r("#{tmpl_path}/utility/.","./#{@s_name}")
  @logger.info "Installed utility"
end

settings = {}
settings['server'] = service_modes.join(',')
settings['seed_admin_email'] = seed_admin_email
settings['seed_admin_pwd_dev'] = seed_admin_pwd_dev
settings['seed_admin_pwd_prod'] = seed_admin_pwd_prod
settings['seed_dev_country'] = seed_dev_country
if enable_gstorage
  settings['gcloud_project_name'] = gcloud_storage_name
  settings['gcloud_project_bucket'] = gcloud_storage_bucket
  settings['gcloud_credentials'] = './lib/common/config/gcloud.json'
end
File.open("./#{@s_name}/src/config/grace.yml", 'w') { |f| f.write(settings.to_yaml) }
@logger.info "Installed config"

dc_root = YAML.load_file("./docker-compose.yml")
dc = {}
dc[@s_name] = {}
dc[@s_name]['hostname'] = @s_name
dc[@s_name]['env_file'] = './docker-conf/.env.production'
dc[@s_name]['restart'] = 'always'
dc[@s_name]['build'] = {}
dc[@s_name]['build']['context'] = '.'
dc[@s_name]['build']['dockerfile'] = "./#{@s_name}/Dockerfile"
dc[@s_name]['depends_on'] = ['db']
dc[@s_name]['ports'] = []
if enable_ws
  dc[@s_name]['ports'] << "#{ws_port}:80"
end
if enable_rest
  dc[@s_name]['ports'] << "#{rest_port}:81"
end
dc_root['services'].merge!(dc)
File.open("./docker-compose.yml", 'w') { |f| f.write(dc_root.to_yaml) }
@logger.info "Updated production docker-compose file"

dc_root = YAML.load_file("./docker-compose.staging.yml")
dc = {}
dc[@s_name] = {}
dc[@s_name]['hostname'] = @s_name
dc[@s_name]['env_file'] = './docker-conf/.env.staging'
dc[@s_name]['restart'] = 'always'
dc[@s_name]['build'] = {}
dc[@s_name]['build']['context'] = '.'
dc[@s_name]['build']['dockerfile'] = "./#{@s_name}/Dockerfile"
dc[@s_name]['depends_on'] = ['db']
dc[@s_name]['ports'] = []
if enable_ws
  dc[@s_name]['ports'] << "#{ws_port}:80"
end
if enable_rest
  dc[@s_name]['ports'] << "#{rest_port}:81"
end
dc_root['services'].merge!(dc)
File.open("./docker-compose.staging.yml", 'w') { |f| f.write(dc_root.to_yaml) }
@logger.info "Updated staging docker-compose file"

dc_root = YAML.load_file("./docker-compose.development.yml")
dc = {}
dc[@s_name] = {}
dc[@s_name]['hostname'] = @s_name
dc[@s_name]['env_file'] = './docker-conf/.env.development'
dc[@s_name]['restart'] = 'no'
dc[@s_name]['build'] = {}
dc[@s_name]['build']['context'] = '.'
dc[@s_name]['build']['dockerfile'] = "./#{@s_name}/Dockerfile"
dc[@s_name]['depends_on'] = ['db']
dc[@s_name]['volumes'] = ["./#{@s_name}/src:/app",'./common:/app/lib/common','./grace/fw:/app/lib/fw']
dc[@s_name]['ports'] = []
if enable_ws
  dc[@s_name]['ports'] << "#{ws_port}:80"
end
if enable_rest
  dc[@s_name]['ports'] << "#{rest_port}:81"
end
dc_root['services'].merge!(dc)
File.open("./docker-compose.development.yml", 'w') { |f| f.write(dc_root.to_yaml) }
@logger.info "Updated development docker-compose file"
