Rails.application.routes.draw do

  scope "(:locale)", locale: /en|fr|CH-fr/ do
    resources :accounts do
      resources :transactions
    end
    resources :users

    root 'welcome#index'

    get '/login' => 'sessions#new'
    post '/login' => 'sessions#create'
    get '/logout' => 'sessions#destroy'

    get '/signup' => 'users#new'
    post '/users' => 'users#create'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
