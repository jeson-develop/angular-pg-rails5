require 'rails_helper'

RSpec.describe Api::V1::BankAccountsController, type: :controller do

	describe "GET #index" do
		it 'success' do 
			get :index
			expect(response).to have_http_status(:success)
		end
		it 'listing' do
			bank_account = create :bank_account
			get :index
			hash_body = JSON.parse(response.body)
			expect(hash_body['bank_accounts'][0]).to include(
				{ 'username' => bank_account.username, 'id' => bank_account.id }
			)
		end
	end

	describe "GET #balance" do
		let(:bank_account) { create :bank_account }
		it 'success' do 
			get :balance,  params: { id: bank_account.id }
			expect(response).to have_http_status(:success)
		end
		it 'result' do
			bank_account.transaction(0, 100)
			get :balance,  params: { id: bank_account.id }
			hash_body = JSON.parse(response.body)
			expect(hash_body).to include({ 'balance' => 100.0 })
		end
	end

	describe "GET #show" do
		let(:bank_account) { create :bank_account }
		it 'success' do 
			get :show,  params: { id: bank_account.id }
			expect(response).to have_http_status(:success)
		end
		it 'result' do
			bank_account.transaction(0, 100)
			get :show,  params: { id: bank_account.id }
			hash_body = JSON.parse(response.body)
			expect(hash_body).to include({ 'username' => bank_account.username, 'id' => bank_account.id })
		end
	end

	describe "POST #create" do
		it 'success' do 
			post :create,  params: { bank_account: { username: 'temp' } }
			expect(response).to have_http_status(:success)
		end

		it 'unprocessable_entity' do 
			post :create,  params: { bank_account: { username: 'temp' } }
			expect(response).to have_http_status(:unprocessable_entity)
		end
	end
end