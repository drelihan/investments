class PropertiesController < ApplicationController
  # GET /properties
  # GET /properties.json
  def index
    @properties = Property.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @properties }
    end
  end

  def add_line_item
    @property = Property.find(params[:id])

    @line_item = LineItem.new
  end

  def analyze
    @property = Property.find(params[:id])
    
    balance = params[:purchase_price].to_f - params[:down_payment].to_f
    rate = params[:rate].to_f / 1200
    term = params[:term].to_i
    mortgage_pi = ( balance * rate ) / ( 1 - ( 1 + rate ) ** ( -1 * term ) ) 
    mortgage_i  = balance * rate
    mortgage_p  = mortgage_pi - mortgage_i

    appreciation = params[:appreciation] ? params[:appreciation].to_f / 100 : 0 

    gross_cashflow = 0
    total_revenue = 0
    total_expenses = 0
    @property.line_items.each do |line_item|
      gross_cashflow += line_item.fixed_amount.to_f * line_item.period
      if line_item.fixed_amount.to_f > 0
        total_revenue += line_item.fixed_amount.to_f * line_item.period
      else
        total_expenses += line_item.fixed_amount.to_f * line_item.period
      end 
    end
    
    @results = Hash.new
    @results[:total_revenue]        = total_revenue 
    @results[:total_expenses]       = total_expenses 
    @results[:mortgage_pi]          = -1 * mortgage_pi
    @results[:gross_cashflow]       = gross_cashflow - mortgage_pi*12 
    @results[:mortgage_p]           = mortgage_p * 12
    @results[:mortgage_i]           = mortgage_i * 12
    @results[:depreciation]         = @property.depreciable_value / 27.5
  
    @results[:taxable_income]       = total_revenue + total_expenses - @results[:mortgage_i] - @results[:depreciation]
    @results[:income_tax]           = [@results[:taxable_income] * 0.35,0].max

    @results[:after_tax_cashflow]   = @results[:gross_cashflow] - @results[:income_tax]
    @results[:mortgage_paydown]     = mortgage_p * 12
    @results[:appreciation]         = balance * appreciation
    
    @results[:cashflow_dividend_yield]  = @results[:after_tax_cashflow] / params[:down_payment].to_f * 100

    @results[:total_wealth_addition]    = @results[:after_tax_cashflow] + @results[:mortgage_paydown] + @results[:appreciation]
    @results[:overall_yield]            = @results[:total_wealth_addition] / params[:down_payment].to_f * 100
        
  end


  # GET /properties/1
  # GET /properties/1.json
  def show
    @property = Property.find(params[:id])
    @line_item = LineItem.new

    @revenue_items = LineItem.where("property_id = #{@property.id} AND fixed_amount > 0")
    @expense_items = LineItem.where("property_id = #{@property.id} AND fixed_amount < 0")

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @property }
    end
  end

  # GET /properties/new
  # GET /properties/new.json
  def new
    @property = Property.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @property }
    end
  end

  # GET /properties/1/edit
  def edit
    @property = Property.find(params[:id])
  end

  # POST /properties
  # POST /properties.json
  def create
    @property = Property.new(params[:property])

    respond_to do |format|
      if @property.save
        format.html { redirect_to @property, notice: 'Property was successfully created.' }
        format.json { render json: @property, status: :created, location: @property }
      else
        format.html { render action: "new" }
        format.json { render json: @property.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /properties/1
  # PUT /properties/1.json
  def update
    @property = Property.find(params[:id])

    respond_to do |format|
      if @property.update_attributes(params[:property])
        format.html { redirect_to @property, notice: 'Property was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @property.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /properties/1
  # DELETE /properties/1.json
  def destroy
    @property = Property.find(params[:id])
    @property.destroy

    respond_to do |format|
      format.html { redirect_to properties_url }
      format.json { head :no_content }
    end
  end
end
