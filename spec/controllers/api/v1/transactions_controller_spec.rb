require 'rails_helper'

RSpec.describe Api::V1::TransactionsController, type: :controller do
	describe "GET #index" do
		it 'success' do 
			bank_account = create :bank_account
			get :index, params: { bank_account_id: bank_account }
			expect(response).to have_http_status(:success)
		end
		it 'listing' do
			bank_account = create :bank_account
			t1 = create :transaction, :d, bank_account: bank_account
			t2 = create :transaction, :w, bank_account: bank_account
			get :index, params: { bank_account_id: bank_account }
			hash_body = JSON.parse(response.body)
			expect(hash_body['transactions'][0]).to include(
				'amount' => t1.amount, 'date' => t1.created_at.strftime("%Y-%m-%d %H:%M"), 'amount_status' => 'DR',
			)
		end
	end

	describe "POST #create" do
		it 'success' do 
			bank_account = create :bank_account
			post :create,  params: { bank_account_id: bank_account, amount: 10, state: 0 }
			expect(response).to have_http_status(:success)
		end

		it 'unprocessable_entity' do 
			bank_account = create :bank_account
			post :create,  params: { bank_account_id: bank_account, amount: 10000, state: 1 }
			expect(response).to have_http_status(:unprocessable_entity)
		end
	end
end