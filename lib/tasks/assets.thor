class Assets < Thor

  include Thor::Actions

  #no_tasks do
  #end

  desc "assemble", "clean assets, precompile, and restore links"
  def assemble
    ENV.each do |key, value|
      if key == "RAILS_ENV"
        @rails_env = value
      end
    end
    if @rails_env == 'production'
      run "# rake assets:clean"
      run "# rake assets:precompile"
      run "
        cd public/assets
        ln -s ../../app/assets/images/*
        ln -s sortable_vertical-*.png sortable_vertical.png
        cd -
        cd public/assets/avatars
        for i in icon medium preview thumb
        do
          ln -s missing*.png missing.png
        done
        cd -
      "
    else
      puts "ASSAMBLE ASSETS WORKS IN PRODUCTION MODE ONLY"
    end
  end

end