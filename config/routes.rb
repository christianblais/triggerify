Rails.application.routes.draw do
  resources :rules do
    collection do
      get :templates
    end
  end

  # OLD
  post '/webhooks/rules/:shop_id/:topic', to: 'callback#webhook', constraints: { shop_id: /\d+/, topic: /.*/ }

  # NEW
  post '/webhooks/receive', to: 'callback#receive'

  root to: 'rules#index'

  mount ShopifyApp::Engine, at: '/'
end
