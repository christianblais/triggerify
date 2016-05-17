Rails.application.routes.draw do
  mount ShopifyApp::Engine, at: '/'

  resources :rules

  post '/webhooks/rules/:topic', to: 'callback#webhook', constraints: { topic: /.*/ }

  root to: 'rules#index'
end
