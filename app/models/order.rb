class Order < ApplicationRecord
  STATUS = [
    'DRAFT',
    'OPEN',
    'CLOSE',
    'CANCEL'
  ]

  belongs_to :user
  delegate :id, :name,
           to: :user, prefix: true, allow_nil: true

  has_one  :sale, dependent: :destroy
  has_many  :order_details, dependent: :destroy
  has_many  :entities, as: :entity

  has_paper_trail

  scope :is_open, -> (id) { where("orders.id = ? AND orders.state = 'OPEN'", id) }
  scope :search, -> (keyword) {
    where("LOWER(orders.customer) like ?", "%#{keyword}%")
  }
  scope :filter_open, -> { where("orders.state = 'OPEN' OR orders.state = 'DRAFT'") }
  scope :filter_open_only, -> { where("orders.state = 'OPEN'") }
  scope :filter_close, -> { where("orders.state = 'CLOSE'") }

  scope :by_tenant, -> (tenant) {
    joins(order_details: [:menu]).where("menus.tenant_id = ?", tenant)
  }

  scope :filter_status, -> (status) { where("orders.state = ?", status) }
  scope :filter_date, -> (start_date, end_date) { where(created_at: start_date..end_date) }

  before_create :ensure_status
  before_create :ensure_order_number

  def ensure_status
    self.state = 'DRAFT'
  end

  def ensure_order_number
    self.code = generate_order_number
  end

  def self.filter_order(user, params = {})
    status = params[:status].blank? ? 'OPEN' : params[:status]

    orders = self.all
    orders = by_tenant(user.tenant.id) if user.tenant?
    orders = orders.filter_status(status)
    unless params[:start_date].blank?
      start_date = params[:start_date] ? params[:start_date].to_date.beginning_of_day : Time.now.beginning_of_day
      end_date = params[:start_date] ? params[:start_date].to_date.end_of_day : Time.now.end_of_day

      orders = orders.filter_date(start_date, end_date)
    end

    orders.order("created_at DESC").distinct
  end

  def total_amount
    total = 0

    items = order_details.filter_deliver
    if self.buffet
      items = order_details.filter_deliver.exclude_buffet
      total = self.buffet_price * self.pax
    end

    items.each do |detail|
      total = total + (detail.qty * detail.price.to_f)
    end

    total
  end

  def total_amount_buffet
    if self.buffet
      buffet_price = Option.where(option_name: 'buffet_price').first.option_value.to_f

      if buffet_include_beverage

      end
    end
  end

  def order_tax
    total_amount.to_f * 0.1
  end

  def order_service
    total_amount.to_f * 0.05
  end

  def total_amount_tax
    enable_service = Option.where(option_name: 'enable_service').first.option_value.eql?('true')
    total = total_amount + order_tax

    if enable_service
      total = total + order_service
    end

    total
  end

  def order_qty
    if self.buffet
      order_details.filter_deliver.exclude_buffet.sum('qty') + self.pax rescue 0
    else
      order_details.filter_deliver.sum('qty') rescue 0
    end
  end

  # Order Status
  def draft?
    state.eql?('DRAFT')
  end

  def open?
    state.eql?('OPEN')
  end

  def close?
    state.eql?('CLOSE')
  end

  def cancel?
    state.eql?('CANCEL')
  end

  def confirm!(user = nil)
    ActiveRecord::Base.transaction do
      # Set Buffet To Order
      buffet_mode = Option.where(option_name: 'buffet_mode').first.option_value.eql?('true')
      if buffet_mode && self.buffet
        buffet_price = Option.where(option_name: 'buffet_price').first.option_value.to_f
        update_attributes({state: 'OPEN', buffet_price: buffet_price})
      else
        update_attribute(:state, 'OPEN')
      end

      details = order_details.filter_draft

      PrintingCoJob.perform_later(self, details.map{|detail| detail}, user)
      PrintingToJob.perform_later(self, details.map{|detail| detail}, user)

      captain_order = Option.where(option_name: 'enable_captain_order').first
      details.each do |detail|
        if (!captain_order.blank? && captain_order.option_value.eql?('true'))
          detail.to_deliver!
        else
          detail.to_pending!
        end
      end
    end
  end

  def confirm_by_tenant!(tenant_id)
    ActiveRecord::Base.transaction do
      update_attribute(:state, 'OPEN')
      order_details.filter_draft.map{ |detail|
        detail.to_onprogress! if detail.menu.tenant_id == tenant_id
      }
    end
  end

  def close!
    ActiveRecord::Base.transaction do
      update_attribute(:state, 'CLOSE')
      order_details.filter_draft_pending.map{ |detail| detail.system_to_rejected! }
    end
  end

  def cancel!
    ActiveRecord::Base.transaction do
      update_attribute(:state, 'CANCEL')
      order_details.map{ |detail| detail.system_to_rejected! }
    end
  end

  # Order response JSON
  def order_json_format
    {
      id: id,
      code: code,
      customer: customer,
      user: {
        id: user_id,
        name: user_name
      },
      status: state,
      created_at: created_at,
      updated_at: updated_at
    }
  end

  private

  def generate_order_number
    loop do
      date = Time.now.utc.strftime('%y%m%d').to_s
      token = date + rand(5 ** 5).to_s
      break token unless Order.where(code: token).first
    end
  end
end
