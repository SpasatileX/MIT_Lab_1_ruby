require 'faker'
require_relative './logger_manager'

class Item
  include Comparable
  attr_accessor :name, :price, :grade

  def initialize(params = {})
    @name = params[:name] || 'Назва відсутня'
    @price = params[:price] || 'Ціна відсутня'
    @grade = params[:grade] || 'Рейтинг відсутній'
    
    LoggerManager.log_processed_file("Ініціалізовано об'єкт item з назвою #{@name}")

    yield(self) if block_given?
  end

  def <=>(other)
    price <=> other.price
  end

  def to_s
    "Холодильник: Назва: #{name}, Ціна: #{price}, Рейтинг: #{grade}"
  end
  
  def to_h
    instance_variables.each_with_object({}) do |var, hash|
      hash[var.to_s.delete('@')] = instance_variable_get(var)
    end
  end

  def inspect
    "#<Item: #{to_h}>"
  end

  alias_method :info, :to_s

  def update
    yield(self) if block_given?
  end
end
