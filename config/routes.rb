Rails.application.routes.draw do
  get '/auth/login', to: 'sessions#initiate_google_oauth2'
  get '/auth/google_oauth2/callback', to: 'sessions#google_oauth2_callback'

  namespace :api do
    namespace :v1 do
      resources :transactions, only: %i[index create show]
      resources :groups, only: %i[index show create update]
      resources :stocks, only: %i[index show create update]
    end
  end
end
