Rails.application.routes.draw do
  devise_for :users, controllers: {
  registrations: "users/registrations"
}

  root "users#show"

  resources :users, only: [:index, :show, :edit, :update, :destroy]
end