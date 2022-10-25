logger = Logger.new(STDOUT)
User.create(
  :password => @config['seed_admin_pwd_dev'],
  :enabled => true,
  :admin => true,
  :email => @config['seed_admin_email']
)
logger.info "Generated user #{@config['seed_admin_email']}"
