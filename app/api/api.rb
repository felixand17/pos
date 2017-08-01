class API < Grape::API
  prefix :api
  version 'v1', using: :path
  format :json

  before do
    error!("401 Unauthorized", 401) unless authenticated
  end

  helpers do
    def warden
      env['warden']
    end

    def authenticated
      return true if warden.authenticated?
      params[:access_token] && @user = User.find_by_authentication_token(params[:access_token])
    end

    def current_user
      warden.user || @user
    end
  end

  mount Foodcourt::RoleApi
  mount Foodcourt::MenuApi
  mount Foodcourt::OrderApi
  mount Foodcourt::OrderDetailApi
  mount Foodcourt::SaleApi
end
