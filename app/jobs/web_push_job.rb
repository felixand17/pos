class WebPushJob < ApplicationJob
  queue_as :default

  def perform(notification)
    player_id = notification.user.web_player_id rescue nil

    return if player_id.blank?

    params = {
      "app_id" => "0685de84-25c6-4361-9263-55a92b73751d",
      "contents" => {"en" => "Order Notification"},
      "include_player_ids" => player_id
    }

    begin
      uri = URI.parse('https://onesignal.com/api/v1/notifications')
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Post.new(uri.path,
                                    'Content-Type'  => 'application/json;charset=utf-8',
                                    'Authorization' => "Basic NTcyMDZlNmItNDg2OC00NTViLWE1NTEtMDg5NzBmMWI4NjMy")
      request.body = params.as_json.to_json
      response = http.request(request)
      Rails.logger.info response.body
    rescue => e
      Rails.logger.info e
    end
  end
end
