class ItemsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  def index
    if params[:user_id]
      user = find_user
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user, status: :found
  end

  def show
    item = Item.find(params[:id])
    render json: item
  end

  def create
    if params[:user_id]
      user = find_user
      item = user.items.create(item_params)
    else 
      item = Item.create(item_params)
    end
      render json: item, status: :created
  end
  

  private 
  def find_user
    User.find(params[:user_id])
  end

  def item_params
    params.permit(:name, :description, :price, :user_id)
  end

  def render_not_found_response(exception)
    render json: { error: "#{exception.model} not found" }, status: :not_found
  end

end
