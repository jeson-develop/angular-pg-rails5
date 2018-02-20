Rails.application.routes.draw do
  root to: 'home#index'
  namespace :api do
  	namespace :v1 do
	  resources :bank_accounts do
	  	member do
	  		get :balance
	  	end
	  	resources :transactions do
	  	end	
	  end	
  	end
  end	
end
