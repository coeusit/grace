if require_project_root
  if @args.length == 0
    @logger.error 'No service specified'
  else
    s_name = @args[0]
    dc = YAML.load_file("./docker-compose.yml")
    if dc.key?(s_name)
      @logger.info "Removing service #{s_name} from docker-compose config"
      if dc.delete(s_name) == nil
        @logger.warn 'Service not found in docker-compose config'
      else
        File.open("./docker-compose.yml", 'w') { |f| f.write(dc.to_yaml) }
      end
    else
      @logger.error "Service #{s_name} not present in docker-compose config"
    end
  end
end
