require 'yaml'

class Resource < Action
  def execute
    logger = Mlog.new
    opt = { :operation => nil, :resource => nil, :resources => nil, :data => nil, :encapsulation => false, :callback_id => nil }.merge(@params)
    logger.info "Performing resource request #{opt.to_s}"
  end
end
