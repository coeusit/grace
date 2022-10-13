if @args.length == 0
  @logger.error 'No project name specified'
else
  project_name = @args[0]
  if File.directory?(project_name)
    @logger.error "Directory #{project_name} already exists"
  else
    @logger.info "Creating project #{project_name}"
    Dir.mkdir project_name
    amqp = ask('Enable AMQP? [y/N] ')
    amqp = amqp.downcase == 'y' ? true : false
    @logger.info amqp ? 'Enabling AMQP' : 'Omitting AMQP'
    smtp_conf = { :relay => {}, :common => {} }
    smtp = ask('Enable SMTP? [Y/n] ')
    smtp = smtp.downcase == 'n' ? false : true
    @logger.info smtp ? 'Enabling SMTP' : 'Omitting SMTP'
    if smtp
      smtp_conf[:relay][:RELAY_HOST] = ask('SMTP host? ')
      smtp_conf[:relay][:RELAY_PORT] = ask('SMTP port? ')
      smtp_conf[:relay][:RELAY_USERNAME] = ask('SMTP username? ')
      smtp_conf[:relay][:RELAY_PASSWORD] = ask('SMTP password? ')
      smtp_conf[:common][:SMTP_DOMAIN] = ask('Sender domain? ex: example.com ')
      smtp_conf[:common][:SMTP_FROM] = ask('Default From address? (ex: John Doe <john.doe@example.com>) ')
      smtp_conf[:common][:SMTP_SENDER] = ask('Default sender account? (ex: john.doe@example.com) ')
      smtp_conf[:common][:SMTP_TESTER] = ask('Default SMTP testing recipient? (ex: john.doe@example.com) ')
    end
    phpmyadmin = ask('Include PHPMyAdmin in development stack? [Y/n] ')
    phpmyadmin = phpmyadmin.downcase == 'n' ? false : true
    @logger.info phpmyadmin ? 'Enabling PHPMyAdmin' : 'Omitting PHPMyAdmin'
    Dir["#{$basepath}/base/core/."].each do |f|
      FileUtils.cp_r(f, "./#{project_name}")
    end
    if smtp
      if smtp_conf[:relay] != nil
        f = File.open("./#{project_name}/docker-conf/.env.smtp", 'w')
        smtp_conf[:relay].each do |l,v|
          f.puts
        end
      end
    end
    dc_y = {}
    [:development, :staging, :production].each do |_env|
      env_vars = {
        'COMPOSE_PROJECT_NAME' => "#{project_name}_#{_env.to_s}",
        'RUBY_ENV' => _env.to_s,
        'MYSQL_ROOT_PASSWORD' => 'mysql',
        'MYSQL_ROOT_HOST' => '%',
        'MYSQL_HOST' => 'db',
        'MYSQL_DATABASE' => "#{project_name}_#{_env.to_s}",
        'MYSQL_USER' => project_name,
        'MYSQL_PASSWORD' => project_name,
        'REDIS_HOST' => 'redis://redis:6379/0',
        'PWD_SALT' => Faker::Alphanumeric.alphanumeric(number: 128)
      }
      dc_y[_env] = {
        'version' => '3.3',
        'volumes' => {
          'db-data' => {
            'external' => false
          }
        },
        'services' => {
          'db' => {
            'env_file' => "./docker-conf/.env.#{_env.to_s}",
            'image' => 'mariadb:latest',
            'restart' => 'always',
            'volumes' => [
              'db-data:/var/lib/mysql'
            ]
          },
          'redis' => {
            'image' => 'redis:alpine',
            'restart' => 'always'
          }
        }
      }
      if smtp
        dc_y[_env]['services']['smtp'] = {
          'env_file' => './docker-conf/.env.smtp',
          'image' => 'bytemark/smtp',
          'restart' => 'always'
        }
        if smtp_conf[:common] != nil
          smtp_conf[:common].each do |l,v|
            env_vars[l.to_s] = v
          end
        end
      end
      if phpmyadmin && _env == :development
        dc_y[_env]['services']['phpmyadmin'] = {
          'env_file' => "./docker-conf/.env.#{_env.to_s}",
          'image' => 'phpmyadmin',
          'restart' => 'always',
          'depends_on' => [
            'db'
          ],
          'ports' => [
            '8925:80'
          ],
          'environment' => [
            'PMA_ARBITRARY=1'
          ]
        }
        env_vars['PMA_HOST'] = 'db'
        env_vars['PMA_USER'] = project_name
        env_vars['PMA_PASSWORD'] = project_name
      end
      if amqp
        dc_y[_env]['services']['rabbitmq'] = {
          'image' => 'rabbitmq:alpine',
          'restart' => 'always'
        }
        env_vars['AMQP_HOST'] = 'rabbitmq'
      end
      dc_fname = "docker-compose#{_env == :production ? '' : ".#{_env.to_s}"}.yml"
      File.open("./#{project_name}/#{dc_fname}", 'w') { |f| f.write(dc_y[_env].to_yaml) }
      File.open("./#{project_name}/docker-conf/.env.#{_env.to_s}", 'w') do |f|
        env_vars.each do |k,v|
          f.puts "#{k}=\"#{v}\""
        end
      end
    end
    @logger.info 'Downloading Grace framework..'
    system("sh ./#{project_name}/update-grace.sh")
    @logger.info 'Creation complete'
  end
end
