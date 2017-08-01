class OrderDetail < ApplicationRecord
  FLAG = [
    'DRAFT',
    'PENDING',
    'ONPROGRESS',
    'DELIVER',
    'REJECTED'
  ]

  ADJUSTMENT_TYPE = [
    'PLUS',
    'MINUS'
  ]

  belongs_to :order
  belongs_to :menu
  belongs_to :tenant
  has_paper_trail

  scope :filter_draft, -> { where("flag = 'DRAFT'") }
  scope :filter_pending, -> { where("flag = 'PENDING'") }
  scope :filter_draft_pending, -> { where("flag = 'DRAFT' OR flag = 'PENDING'") }
  scope :filter_deliver, -> { where("flag = 'DELIVER' OR flag = 'ONPROGRESS'") }
  scope :exclude_buffet, -> { where("buffet = false") }
  scope :include_buffet, -> { where("buffet = true") }

  scope :range_date, -> (start_date, end_date) { where(created_at: start_date..end_date) }
  scope :skip_zero_qty, -> { where("qty > 0") }

  attr_accessor :adjustment_type, :adjustment_qty

  before_create :adjust_flag
  before_create :adjust_menu
  after_commit :send_notification

  def adjust_flag
    self.flag = 'DRAFT'
  end

  def adjust_menu
    self.menu_name = self.menu.name
    self.price = self.menu.price
    self.tenant_id = self.menu.tenant_id
  end

  def update_item(params)
    if self.is_draft? || self.is_pending?
      return false if params[:qty].to_i.eql?(0)
      update_attributes(params)
    else
      ActiveRecord::Base.transaction do
        if params[:adjustment_type].eql?('PLUS')
          self.qty = self.qty + params[:adjustment_qty].to_i
          self.save
        elsif params[:adjustment_type].eql?('MINUS')
          if self.qty >= params[:adjustment_qty].to_i
            self.qty = self.qty - params[:adjustment_qty].to_i
            PrintingCancelJob.perform_later(self.order, self, params[:adjustment_qty].to_i)

            if self.qty.to_i.eql?(0)
              self.system_to_rejected!
            else
              self.save
            end
          end
        end
      end
    end
  end

  def send_notification
    if self.is_pending?
      Notification.create({
        user_id: menu.tenant.user.id,
        entity_id: order_id,
        entity_type: order.class.name,
        message: "New Order ##{order.code}: #{menu.name} (#{qty})"
      })
    elsif self.is_deliver?
      Notification.create({
        user_id: order.user.id,
        entity_id: order_id,
        entity_type: order.class.name,
        message: "Order ##{order.code}: #{menu.name} (#{qty}) ready to deliver"
      })
    end
  end

  # Flag Status
  def is_draft?
    self.flag == 'DRAFT'
  end

  def is_pending?
    self.flag == 'PENDING'
  end

  def is_on_progress?
    self.flag == 'ONPROGRESS'
  end

  def is_deliver?
    self.flag == 'DELIVER'
  end

  def is_rejected?
    self.flag == 'REJECTED'
  end

  def to_pending!
    buffet_mode = Option.where(option_name: 'buffet_mode').first.option_value.eql?('true')
    buffet_include_beverage = Option.where(option_name: 'buffet_include_beverage').first.option_value.eql?('true')
    if buffet_mode && self.order.buffet
      buffet = true
      buffet = false if self.tenant.include_inventory && !buffet_include_beverage

      update_attributes({flag: 'PENDING', buffet: buffet})
    else
      update_attribute(:flag, 'PENDING')
    end
  end

  def to_onprogress!
    update_attribute(:flag, 'ONPROGRESS')
  end

  def to_deliver!
    buffet_mode = Option.where(option_name: 'buffet_mode').first.option_value.eql?('true')
    buffet_include_beverage = Option.where(option_name: 'buffet_include_beverage').first.option_value.eql?('true')
    if buffet_mode && self.order.buffet
      buffet = true
      buffet = false if self.tenant.include_inventory && !buffet_include_beverage

      update_attributes({flag: 'DELIVER', buffet: buffet})
    else
      update_attribute(:flag, 'DELIVER')
    end
  end

  def to_rejected!(comment = nil)
    ActiveRecord::Base.transaction do
      update_attributes({flag: 'REJECTED', comment: comment})
      Notification.create({
        user_id: order.user.id,
        entity_id: order_id,
        entity_type: order.class.name,
        message: "Order ##{order.code}: #{menu.name} rejected. #{comment}"
      })
    end
  end

  def system_to_rejected!
    update_attributes({flag: 'REJECTED', comment: 'REJECTED by systems'})
  end

  def total
    qty * price
  end

  # Order Detail response JSON
  def order_detail_json_format
    sub_total = qty * price rescue 0

    {
      id: id,
      order_id: order_id,
      menu: {
        id: menu_id,
        name: menu_name,
        price: price
      },
      qty: qty,
      sub_total: sub_total,
      notes: notes,
      flag: flag,
      created_at: created_at,
      updated_at: updated_at
    }
  end
end
