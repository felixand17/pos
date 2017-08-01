class LogController < ApplicationController
  authorize_resource :class => false

  def index
    @logs = Log.order('id DESC').page(params[:page]).per(100)
  end
end
