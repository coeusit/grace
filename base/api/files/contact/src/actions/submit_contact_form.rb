if @params.has_key?('name') && @params.has_key?('company') && @params.has_key?('phone') && @params.has_key?('email') && @params.has_key?('website') && @params.has_key?('message')
  message = "A contact request has been submitted.\r\n\r\nName: #{@params['name']}\r\nCompany: #{@params['company']}\r\nEmail: #{@params['email']}\r\nPhone: #{@params['phone']}\r\nWebsite: #{@params['website']}\r\nMessage:\r\n #{@params['message']}\r\n"
  @mailer.send_message(to: ENV['SMTP_TESTER'], subject: 'Coeus-IT Contact Request', message_plain: message)
end
