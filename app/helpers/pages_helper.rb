module PagesHelper

  def escape(str)
    (str||'').gsub(/"/, "\\\"")
  end

  # Show all available languages with default language in bold letters
  def translation_links(page)
    I18n.available_locales.map do |locale|
      if locale == I18n.default_locale
        t(:original_language, :language => t('locales.'+I18n.default_locale.to_s))
      else
        t('locales.'+locale.to_s)
      end
    end.join(" | ").html_safe
  end


  # Build the field for original language and for all translations
  def translations_for_field( form_builder, field, field_type, *args, &block)

    # Label and original field
    original_label=eval("form_builder.label :#{field.to_s}, t(field)+' (#{I18n.default_locale.to_s})' ")
    e = "form_builder.#{field_type.to_s} :#{field.to_sym}"
    e += (", " + args.join(", ")) if args.any?
    original_field=eval(e)
    yield( I18n.default_locale, original_label+original_field )

    # iterate translations
    [I18n.available_locales-[I18n.default_locale]].each do |locale|
      translation_field = field.to_s + "_translations[#{locale.first.to_s}]"
      localed_label= form_builder.label( translation_field.to_sym, t(field.to_sym)+" (#{locale.first.to_s})")
      field_name = original_field.gsub(/^.*name=\"/,'').\
                   gsub(/\".*$/,'').\
                   gsub(/#{field.to_s}\]$/, "#{field.to_s}_translations][#{locale.first.to_s}]")
      field_value= form_builder.object.send("#{field.to_s}_translations")["#{locale.first.to_s}"]
      e = "#{field_type.to_s}_tag(\"#{field_name}\", \"#{escape(field_value)}\""
      e += (", "+ args.join(',')) if args.any?
      e+=")"
      localed_field = eval(e)
      yield( locale.first, localed_label + localed_field )
    end
  end

end
