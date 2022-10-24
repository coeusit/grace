require 'faker'

if @session.is_admin
  @mailer.send_message(to: ENV['SMTP_TESTER'], subject: Faker::Lorem.sentence, message_plain: Faker::Lorem.paragraph)
end
