class PrintingJob < ApplicationJob
  queue_as :default

  def perform(order, template)
    tenants = order.order_details.filter_draft.map(&:tenant_id).uniq

    case template
    when 'captain_order'
      printer_location = Option.where(option_name: 'captain_order_printer').first

      unless printer_location.blank?
        tenants.each do |id|
          detail = order.order_details.filter_draft.where(tenant_id: id)
          page = render_printing_template(order, detail)

          puts page
          `echo "#{page} \x1B@\x1DV1" | nc #{printer_location.option_value} 9100`
        end
      end
    when 'table_order'
      printer_location = Option.where(option_name: 'table_order_printer').first

      unless printer_location.blank?
        detail = order.order_details.filter_draft
        page = render_printing_template(order, detail)

        puts page
        `echo "#{page} \x1B@\x1DV1" | nc #{printer_location.option_value} 9100`
      end
    end
  end

  private

  def render_printing_template(order, details)
    ApplicationController.renderer.render(
      partial: 'orders/shared/printing_template',
      locals: {
        order: order,
        order_details: details
      }
    )
  end
end
