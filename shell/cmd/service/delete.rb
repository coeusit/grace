if require_project_root
  if @args.length == 0
    @logger.error 'No service specified'
  else
    s_name = @args[0]
    if File.directory?(s_name)
      @logger.warn "YOU ARE ABOUT TO DELETE #{s_name}"
      @logger.warn "If you want to remove #{s_name} from your project without deleting its files, use \"unlink\" instead of \"delete\""
      proceed = ask('Are you sure you want to proceed? [Y/n] ')
      if proceed.downcase == 'y'
        @logger.info "Deleting #{s_name}"
        FileUtils.remove_dir(s_name)
        dc = YAML.load_file("./docker-compose.yml")
        dc.delete(s_name)
        File.open("./docker-compose.yml", 'w') { |f| f.write(dc.to_yaml) }
      else
        @logger.info 'Aborting deletion'
      end
    end
  end
end
