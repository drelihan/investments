class LineItemsController < ApplicationController
  before_filter :find_property

  def create
    @line_item = LineItem.new(params[:line_item])
    @line_item.property_id = @property.id
    
    @revenue_items = LineItem.where("property_id = #{@property.id} AND fixed_amount > 0")
    @expense_items = LineItem.where("property_id = #{@property.id} AND fixed_amount < 0")
    
    if @line_item.save
      flash[:notice] = "Added Line Item"
      @line_items = LineItem.all
    end
    
  end

  def update
  end

  def new
    @line_item = LineItem.new
  end

  def edit
  end

  def show
  end

  def destroy
    @line_item = LineItem.find(params[:id])
    @row_number = @line_item.id
    @line_item.destroy

    @revenue_items = LineItem.where("property_id = #{@property.id} AND fixed_amount > 0")
    @expense_items = LineItem.where("property_id = #{@property.id} AND fixed_amount < 0")

  end
  
  protected
  
  def find_property
    @property ||= Property.find(params[:property_id])
  end
  
  
end
