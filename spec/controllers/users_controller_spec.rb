require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { User.create(name: 'John Doe', email: 'john@example.com') }
  let(:book) { Book.create(title: 'Sample Book', synopsis: 'A synopsis', author: Author.create(name: "Jane Austen")) }

  describe 'GET #index' do
    it 'assigns all users to @users' do
      user # Ensure user is created before the test
      get :index
      expect(assigns(:users)).to eq([user])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested user to @user' do
      get :show, params: { id: user.id }
      expect(assigns(:user)).to eq(user)
    end

    it 'assigns the requested user\'s rentals to @rentals' do
      rental = Rental.create(user: user, book: book, start_date: Date.today, end_date: 2.days.from_now) # Ensure rental is associated with user
      get :show, params: { id: user.id }
      expect(assigns(:rentals)).to eq([rental])
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new user and redirects to the users list with a success notice' do
        expect {
          post :create, params: { user: { name: 'Jane Doe', email: 'jane@example.com' } }
        }.to change(User, :count).by(1)
        expect(flash[:notice]).to eq("Jane Doe was successfully created.")
        expect(response).to redirect_to(users_path)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a user and redirects to the users list with a failure notice' do
        expect {
          post :create, params: { user: { name: '', email: '' } }
        }.to_not change(User, :count)
        expect(flash[:alert]).to include("Failed")
        expect(flash[:alert]).to include("Name can't be blank")
        expect(flash[:alert]).to include("Email can't be blank")
        expect(response).to redirect_to(users_path)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the user and redirects to the user page with a success notice' do
        patch :update, params: { id: user.id, user: { name: 'John Updated', email: 'john.updated@example.com' } }
        user.reload
        expect(user.name).to eq('John Updated')
        expect(flash[:notice]).to eq("John Updated was successfully updated.")
        expect(response).to redirect_to(user_path(user))
      end
    end

    context 'with invalid attributes' do
      it 'does not update the user and redirects to the user page with a failure notice' do
        patch :update, params: { id: user.id, user: { name: '', email: 'invalid email' } }
        user.reload
        expect(user.name).not_to eq('')
        expect(flash[:alert]).to include("Name can't be blank")
        expect(response).to redirect_to(user_path(user))
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the user and redirects to the users list with a success notice' do
      user_to_delete = User.create(name: 'Delete Me', email: 'delete@example.com')
      expect {
        delete :destroy, params: { id: user_to_delete.id }
      }.to change(User, :count).by(-1)
      expect(flash[:notice]).to eq("Delete Me was successfully deleted.")
      expect(response).to redirect_to(users_path)
    end
  end
end
