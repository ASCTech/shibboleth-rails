class UserSessionsController < ApplicationController

	skip_before_filter :require_shibboleth
	before_filter :not_in_production

	def new
		@users = User.all
	end

	def create
		session[:simulate_id] = params[:user_id]
		redirect_to root_url
	end

	def destroy
		session[:simulate_id] = nil
		redirect_to new_user_session_url, :notice => "Logout successful!"
	end

	private
	def not_in_production
		redirect_to root_url if Rails.env.production?
	end

end
