require 'nokogiri'
require 'open-uri'
require 'logger'

class SimpleWebsiteParser
  def initialize(config)
    @config = config
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO
  end

  def start_parse
    start_page = @config['start_page']
    product_selector = @config['product_selector']
    product_name_selector = @config['product_name_selector']
    product_price_selector = @config['product_price_selector']
    product_grade_selector = @config['product_grade_selector']

    doc = Nokogiri::HTML(URI.open(start_page))
    products = doc.css(product_selector)
    items = []

    products.each do |product|
      product_name = product.at_css(product_name_selector).text.strip rescue nil
      product_price = product.at_css(product_price_selector).text.strip rescue nil
      product_grade = product.at_css(product_grade_selector).text.strip rescue nil

      item = Item.new(
        name: product_name,
        price: product_price,
        grade: product_grade,
      )

      items << item
    end

    return items
  end
end
