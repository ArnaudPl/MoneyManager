Rails.application.routes.draw do

  scope "(:locale)", locale: /en|fr/ do
    resources :accounts
    resources :users
    resources :transactions

    root 'welcome#index'

    get '/login' => 'sessions#new'
    post '/login' => 'sessions#create'
    get '/logout' => 'sessions#destroy'

    get '/signup' => 'users#new'
    post '/users' => 'users#create'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
