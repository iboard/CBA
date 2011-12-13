# encoding: utf-8
module Translator #:nodoc:

  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    
    # Define the mongoId field for translations of field `name`
    # @param [String] name The fieldname which should have translations
    def translate_field(name)
      class_eval <<-EOV
        field "#{name}_translations".to_sym, :type => Hash, :default => {}
      EOV
    end

    # Define the mongoId field for translations of fields in `names`
    # @param [Array] names An array of fieldnames which should have translations
    def translate_fields(names)
      names.each do |name|
        translate_field(name)
      end
    end
            
  end

  module InstanceMethods
    
    def t(locale,field,new_value=nil)
      unless new_value
        get_field_value(locale,field)
      else
        set_field_value(locale,field,new_value)
      end
    end
    
    def translate!
      for name in translated_fields
        initialize_translations(name)
      end
    end
    
    def translated_fields
      attributes.map.select { |a|
        a[0] =~ /_translations$/
      }.map {|x|
        x[0].to_sym
      }
    end

    def initialize_translation(locale,field)
      original_value = self.send(field.to_s.gsub(/_translations$/,''))
      self.send(field.to_sym).merge!( { locale.to_s => original_value } )
    end

    def initialize_translations(field)
      original_name = field.to_s.gsub(/_translations$/,'')
      for lang in I18n.available_locales-[I18n.default_locale]
        initialize_translation(lang,field)
      end
    end
    
    private #:nodoc:
    def set_field_value(locale,field,new_value)
      unless locale == I18n.default_locale
        self.send(field.to_s+"_translations")[locale.to_s]=new_value
      else
        self.send(field.to_s+"=",new_value)
      end
    end
    
    def get_field_value(locale,field)
      unless locale == I18n.default_locale
        unless translated = self.send(field.to_s+"_translations")[locale.to_s]
          ("*#{locale.to_s}*" + self.send(field.to_s))
        else
          translated
        end
      else
        self.send(field.to_s)
      end
    end

  end

end