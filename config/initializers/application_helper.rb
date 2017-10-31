module ApplicationHelper
  def set_class(rating)
    case rating
      when 0
       "zero-stars"
      when 1
       "one-star"
      when 2
       "two-stars"
      when 3
       "three-stars"
      when 4
       "four-stars"
      when 5
       "five-stars"
    end
  end

  def readable_date(date)
    ("<span class='date'>" + date.strftime("%b. %d, %Y %I:%M %p (%Z)") + "</span>").html_safe
  end

  def format_money(amount)
    #This breaks the app so I'm going to comment it out for now.
    
    #Money.new(amount, "USD").format
  end

  module_function :set_class
end
