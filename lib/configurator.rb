class Configurator
    attr_reader :config
  
    def initialize
      @config = {
        run_website_parser: 0,
        run_save_to_csv: 0,
        run_save_to_json: 0,
        run_save_to_yaml: 0,
      }
    end
  
    def configure(overrides = {})
      overrides.each do |key, value|
        if @config.key?(key)
          @config[key] = value
        else
          puts "Warning: #{key} is not a valid configuration key."
        end
      end
    end
  
    def self.available_methods
      @config.keys
    end
  
    def run_actions(cart, webparsing_config)
      if @config[:run_website_parser] == 1
        cart.start_parsing(webparsing_config) #
      end
      puts "\nSaving items to files..."
      
      if @config[:run_save_to_csv] == 1
        cart.save_to_csv
      end
      if @config[:run_save_to_json] == 1
        cart.save_to_json
      end
      if @config[:run_save_to_yaml] == 1
        cart.save_to_yml
      end
    end
  end
  