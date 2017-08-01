class MenusController < ApplicationController
  before_action :prepare_menu, only: [
    :show, :edit, :update, :destroy, :available, :sold_out
  ]
  before_action :prepare_category, only: [:new, :edit]
  before_action :prepare_tenants, only: [:new, :edit]
  load_and_authorize_resource

  def index
    @tenants = Tenant.all.order('name ASC').map{|tenant| [tenant.name, tenant.id]}
    @menus = Menu.joins(:tenant)
                 .order('tenants.name ASC').accessible_by(current_ability)
    @menus = @menus.where(tenant_id: params[:tenant_id]) unless params[:tenant_id].blank?
  end

  def show;end

  def new
    @menu = Menu.new
  end

  def create
    @menu = Menu.new(menu_params)
    if @menu.save
      flash.keep[:notice] = "Added to List Successfully."
      redirect_to menus_path
    else
      flash.keep[:alert] = "Failed to Add Menu."
    end
  end

  def edit;end

  def update
    @menu.update(menu_params)
    redirect_to menus_path
  end

  def destroy
    @menu.destroy
    redirect_to menus_path
  end

  def sold_out
    @menu.to_sold_out!
    flash.keep[:notice] = "Status changed to Sold Out."
    redirect_to menus_path
  end

  def available
    @menu.to_available!
    flash.keep[:notice] = "Status changed to Available."
    redirect_to menus_path
  end

  def bulk_available
    Menu.filter_sold_out.update_all(availability: true)

    flash.keep[:notice] = "All menu already available."
    redirect_to menus_path
  end

  private

  def menu_params
    params.require(:menu).permit(:code, :name, :description, :price, :category_id, :tenant_id, :picture, :picture_cache)
  end

  def prepare_menu
    @menu = Menu.where(id: params[:id]).first
  end

  def prepare_category
    @category = Category.all.map{|category| [category.name, category.id]}
  end

  def prepare_tenants
    @tenants = Tenant.all.map{|tenant| [tenant.name, tenant.id]}
  end
end
