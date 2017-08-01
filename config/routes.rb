Rails.application.routes.draw do
  devise_for :users, path: 'auth',
                     path_names: { sign_in: 'login', sign_out: 'logout' },
                     skip: [:registrations],
                     controllers: { sessions: 'sessions' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :dashboard, only: [:index]
  resources :log, only: [:index, :show]
  resources :roles
  resources :options
  resources :users do
    member do
      post :import_player_id
    end
  end
  resources :tenants, except: [:show]
  resources :categories, except: [:show]
  resources :menus do
    member do
      put :available
      put :sold_out
    end
    collection do
      post :bulk_available
    end
  end
  resources :orders, except: [:destroy] do
    member do
      put  :confirm
      put  :cancel
      put  :set_normal
      resources :order_details do
        collection do
          put :confirm
          put :deliver
          put :reject
          get :reject
        end
      end
      resources :sales do
        collection do
          get :bill
        end
      end
    end
  end
  resources :notifications, only: [:index, :show]
  resources :reports do
    collection do
      get :closing_order
      get :cashier_revenue
    end
  end

  namespace :iam do
    resources :permissions
    resources :roles
  end

  namespace :iam do
    resources :permissions
    resources :roles
  end

  namespace :pos do
    get 'bulk_bill', to: 'sales#bulk_bill'

    resources :orders do
      member do
        put  :confirm
        resources :order_details do
          get :delete
        end
        resources :sales, except: [:index, :destroy, :show]
      end
      collection do
        resources :sales, only: [:index] do
          collection do
            get :bill
            get :calculate_discount
          end
        end
      end
    end
  end

  mount ActionCable.server => '/cable'
  mount API => '/'
  root 'dashboard#index'
end
