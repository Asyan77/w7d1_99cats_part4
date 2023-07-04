class UsersController < ApplicationController


    def new
        #/session/new(.:format)
        @user = User.new
        render "users/new"
        # automatically goes to users folder when specify :new
    end

    def create
        @user = User.new(user_params)
        if User.save
            redirect_to cats_url
        else
            render :new
        end
    end

    private 
    def user_params
        params.require(:user).permit(:username, :password_digest, :session_token,:age)
    end
end

