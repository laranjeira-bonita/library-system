require 'rails_helper'

RSpec.describe AuthorsController, type: :controller do
  let(:valid_attributes) { { name: "Jane Austen", biography: "An English novelist" } }
  let(:invalid_attributes) { { name: "", biography: "" } }
  let!(:author) { Author.create(valid_attributes) }

  describe 'GET #index' do
    it 'assigns all authors to @authors' do
      get :index
      expect(assigns(:authors)).to eq([author])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested author to @author' do
      get :show, params: { id: author.id }
      expect(assigns(:author)).to eq(author)
    end

    it 'assigns all books of the author to @books' do
      book = Book.create(title: "Pride and Prejudice", author: author)
      get :show, params: { id: author.id }
      expect(assigns(:books)).to eq([book])
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new author' do
        expect {
          post :create, params: { author: valid_attributes }
        }.to change(Author, :count).by(1)
      end

      it 'redirects to the authors list with a success notice' do
        post :create, params: { author: valid_attributes }
        expect(flash[:notice]).to eq("#{assigns(:author).name} was successfully created.")
        expect(response).to redirect_to(authors_path)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new author' do
        expect {
          post :create, params: { author: invalid_attributes }
        }.to_not change(Author, :count)
      end

      it 'redirects to the authors list with a failure notice' do
        post :create, params: { author: invalid_attributes }
        expect(flash[:alert]).to eq("Failed: Name can't be blank")
        expect(response).to redirect_to(authors_path)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the requested author' do
        patch :update, params: { id: author.id, author: { name: "Updated Name", biography: "Updated Biography" } }
        author.reload
        expect(author.name).to eq("Updated Name")
        expect(author.biography).to eq("Updated Biography")
      end

      it 'redirects to the authors list with a success notice' do
        patch :update, params: { id: author.id, author: { name: "Updated Name", biography: "Updated Biography" } }
        expect(flash[:notice]).to eq("#{assigns(:author).name} was successfully updated.")
        expect(response).to redirect_to(authors_path)
      end
    end

    context 'with invalid attributes' do
      it 'does not update the author' do
        patch :update, params: { id: author.id, author: invalid_attributes }
        author.reload
        expect(author.name).to eq("Jane Austen")
        expect(author.biography).to eq("An English novelist")
      end

      it 'redirects to the authors list with a failure notice' do
        patch :update, params: { id: author.id, author: invalid_attributes }
        expect(flash[:alert]).to eq("Failed: Name can't be blank")
        expect(response).to redirect_to(authors_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested author' do
      expect {
        delete :destroy, params: { id: author.id }
      }.to change(Author, :count).by(-1)
    end

    it 'redirects to the authors list with a success notice' do
      delete :destroy, params: { id: author.id }
      expect(flash[:notice]).to eq("#{assigns(:author).name} was successfully deleted.")
      expect(response).to redirect_to(authors_path)
    end

    context 'when destroy fails' do
      before do
        author.books.create(title: 'Sample Book', synopsis: 'A synopsis')
      end

      it 'does not destroy the author' do
        author.books.create()
        expect {
          delete :destroy, params: { id: author.id }
        }.to_not change(Author, :count)
      end

      it 'redirects to the authors list with a failure notice' do
        delete :destroy, params: { id: author.id }
        expect(flash[:alert]).to include('has books')
        expect(response).to redirect_to(authors_path)
      end
    end
  end
end
