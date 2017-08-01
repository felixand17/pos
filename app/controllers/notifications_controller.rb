class NotificationsController < ApplicationController
  load_and_authorize_resource

  def index
    @notifications = {}
    current_user.notifications.reverse.each do |notif|
      notif.to_read!

      if @notifications["#{notif.created_at.strftime('%Y-%m-%d')}"].blank?
        @notifications["#{notif.created_at.strftime('%Y-%m-%d')}"] = []
      end

      @notifications["#{notif.created_at.strftime('%Y-%m-%d')}"] << {
        id: notif.id,
        user_id: notif.user_id,
        message: notif.message,
        is_read: notif.is_read,
        entity_id: notif.entity_id,
        entity_type: notif.entity_type,
        created_at: notif.created_at,
        updated_at: notif.updated_at
      }
    end
  end

  def show
    notification = current_user.notifications.where(id: params[:id]).first
    notification.to_read!

    if !notification.entity_id.blank? && notification.entity_type.eql?('Order')
      return redirect_to edit_pos_order_path(notification.entity_id) if current_user.waitres?
      return redirect_to edit_order_path(notification.entity_id)
    end

    redirect_to orders_path
  end
end


