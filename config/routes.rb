Rails.application.routes.draw do
  mount ShopifyApp::Engine, at: '/'

  resources :rules

  post '/webhooks/rules/:shop_id/:topic', to: 'callback#webhook', constraints: { shop_id: /\d+/, topic: /.*/ }

  root to: 'rules#index'
end
