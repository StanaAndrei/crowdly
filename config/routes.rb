Rails.application.routes.draw do
  get 'sessions/new'
  get 'users/new'
    root 'static_pages#home'

    get '/help', to: 'static_pages#help'
    get '/about', to: 'static_pages#about'
    get '/contact', to: 'static_pages#contact'
    get '/signup', to: 'users#new'
    resources :users do
        member do
            get :followers, :following
        end
    end

    get '/login', to: 'sessions#new'
    post '/login', to: 'sessions#create'
    delete '/logout', to: 'sessions#destroy'

    resources :microposts, only: [:create, :destroy]

    resources :relationships, only: [:create, :destroy]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
