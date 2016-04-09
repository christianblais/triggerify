Rails.application.routes.draw do
  mount ShopifyApp::Engine, at: '/'

  resources :rules

  root to: 'rules#index'
end
