require 'yaml'
require 'erb'
require 'json'
require 'fileutils'

module RubyParser
  class AppConfigLoader
    # Основний метод для завантаження конфігурацій
    def config(main_config_path, yaml_dir)
      # Завантажуємо основний конфігураційний файл
      @config_data = load_default_config(main_config_path)

      # Завантажуємо додаткові конфігураційні файли з вказаної директорії
      load_config(yaml_dir)

      # Якщо передано блок, обробляємо дані
      yield(@config_data) if block_given?

      @config_data
    end

    # Метод для виведення конфігураційних даних у форматі JSON
    def pretty_print_config_data
      puts JSON.pretty_generate(@config_data)
    end
    # Масив системних бібліотек
    SYSTEM_LIBRARIES = ['date', 'json', 'yaml', 'erb']

    # Масив для зберігання підключених локальних бібліотек
    @loaded_libraries = []
    def load_libs
        @loaded_libraries ||= []
      
        # Підключення системних бібліотек
        SYSTEM_LIBRARIES.each do |lib|
          next if @loaded_libraries.include?(lib)
      
          begin
            require lib
            @loaded_libraries << lib
            puts "Системна бібліотека #{lib} підключена."
          rescue LoadError
            puts "Не вдалося підключити системну бібліотеку #{lib}."
          end
        end
      
        # Підключення локальних бібліотек з директорії 'lib'
        Dir.glob(File.join('../lib', '**', '*.rb')).each do |file|
          relative_path = file.sub("#{Dir.pwd}/", '').sub(/^lib\//, '')
          unless @loaded_libraries.include?(relative_path)
            require_relative relative_path
            @loaded_libraries << relative_path
            puts "Локальна бібліотека #{relative_path} підключена."
          else
            puts "Локальна бібліотека #{relative_path} вже підключена."
          end
        end
      end

    private

    # Завантаження основного конфігураційного файлу з обробкою ERB
    def load_default_config(config_path)
      puts File.absolute_path(config_path)
      raise "Config file not found: #{config_path}" unless File.exist?(config_path)

      config_data = ERB.new(File.read(config_path)).result(binding)
      YAML.safe_load(config_data)
    end

    # Завантаження додаткових YAML файлів з вказаної директорії та їх об'єднання
    def load_config(yaml_dir)
      puts File.absolute_path(yaml_dir)
      raise "Directory not found: #{yaml_dir}" unless Dir.exist?(yaml_dir)

      Dir.glob("#{yaml_dir}/*.yaml").each do |file|
        file_data = YAML.safe_load(File.read(file))
        merge_config(file_data)
      end
    end

    # Об'єднання конфігураційних даних (заміна значень або додавання нових)
    def merge_config(new_data)
      @config_data.merge!(new_data) { |key, old_val, new_val| old_val.is_a?(Hash) ? old_val.merge(new_val) : new_val }
    end



  end
end
