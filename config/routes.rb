Rails.application.routes.draw do
  get '/auth/login', to: 'sessions#initiate_google_oauth2'
  get '/auth/google_oauth2/callback', to: 'sessions#google_oauth2_callback'
end
