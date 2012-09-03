class Log < ActiveRecord::Base
  belongs_to :admin_decp_module, :class_name => 'Admin::DecpModule'
end
