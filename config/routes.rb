Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :coaches
      resources :members
      resources :courses

      resources :schedules do
        collection do
          post :batch_create
        end
      end

      resources :bookings do
        member do
          post :cancel
        end
      end

      resources :check_ins, only: [:index, :show, :create]
    end
  end
end
