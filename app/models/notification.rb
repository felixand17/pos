class Notification < ApplicationRecord
  after_create_commit { NotificationBroadcastJob.perform_later self }
  after_create_commit { WebPushJob.perform_later self }

  belongs_to :user
  belongs_to :entity, polymorphic: true

  has_paper_trail

  scope :unread, -> { where("is_read = false") }

  def to_read!
    update_attribute(:is_read, true) unless is_read
  end
end
