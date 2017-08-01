class PrintingCashierJob < ApplicationJob
  queue_as :default

  def perform(sale, order)
    printer_location = Option.where(option_name: 'cashier_printer').first

    unless printer_location.blank?
      logo = ApplicationController.helpers.logo_paper.unpack("H*").first

      if order.buffet
        details = order.order_details.filter_deliver.exclude_buffet
        page = render_printing_buffet_template(sale, order, details)
      else
        page = render_printing_template(sale, order)
      end

      page_encode = page.unpack("H*").first

      `echo #{logo}#{page_encode} | xxd -r -p | nc #{printer_location.option_value} 9100`
    end
  end

  private

  def render_printing_template(sale, order)
    ApplicationController.renderer.render(
      partial: 'sales/shared/bill',
      locals: {
        order: order,
        sale: sale
      }
    )
  end

  def render_printing_buffet_template(sale, order, details)
    ApplicationController.renderer.render(
      partial: 'sales/shared/buffet',
      locals: {
        order: order,
        sale: sale,
        details: details
      }
    )
  end
end
