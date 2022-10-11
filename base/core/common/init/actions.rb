Dir.glob('./lib/common/actions/**/*.rb').each do |file|
  add_action(file[21..-4], Action, File.open(file).read)
end
Dir.glob('./actions/**/*.rb').each do |file|
  add_action(file[10..-4], Action, File.open(file).read)
end
