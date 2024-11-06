class UsersController < ApplicationController
    before_action :set_user, only: [:show, :update, :destroy]
    def index
        @users = User.all
    end

    def show
        @rentals = @user.rentals
    end

    def create
        @user = User.create(permitted_params) 
        @user.persisted? ? success_notice('create') : failed_notice
        redirect_to users_path
    end
    
    def update
        @user.update(permitted_params) ? success_notice('update') : failed_notice
        redirect_to user_path
    end
    
    def destroy
        @user.destroy ? success_notice('delete') : failed_notice
        redirect_to users_path
    end

    private
    def set_user
        @user = User.find(params[:id])
    end

    def permitted_params
        params.require(:user).permit(:name, :email)
    end

    def success_notice(action_name)
        flash[:notice] = "#{@user.name} was successfully #{action_name}d."
    end

    def failed_notice
        flash[:alert] = "Failed: #{@user.errors.full_messages.join('. ')}"
    end
end
