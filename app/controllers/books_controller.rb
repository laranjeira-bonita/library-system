class BooksController < ApplicationController
    before_action :set_book, only: [:show, :update, :destroy]
    def index
        @books = Book.all
        @authors = Author.all
    end

    def show
    end

    def create
        @book = Book.create(permitted_params) 
        @book.persisted? ? success_notice('create') : failed_notice
        redirect_to books_path
    end
    
    def update
        @book.update(update_params) ? success_notice('update') : failed_notice
        redirect_to book_path
    end
    
    def destroy
        @book.destroy ? success_notice('delete') : failed_notice
        redirect_to books_path
    end

    private
    def set_book
        @book = Book.find(params[:id])
    end

    def update_params
        permitted_params.except(:author_id)
    end

    def permitted_params
        params.require(:book).permit(:title, :synopsis, :author_id, :price_per_day)
    end

    def success_notice(action_name)
        flash[:notice] = "#{@book.title} was successfully #{action_name}d."
    end

    def failed_notice
        flash[:alert] = "Failed: #{@book.errors.full_messages.join('. ')}"
    end
end
