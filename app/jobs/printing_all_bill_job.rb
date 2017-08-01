class PrintingAllBillJob < ApplicationJob
  queue_as :default

  def perform(user)
    printer_location = Option.where(option_name: 'cashier_printer').first

    unless printer_location.blank?
      @orders = Order.all.filter_open

      @orders.each do |order|
        sale = Sale.new({
          order_id: order.id,
          user_id: user.id,
          amount: order.total_amount_tax,
          bill_only: true
        })
        sale.prepare_discount

        logo = ApplicationController.helpers.logo_paper.unpack("H*").first
        page = render_printing_template(sale, order)

        page_encode = page.unpack("H*").first

        `echo #{logo}#{page_encode} | xxd -r -p | nc #{printer_location.option_value} 9100`
      end
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
end
