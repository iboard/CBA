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
      unless user.avatar.nil? || user.avatar_file_name.nil?
        puts "  - " + user.avatar_file_name
        user.avatar.reprocess! 
      end
    end
  end
   
end