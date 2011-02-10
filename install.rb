# Application Installation and Setup-script for CBA
# clone and setup CBA from http://github.com/iboard/CBA

# Usage: 
#
#   ruby < <(curl http://github.com/iboard/CBA/install.rb)
#
# More info: http://github.com/iboard/CBA/


=begin
 =========================================================================
                          HELPER FUNCTIONS
 ========================================================================= 
=end
SCREEN_WIDTH=79

class String
  def blank?
    self.strip == ""
  end
end

def ask(prompt)
  print prompt
  gets
end

unless defined? yes?
  def yes? prompt
    while true
      a=ask(prompt+" (Y/n)").strip.upcase
      return true if ['Y','YES'].include?(a)
      return false if ['N','NO'].include?(a)
      puts "Please answer Y, yes or N, no"
    end
  end
end
    

def terminate msg
  puts msg
  exit 1
end

def run_and_check(prompt,cmd,excepted,msg,suffix="\n")
  print "%-40.40s" % prompt
  print ": "
  begin
    p=File.popen(cmd,"r")
    rc=p.read.strip
    p.close
  rescue
    rc = ""
  end
  if rc =~ Regexp.new(excepted)
    print "OK" + suffix
    return rc.strip
  else
    print "FAILED" + "\n    " + msg +(rc=="" ? "" : "\n    ")+ rc + suffix
    return false
  end
end

def run_and_get(prompt,cmd,msg,suffix="\n")
  rc = run_and_check(prompt,cmd,".",msg,'')
  unless rc
    print suffix
    return false
  end
  print " => "+rc+suffix
  return rc.strip
end

=begin
 =========================================================================
                                MAIN
 ========================================================================= 
=end

puts "="*SCREEN_WIDTH
puts "CBA INSTALLATION"
puts "Any problems? See http://github.com/iboard/CBA/issues"
puts "="*SCREEN_WIDTH

app_name = ask('Please enter the name/path where to install the application:').strip
if File::exist?(app_name)
  puts "Directory or file #{app_name} exists."
  puts "Installation aborted"
  exit 7
end

#----------------------------------------------------------------------------
# Test Environment and fetch system parameters
#----------------------------------------------------------------------------

puts "1. Test environment"
puts "-------------------"

os=run_and_get("Checking for OS","uname","COULD NOT DETECT OPERATING SYSTEM")
unless os > ""
  puts "Application couldn't be install using this script."
  puts "Please install using:"
  puts "   git clone git://github.com/iboard/CBA.git [your_app_name]"
  puts "   and follow the instructions in README"
  exit 2
end

terminate "ABORTED" unless run_and_check(
  "Checking for git", "which git", "git", 
  "GIT NOT FOUND"
)

terminate "ABORTED" unless run_and_check(
  "Checking for ruby version 1.9.x", "ruby -v", "1.9.", 
  "RUBY 1.9.x SHOULD BE INSTALLED BUT CHECK RETURNS"
)

terminate "ABORTED" unless run_and_check(
  "Checking for rails version 3.x", "rails -v", "Rails 3\.", 
  "RAILS 3.x.x SHOULD BE INSTALLED BUT CHECK RETURNS"
)

mongo_version=run_and_get(
  "Checking for MongoDB", "mongo --version",
  "COULD NOT FIND MONGODB (Please install -> mongodb.org)"
)

mongod=run_and_get(
  "Checking if mongod is running", "ps xa|grep mongod|grep -v grep|sed 's/^.* \\///g'",
  "MongoDB daemon 'mongod' not found"
)

identify=run_and_get(
  "Checking for identify (ImageMagick)", "which identify",
  "COULD NOT FIND PROGRAM identify (Please install -> www.imagemagick.org)"
)

convert=run_and_get(
  "Checking for convert (ImageMagick)", "which convert",
  "COULD NOT FIND PROGRAM convert (Please install -> www.imagemagick.org)"
)

imagemagick_path=File::dirname(convert)

rails_root=run_and_get(
  "Checking for Rails.root","pwd","COULD NOT GET CURRENT WORKING DIRECTORY"
)
  
#----------------------------------------------------------------------------
# Summary
#----------------------------------------------------------------------------
puts "\nSummary " + "*"*(SCREEN_WIDTH-1-"Summary".length)
if !mongo_version || mongo_version.blank? 
  puts "  There is no local MongoDB found."
  puts "  You can use CBA, though you have to configure an external"
  puts "  MongoDB-Server."
elsif !mongod || mongod.blank?
  puts "  MongoDB seems to be installed but not started."
  puts "  Don't forget to start mongod before using the application or"
  puts "  configure an external MongoDB-Server."
else
  puts "  Everything looks fine."
end

puts "CBA will now be cloned to #{app_name}"
unless yes?("Continiue?")
  puts "Canceled"
  exit 8
end

`git clone git://github.com/iboard/CBA.git #{app_name}`

Dir::chdir(app_name)

installed_in=run_and_get(
  "Checking clone", "pwd",
  "COULD NOT RUN `pwd` (wrong Operating System?)"
)

unless File::basename(installed_in) == app_name
  puts "Ooops. Should be in directory #{app_name}"
  puts "Terminated"
  exit 7
end

system("thor application:configure")




