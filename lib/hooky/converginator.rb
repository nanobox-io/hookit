module Hooky
  class Converginator
    
    def initialize(map, list)
      @map = map
      @list = list
    end

    def converge!
      output = {}
      @map.each do |key, template|
        if @list.key? key
          output[key] = converge_value template, @list[key]
        else
          output[key] = template[:default]
        end
      end
      output
    end

    def converge_value(template, value)
      if valid? template, value
        value
      else
        template[:default]
      end
    end

    def valid?(template, value)
      valid_type?(template, value) and valid_value?(template, value)
    end

    def valid_type?(template, value)
      case template[:type]
      when :array
        valid_array? template, value
      when :byte
        valid_byte? value
      when :file
        valid_file? value
      when :folder
        valid_folder? value
      when :hash
        valid_hash? value
      when :integer
        valid_integer? value
      when :on_off
        valid_on_off? value
      when :string
        valid_string? value
      end
    end

    def valid_value?(template, value)

      return true if not template.key? :from

      if template[:type] == :array
        !( value.map {|element| template[:from].include? element} ).include? false
      else
        template[:from].include? value
      end
    end

    def valid_string?(element)
      element.is_a? String
    end
   
    def valid_array?(template, value)

      return false if not value.is_a? Array

      return true if not template.key? :of

      case template[:of]
      when :byte
        !( value.map {|element| valid_byte? element} ).include? false
      when :file
        !( value.map {|element| valid_file? element} ).include? false
      when :folder
        !( value.map {|element| valid_folder? element} ).include? false
      when :integer
        !( value.map {|element| valid_integer? element} ).include? false
      when :on_off
        !( value.map {|element| valid_on_off? element} ).include? false
      when :string
        !( value.map {|element| valid_string? element} ).include? false
      else
        true
      end
    end
   
    def valid_hash?(value)
      value.is_a? Hash
    end
   
    def valid_integer?(value)
      value.is_a? Integer || (value.to_i.to_s == value.to_s)
    end
   
    def valid_file?(value)
      value =~ /^\/?[^\/]+(\/[^\/]+)*$/
    end
   
    def valid_folder?(value)
      value =~ /^\/?[^\/]+(\/[^\/]+)*\/?$/
    end
   
    def valid_on_off?(value)
      ['true', 'false', 'On', 'on', 'Off', 'off', '1', '0'].include? value.to_s
    end
   
    def valid_byte?(value)
      value.to_s =~ /^\d+[BbKkMmGgTt]?$/
    end

  end
end