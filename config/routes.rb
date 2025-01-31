Rails.application.routes.draw do
  # resources :documents
   root 'documents#index'
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  resources :documents do
    member do
      get :generate_pdf
    end
  end
end
