Rails.application.routes.draw do
  get 'home/index'

  root to: 'home#index'

  get 'press', to: 'press#index'
  get 'tr', to: 'tr#index'
  get 'admin', to: 'admin#index'
  get 'employment', to: 'employment#index'
  get 'order', to: 'order#index'
  get 'blog', to: 'blog#index'

  get '/payment', to: redirect('http://tinyurl.com/cheese-invoice')

  get 'logout',
      controller: 'sessions',
      action: 'destroy'

  match 'login', via: [:get, :post],
                 controller: 'sessions',
                 action: 'new'

  %w[404 422 500].each do |code|
    get code, to: 'errors#show', code: code
  end

  resources :articles
  resources :sessions
  resources :products
  resources :accounts

  namespace :user do
    resources :orders
    resources :contacts
    resources :users
  end

  namespace :admin do
    get 'fulfillment', to: 'fulfillment#index'
    resources :salespeople
    resources :states
    resources :towns
    resources :distributors
    resources :distribution_centers
    resources :trade_items
    resources :users do
      member do
        get 'undestroy'
      end
    end
    resources :articles
    resources :products
    resources :notes
    resources :reports do
      collection do
        get 'sales_activity'
      end
    end
    resources :contacts do
      member do
        get 'undestroy'
        get 'repeat_last_order'
      end
    end
    resources :orders do
      member do
        get 'fulfill'
        get 'unfulfill'
        get 'invoice'
        get 'update_invoice'
      end
    end
  end
end
