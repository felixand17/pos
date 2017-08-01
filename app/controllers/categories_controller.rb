class CategoriesController < ApplicationController
  before_action :prepare_category, only: [:edit, :update, :destroy]
  load_and_authorize_resource

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash.keep[:notice] = "Menu Category is created successfully."
      redirect_to categories_path
    else
      flash.keep[:alert] = "Failed to create menu category."
      redirect_to categories_path
    end
  end

  def edit;end

  def update
    @category.update(category_params)
    redirect_to categories_path
  end

  def destroy
    @category.destroy
    flash.keep[:notice] = "Menu Category is deleted successfully."
    redirect_to categories_path
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def prepare_category
    @category = Category.where(id: params[:id]).first
  end
end
