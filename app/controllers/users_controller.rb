class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :admin_only, only: [:index, :destroy]
    
    def index 
        @users = User.all
    end
    
    def show
        @user = current_user
    end

    def destroy
    end

    private 

    def admin_only
        redirect_to user_path(current_user), alert: "権限がありません" unless current_user.admin?
    end
    #def new
    #end
end
