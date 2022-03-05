Rails.application.routes.draw do
  resources :rules do
    collection do
      get :templates
    end

    member do
      get :activity
    end
  end

  post '/webhooks/receive', to: 'callback#receive'

  root to: 'home#index'

  mount ShopifyApp::Engine, at: '/'
end
