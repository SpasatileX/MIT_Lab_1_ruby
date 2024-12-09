require 'yaml'
require 'fileutils'

# Function to create product catalog and categories
def create_product_catalog(products)
  base_dir = './config/yaml_config/products'
  # Check if the base directory exists, if not, create it
  FileUtils.mkdir_p(base_dir)

  # Iterate through each category
  products.each do |category, items|
    category_dir = "#{base_dir}/#{category}"
    
    # Create directory for each category
    FileUtils.mkdir_p(category_dir)

    items.each_with_index do |product, index|
      # Generate file path for each product
      product_file = "#{category_dir}/product_#{index + 1}.yaml"

      # Product data
      product_data = {
        name: product[:name],
        price: product[:price],
        description: product[:description],
        image_url: product[:image_url],
        category: category
      }

      # Write product data to YAML file
      File.open(product_file, 'w') { |f| f.write(product_data.to_yaml) }
    end
  end
end

# Example product data
products = {
  'Refrigerators' => [
    { name: 'LG Smart Fridge', price: 1200, description: 'High-end refrigerator with smart features', image_url: 'http://example.com/lg-fridge.jpg' },
    { name: 'Samsung Fridge', price: 900, description: 'Energy-efficient fridge with modern design', image_url: 'http://example.com/samsung-fridge.jpg' }
  ],
  'Stoves' => [
    { name: 'GE Gas Stove', price: 500, description: 'Reliable gas stove for home use', image_url: 'http://example.com/ge-gas-stove.jpg' },
    { name: 'Whirlpool Electric Stove', price: 600, description: 'High-performance electric stove', image_url: 'http://example.com/whirlpool-electric-stove.jpg' }
  ]
}

# Create catalog and store product data
create_product_catalog(products)
