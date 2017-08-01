# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class ActivityChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "activity_channel_#{current_user.id}"
    if current_user.waitres?
      stream_from "activity_channel_waitres"
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_all_streams
  end
end
