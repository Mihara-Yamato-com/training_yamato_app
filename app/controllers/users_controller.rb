class UsersController < ApplicationController
    before_action :authenticate_user!
    
    def index 
        @users = User.all
    end
    
    def show
        @user = current_user
    end
    #def new
    #end
end
