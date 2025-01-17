Rails.application.routes.draw do
  # Devise routes (first to avoid conflicts)
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }

  devise_scope :user do
    get "one_time_link_form", to: "users/registrations#one_time_link_form", as: :one_time_link_form
    post "one_time_link", to: "users/registrations#one_time_link", as: :one_time_link
    get "expert/profile/:id", to: "experts#show", as: :expert_profile
    get "edit/password", to: "users/registrations#edit_password", as: :edit_password
    patch "edit/password", to: "users/registrations#update", as: :update_password
    get "edit/email", to: "users/registrations#edit_email", as: :edit_email
    patch "edit/email", to: "users/registrations#update", as: :update_email
  end


  # Admin namespace for user management
  namespace :admin do
    resources :users, only: [ :index, :new, :create, :edit, :update, :destroy ]
  end

  # Other application resources
  resources :experts
  resources :projects do
    patch :add_documents, on: :member
    delete :remove_document, on: :member
  end
  resources :categories, except: [ :show ]
  resources :course_modules

  # Health check
  get "up", to: "rails/health#show", as: :rails_health_check

  # Expert modal and PWA files
  get "experts/show_modal/:id", to: "experts#show_modal", as: :expert_show_modal
  get "service-worker", to: "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest", to: "rails/pwa#manifest", as: :pwa_manifest

  # Root path
  root "home#index"
end
