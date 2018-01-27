class Admin::BaseController < ActionController::Base
    layout 'admin/layouts/admin'
    include SessionsHelper
  	include ApplicationHelper

    before_action :check_admin
  
    private
    	def check_admin
    		redirect_ro root_path	unless current_user && current_user.admin?
    	end

end