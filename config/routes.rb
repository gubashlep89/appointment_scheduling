Rails.application.routes.draw do
  root 'doctors#index'

  devise_for :doctors, controllers: {
    sessions: 'doctors/sessions'
  }

  resources :patients, only: %i[index show edit update]
  resources :doctors, only: :index do
    resources :appointments, only: %i[new index create]
  end
end
