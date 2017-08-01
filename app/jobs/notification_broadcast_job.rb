class NotificationBroadcastJob < ApplicationJob
  queue_as :default

  def perform(notification)
    ActionCable.server.broadcast(
      "activity_channel_#{notification.user_id}",
      notification: render_notification(notification)
    )
  end

  private

  def render_notification(notification)
    ApplicationController.renderer.render(
      partial: 'notifications/shared/notification',
      locals: { notification: notification }
    )
  end
end
