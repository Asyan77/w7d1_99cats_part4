class SessionsController < ApplicationController


    before_action :require_logged_out, only:[:new, :create]
    
    def new
        @user = User.new
        render :new
    end

    def create 
        @user = User.find_by_credentials(params[:user][:username],params[:user][:password])
        if @user
            login(@user)
            redirect_to cats_url
        else
            render :new
        end
    end

    def destroy
      logout    
      redirect_to "/session/new"
    end

end
