class PrintingCancelJob < ApplicationJob
  queue_as :default

  def perform(order, item = nil, qty = nil)
    tenants = order.order_details.filter_draft.map(&:tenant_id).uniq

    printer_location = Option.where(option_name: 'captain_order_printer').first

    unless printer_location.blank?
      page = render_printing_template(order, item, qty)
      page_encode = page.unpack("H*").first

      2.times do
        `echo #{page_encode} | xxd -r -p | nc #{printer_location.option_value} 9100`
      end
    end
  end

  private

  def render_printing_template(order, detail, qty)
    ApplicationController.renderer.render(
      partial: 'shared/cancel_menu_template',
      locals: {
        order: order,
        order_detail: detail,
        qty: qty
      }
    )
  end
end
