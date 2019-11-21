module OrdersHelper
  def friday_delivery
    d = Date.today
    ((d + 1)..(d + 7)).find { |d| d.cwday == 5 }
  end
end
