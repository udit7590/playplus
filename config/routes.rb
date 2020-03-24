Rails.application.routes.draw do
  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  get 'heartbeat',  to: 'home#heartbeat'

  namespace :admin do
    resources :courses, concerns: :paginatable
    # TODO: Admin interface for enrollments
    # resources :enrollments, only: [:edit, :update, :index, :show]
  end

  resources :courses, only: [:index, :show] do
    get :search, on: :collection
    resources :course_providers, only: [:index]
  end

  resources :course_providers, only: [] do
    resources :course_levels, only: [:index]
  end

  resources :course_levels, only: [] do
    resources :course_batches, only: [:index]
  end

  resources :enrollments, only: [:create]

  resources :enquiries, only: [:create]
  resources :newsletters, only: [:create, :destroy]

  devise_for :users,  path: '', path_names: { sign_in: 'login', sign_up: 'register', password: 'my_password', confirmation: 'verification' },
                      controllers: {
                        registrations:      'users/registrations',
                        sessions:           'users/sessions',
                        passwords:          'users/passwords',
                        confirmations:      'users/confirmations'
                        # omniauth_callbacks: 'users/omniauth_callbacks'
                      }

  scope module: :users do
    resources :users, only: [] do
      # TODO: Should be a singular resource
      resource :preferences, only: [:edit, :update]
      resources :enrollments, only: [:show, :index]
    end
  end

  get 'contact', to: 'home#contact'
  get 'about', to: 'home#about'
  get 'privacy_policy', to: 'home#privacy_policy'
  get 'terms_and_conditions', to: 'home#terms_and_conditions'
  get 'how_to_enroll', to: 'home#how_to_enroll'
  root 'home#index'
end
