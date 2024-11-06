class AuthorsController < ApplicationController
    before_action :set_author, only: [:show, :update, :destroy]
    def index
        @authors = Author.all
    end

    def show
        @books = @author.books
    end

    def create
        @author = Author.create(permitted_params) 
        @author.persisted? ? success_notice('create') : failed_notice
        redirect_to authors_path
    end
    
    def update
        @author.update(permitted_params) ? success_notice('update') : failed_notice
        redirect_to authors_path
    end
    
    def destroy
        @author.destroy ? success_notice('delete') : failed_notice
        redirect_to authors_path
    end

    private
    def set_author
        @author = Author.find(params[:id])
    end

    def permitted_params
        params.require(:author).permit(:name, :biography)
    end

    def success_notice(action_name)
        flash[:notice] = "#{@author.name} was successfully #{action_name}d."
    end

    def failed_notice
        flash[:alert] = "Failed: #{@author.errors.full_messages.join('. ')}"
    end
end
