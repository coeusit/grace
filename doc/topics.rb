Dir.glob("#{$basepath}/doc/**/*").each do |f|
  if File.file?(f)
    f.slice!("#{$basepath}/doc/")
    f = File.extname(f) == '.rb' ? f[0...-3] : f[0...-4]
    result = result + "#{f.split('/').join(' ')}\r\n"
  end
end
