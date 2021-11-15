require 'date'

module HelperMethods
  def today
    Date.today.strftime('%d%m%y')
  end
end
