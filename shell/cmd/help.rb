if @args.length == 0
  @logger.error 'No help topic specified'
else
  topic = @args.join('/')
  if File.file?("#{$basepath}/doc/#{topic}.txt")
    file = File.open("#{$basepath}/doc/#{topic}.txt")
    puts "\r\n#{file.read}\r\n"
  else
    @logger.error 'Can\'t find help topic'
  end
end
