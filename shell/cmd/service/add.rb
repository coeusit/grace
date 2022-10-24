if require_project_root
  if @args.length == 0
    @logger.error 'No service specified'
  else
    if @args.length == 1
      @logger.error 'No template specified'
    else
      @s_name = @args[0]
      @s_template = @args[1]
      if File.directory?(@s_name)
        @logger.error "Service #{@s_name} already exists"
      else
        if !File.exist?("#{$basepath}/base/#{@s_template}/module.yml") || !File.exist?("#{$basepath}/base/#{@s_template}/setup.rb")
          @logger.error "(#{@s_template}) no valid template could be found"
        else
          @tc = YAML.load_file("#{$basepath}/base/#{@s_template}/module.yml")
          @logger.info "Installing template #{@tc['name']} to #{@s_name}"
          require "#{$basepath}/base/#{@s_template}/setup.rb"
        end
      end
    end
  end
end
