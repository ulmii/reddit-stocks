Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :stocks
      resources :reddit_stocks
    end
  end
end
