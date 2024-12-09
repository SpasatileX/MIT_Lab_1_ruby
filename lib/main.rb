# Підключення модулів з основними класами
require_relative 'app_config_loader'
require_relative 'logger_manager'

module RubyParser
  class Main
    def run
      loader = RubyParser::AppConfigLoader.new
      loader.load_libs

      config_data = loader.config('../config/default_config.yaml', '../config/yaml_config')

      webparsing_config = config_data['web_scraping']

      configurator = Configurator.new
      configurator.configure(
        run_website_parser: 1,
        run_save_to_csv: 1,
        run_save_to_json: 1,
        run_save_to_yaml: 1,
      )

      cart = Cart.new

      configurator.run_actions(cart, webparsing_config) #

    end
  end
end

RubyParser::Main.new.run
