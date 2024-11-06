require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  let(:author) { Author.create(name: "Jane Austen", biography: "An English novelist") }
  let(:valid_attributes) { { title: "Pride and Prejudice", synopsis: "A classic novel", author_id: author.id, price_per_day: 5.0 } }
  let(:invalid_attributes) { { title: "", synopsis: "", author_id: nil, price_per_day: nil } }
  let!(:book) { Book.create(valid_attributes) }
  let(:user) { User.create(name: "John Doe", email: "john.doe@example.com") }

  describe 'GET #index' do
    it 'assigns all books to @books' do
      get :index
      expect(assigns(:books)).to eq([book])
    end

    it 'assigns all authors to @authors' do
      get :index
      expect(assigns(:authors)).to eq([author])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested book to @book' do
      get :show, params: { id: book.id }
      expect(assigns(:book)).to eq(book)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new book' do
        expect {
          post :create, params: { book: valid_attributes }
        }.to change(Book, :count).by(1)
      end

      it 'redirects to the books list with a success notice' do
        post :create, params: { book: valid_attributes }
        expect(flash[:notice]).to eq("#{assigns(:book).title} was successfully created.")
        expect(response).to redirect_to(books_path)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new book' do
        expect {
          post :create, params: { book: invalid_attributes }
        }.to_not change(Book, :count)
      end

      it 'redirects to the books list with a failure notice' do
        post :create, params: { book: invalid_attributes }
        expect(flash[:alert]).to include("Title can't be blank")
        expect(response).to redirect_to(books_path)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the requested book' do
        patch :update, params: { id: book.id, book: { title: "Updated Title", synopsis: "Updated Synopsis", price_per_day: 6.0 } }
        book.reload
        expect(book.title).to eq("Updated Title")
        expect(book.synopsis).to eq("Updated Synopsis")
        expect(book.price_per_day).to eq(6.0)
      end

      it 'redirects to the book show page with a success notice' do
        patch :update, params: { id: book.id, book: { title: "Updated Title", synopsis: "Updated Synopsis", price_per_day: 6.0 } }
        expect(flash[:notice]).to eq("#{assigns(:book).title} was successfully updated.")
        expect(response).to redirect_to(book_path(book))
      end
    end

    context 'with invalid attributes' do
      it 'does not update the book' do
        patch :update, params: { id: book.id, book: invalid_attributes }
        book.reload
        expect(book.title).to eq("Pride and Prejudice")
        expect(book.synopsis).to eq("A classic novel")
      end

      it 'redirects to the books list with a failure notice' do
        patch :update, params: { id: book.id, book: invalid_attributes }
        expect(flash[:alert]).to include("Title can't be blank")
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested book' do
      expect {
        delete :destroy, params: { id: book.id }
      }.to change(Book, :count).by(-1)
    end

    it 'redirects to the books list with a success notice' do
      delete :destroy, params: { id: book.id }
      expect(flash[:notice]).to eq("#{assigns(:book).title} was successfully deleted.")
      expect(response).to redirect_to(books_path)
    end

    context 'when destroy fails' do
      before do
        allow(book).to receive(:destroy).and_return(false)
        book.rentals.create(start_date: 2.days.ago, end_date: 2.days.from_now, user_id: user.id, status: :rent_out)

        book.errors.add(:base, "Failed to delete book")
      end

      it 'does not destroy the book' do
        expect {
          delete :destroy, params: { id: book.id }
        }.to_not change(Book, :count)
      end

      it 'redirects to the books list with a failure notice' do
        delete :destroy, params: { id: book.id }
        expect(flash[:alert]).to include("#{book.title} has rentals")
        expect(response).to redirect_to(books_path)
      end
    end
  end
end
