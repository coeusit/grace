if File.exist?('./quasar.config.js')
  @logger.info "Preparing to install Quasar components"
  if ask('This command will overwrite existing data. You should only run this once. Continue? [y/N] ').downcase == 'y'
    require "#{$basepath}/base/quasar/setup.rb"
  else
    @logger.info "Aborting"
  end
else
  @logger.error "Run this command in a Quasar root folder"
end
