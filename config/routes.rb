Rails.application.routes.draw do
  root to: 'welcome#index'

  namespace :api do
    resources :companies, only: :index do
      get 'update', on: :collection
    end
  end
end
