Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  root 'computers#index'
  resources :computers do
    collection do
      post :import
      post 'modify', to: 'computers#modify', as: 'modify'
    end
  end
  resources :staffs do
    collection do
      get 'search', to: 'staffs#search', as: 'search'
      post :import
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
