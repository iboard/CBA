# encoding: utf-8
module Translator #:nodoc:

  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def translate_field(name)
      class_eval <<-EOV
        field "#{name}_translations".to_sym, :type => Hash, :default => {}
      EOV
    end

    def translate_fields(names)
      names.each do |name|
        translate_field(name)
      end
    end
  end

  module InstanceMethods
    def translate!
      for name in translated_fields
        initialize_translations(name)
      end
    end

    def t(locale,field,new_value=nil)
      unless new_value
        unless locale == I18n.default_locale
          unless translated = self.send(field.to_s+"_translations")[locale.to_s]
            ("*#{locale.to_s}*" + self.send(field.to_s))
          else
            translated
          end
        else
          self.send(field.to_s)
        end
      else
        unless locale == I18n.default_locale
          self.send(field.to_s+"_translations")[locale.to_s]=new_value
        else
          self.send(field.to_s+"=",new_value)
        end
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

  end

end