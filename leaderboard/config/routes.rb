Rails.application.routes.draw do
  namespace :api do
    resources :companies, only: :index do
      get 'update', on: :collection
    end
  end
end
