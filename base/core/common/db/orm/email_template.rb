class EmailTemplate < Sequel::Model
end
EmailTemplate.plugin :update_or_create
