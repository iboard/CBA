namespace :cba do
  desc "Display the ROLES-matrix"
  task :roles => :environment do
    print "MASK: "
    User::ROLES.each do |role|
      print "%9s" % role
      print " | "
    end

    puts ""

    (0..255).each do |roles_mask|
      print "%03d : " % roles_mask
      User::ROLES.each do |role|
        print "    %s    " % ((roles_mask.to_i & 2**User::ROLES.index(role.to_s)) > 0 ? "X" : "-")
        print " | "
      end
      puts ""
      all = true
      User::ROLES.each do |role|
        unless roles_mask.to_i & 2**User::ROLES.index(role.to_s) > 0 
          all = false
          break
        end
      end
      break if all
    end
  end
  
  
  desc "Reprocess attachments"
  task :reprocess_attachments => :environment do
    
    def reprocess_attachments(of_what)
      if of_what.respond_to?(:cover_picture_exists?) && of_what.cover_picture_exists?
        puts "  - Reprocessing Cover of #{of_what.cover_picture_file_name}"
        of_what.cover_picture.reprocess! 
      end
      if of_what.respond_to?(:attachments)
        of_what.attachments.each do |attachment|
          if attachment.file.content_type =~ /image/ 
            puts "  - Reprocessing #{attachment.file.content_type} #{attachment.file_file_name}"
            attachment.file.reprocess!
          end
        end
      end
    end
    
    Page.all.each do |page|
      puts "Processing #{page.title}"
      reprocess_attachments(page)
    end
    
    Blog.all.each do |blog|
      puts "Processing #{blog.title}"
      reprocess_attachments(blog)
      blog.postings.all.each do |posting|
        reprocess_attachments(posting)
      end
    end
    
    User.all.each do |user|
      puts "Processing #{user.name}'s Avatar"
      unless user.avatar.nil? || 
        user.avatar_file_name.nil?
        puts "  - " + user.avatar_file_name
        user.avatar.reprocess! 
      end
    end
  end
  
  desc "Build Sitemap for google"
  task :generate_sitemap => :environment do
    
    entries = []
    xml_prefix = '<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">' +
    "\n\n    <lastmod>#{Time.now.strftime("%Y-%m-%dT%H:%M%Z")}</lastmod>\n"
    "    <url><loc>http://#{DEFAULT_URL}/</loc></url>\n"
    xml_suffix = "\n</urlset>"
    
    for page in Page.asc(:title).all
      entries << "    <url> 
      <loc>http://#{DEFAULT_URL}/pages/#{page.id.to_s}</loc> 
    </url>"
    end
    
    for blog in Blog.all
      for posting in blog.postings.desc(:updated_at).all
          entries << "    <url> 
      <loc>http://#{DEFAULT_URL}/blogs/#{blog.id.to_s}/postings/#{posting.id.to_s}</loc> 
    </url>"
      end
    end
    
    sitemap = File.new(File::join(Rails.root,"public", "sitemap.xml"), "w")
    sitemap << (xml_prefix + entries.join("\n") + xml_suffix)
    sitemap.close
  end 
end