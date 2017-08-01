class PrintingCoJob < ApplicationJob
  queue_as :default

  def perform(order, details, user)
    tenants = details.map(&:tenant_id).uniq

    printer_location = Option.where(option_name: 'captain_order_printer').first
    beverage_printer_location = Option.where(option_name: 'beverage_printer').first

    unless printer_location.blank?
      tenants.each do |id|
        tenant = Tenant.where(id: id).first
        items = details.map{|item| item if item.tenant_id == id}.compact

        page = render_printing_template(order, items, tenant, user)
        page_encode = page.unpack("H*").first

        printer_ip = printer_location
        printer_ip = beverage_printer_location if tenant.include_inventory && !beverage_printer_location.blank?

        2.times do
          `echo #{page_encode} | xxd -r -p | nc #{printer_ip.option_value} 9100`
        end
      end
    end
  end

  private

  def render_printing_template(order, details, tenant, user)
    ApplicationController.renderer.render(
      partial: 'orders/shared/captain_order',
      locals: {
        order: order,
        order_details: details,
        tenant: tenant,
        user: user
      }
    )
  end
end
