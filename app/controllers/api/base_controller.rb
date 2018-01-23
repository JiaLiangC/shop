class Api::BaseController < ApplicationController

	include SessionsHelper
  	include ApplicationHelper

	protect_from_forgery with: :null_session

	before_action :destroy_session

	skip_before_action :verify_authenticity_token

	def destroy_session
		request.session_options[:skip] = true
	end
end
