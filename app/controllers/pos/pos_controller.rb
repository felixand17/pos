class Pos::PosController < ApplicationController
  # before_action :pos_authorization

  # def pos_authorization
  #   Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
  #   flash[:alert] = "Access denied. You are not authorized to access the requested page."
  #   redirect_to root_path
  # end
end
