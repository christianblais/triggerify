Rails.application.routes.draw do
  mount ShopifyApp::Engine, at: '/'

  resources :rules do
    resources :handlers
  end

  root to: 'rules#index'
end
