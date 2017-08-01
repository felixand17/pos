class PrintingToJob < ApplicationJob
  queue_as :default

  def perform(order, details, user)
    tenants = details.map(&:tenant_id).uniq

    printer_location = Option.where(option_name: 'table_order_printer').first

    unless printer_location.blank?
      page = render_printing_template(order, details, user)
      page_encode = page.unpack("H*").first

      `echo #{page_encode} | xxd -r -p | nc #{printer_location.option_value} 9100`
    end
  end

  private

  def render_printing_template(order, details, user)
    ApplicationController.renderer.render(
      partial: 'orders/shared/table_order',
      locals: {
        order: order,
        order_details: details,
        user: user
      }
    )
  end
end
