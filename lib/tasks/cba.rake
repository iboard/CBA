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
end