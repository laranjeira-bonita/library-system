require 'rails_helper'

RSpec.describe RentalsController, type: :controller do
  let(:user) { User.create(name: "John Doe", email: "john.doe@example.com") }
  let(:book) { Book.create(title: "Pride and Prejudice", synopsis: "A synopsis", author: Author.create(name: "Jane Austen"), price_per_day: 10.00) }
  let(:rental) { Rental.create(start_date: Date.today, end_date: Date.today + 7.days, user: user, book: book) }

  describe 'GET #index' do
    it 'assigns all rentals to @rentals' do
      get :index
      expect(assigns(:rentals)).to eq([rental])
    end

    it 'assigns all users to @users' do
      get :index
      expect(assigns(:users)).to eq([user])
    end

    it 'assigns all books to @books' do
      get :index
      expect(assigns(:books)).to eq([book])
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new rental' do
        expect {
          post :create, params: { rental: { start_date: Date.today, end_date: Date.today + 7.days, user_id: user.id, book_id: book.id } }
        }.to change(Rental, :count).by(1)
      end

      it 'redirects to rentals_path with a success notice' do
        post :create, params: { rental: { start_date: Date.today, end_date: Date.today + 7.days, user_id: user.id, book_id: book.id } }
        expect(response).to redirect_to(rentals_path)
        expect(flash[:notice]).to eq("Rental activity was successfully created.")
      end
    end

    context 'with invalid attributes' do
      it 'does not create a rental' do
        expect {
          post :create, params: { rental: { start_date: Date.today, end_date: Date.today - 2.days, user_id: user.id, book_id: book.id } }
        }.to_not change(Rental, :count)
      end

      it 'redirects to rentals_path with a failure notice' do
        post :create, params: { rental: { start_date: Date.today, end_date: Date.today, user_id: user.id, book_id: book.id } }
        expect(response).to redirect_to(rentals_path)
        expect(flash[:alert]).to include("Failed:")
      end
    end
  end

  describe 'PATCH #update' do
    it 'updates the rental' do
      patch :update, params: { id: rental.id, rental: { start_date: Date.today + 1.day, end_date: Date.today + 8.days } }
      rental.reload
      expect(rental.start_date).to eq(Date.today + 1.day)
      expect(rental.end_date).to eq(Date.today + 8.days)
    end

    it 'redirects to the rental path with a success notice' do
      patch :update, params: { id: rental.id, rental: { start_date: Date.today + 1.day, end_date: Date.today + 8.days } }
      expect(response).to redirect_to(rental_path(rental))
      expect(flash[:notice]).to eq("Rental activity was successfully updated.")
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the rental' do
      rental # Ensure rental is created before test
      expect {
        delete :destroy, params: { id: rental.id }
      }.to change(Rental, :count).by(-1)
    end

    it 'redirects to rentals_path with a success notice' do
      delete :destroy, params: { id: rental.id }
      expect(response).to redirect_to(rentals_path)
      expect(flash[:notice]).to eq("Rental activity was successfully deleted.")
    end
  end

  describe 'POST #pay' do
    it 'status changes into rent_out' do
      expect {
        post :pay, params: { id: rental.id }
        rental.reload
      }.to change(rental, :status).to('rent_out')
    end
  end

  describe 'POST #return' do
    it 'status changes into returned' do
      expect {
        post :return, params: { id: rental.id }
        rental.reload
      }.to change(rental, :status).to('returned')
    end
  end

  describe 'POST #complete' do
    it 'status changes into completed' do
      expect {
        post :complete, params: { id: rental.id }
        rental.reload
      }.to change(rental, :status).to('completed')
    end
  end
end
