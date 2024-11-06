class RentalsController < ApplicationController
    before_action :set_rental, only: [:show, :update, :destroy, :pay, :return, :complete]
    def index
        @rentals = Rental.all
        @users = User.all
        @books = Book.all
    end

    def show
    end

    def create
        @rental = Rental.create(permitted_params) 
        @rental.persisted? ? success_notice('create') : failed_notice
        redirect_to rentals_path
    end
    
    def update
        @rental.update(update_params) ? success_notice('update') : failed_notice
        redirect_to rental_path
    end
    
    def destroy
        @rental.destroy ? success_notice('delete') : failed_notice
        redirect_to rentals_path
    end

    def pay
        @rental.pay!
        redirect_to rentals_path
    end

    def return
        @rental.return!
        redirect_to rentals_path
    end

    def complete
        @rental.complete!
        redirect_to rentals_path
    end

    private
    def set_rental
        @rental = Rental.find(params[:id])
    end

    def update_params
        permitted_params.except(:user_id, :book_id)
    end

    def permitted_params
        params.require(:rental).permit(:start_date, :end_date, :user_id, :book_id)
    end

    def success_notice(action_name)
        flash[:notice] = "Rental activity was successfully #{action_name}d."
    end

    def failed_notice
        flash[:alert] = "Failed: #{@rental.errors.full_messages.join('. ')}"
    end
end
