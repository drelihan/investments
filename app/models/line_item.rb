class LineItem < ActiveRecord::Base
  belongs_to :property
  
  EXPENSE = 0
  REVENUE = 1
  
  def self.pp_period(period)
    if period == 12 
      'Monthly'
    elsif period == 1
      'Annually'
    else
      ''
    end
  end
  
    
end
