class SessionsController < ApplicationController

    def new
        if logged_in?
            redirect_to root_path
        end
    end

    def create
        user = User.find_by(email: params[:session][:email].downcase)
        if user&.authenticate(params[:session][:password])
            session[:user_id] = user.id
            redirect_to root_path
        else
            flash[:alert] = "Wrong username or password"
            render 'new'
        end
    end

    def destroy
        session[:user_id] = nil
        flash[:alert] = "Successfully logged out"
        redirect_to root_path
    end
end