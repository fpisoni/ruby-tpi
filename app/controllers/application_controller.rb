class ApplicationController < ActionController::Base
    helper_method :current_user, :logged_in?
    # rescue_from RoutingError, with: :route_not_found_helper

    def current_user
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def logged_in?
        !!current_user
    end

    def require_user
        if !logged_in?
            flash[:alert] = "You must be logged in to perform that action"
            redirect_to login_path
        end
    end

    # def route_not_found_helper
    #     redirect_to page_not_found_path
    # end
end
