class Application < Thor

  desc "test_all", "Run tests and cucumber"
  def test_all
    puts "RUNNING TEST UNITS"
    system "rake test:units | grep tests.*assertions.*failures"
    puts "\nRUNNING TEST FUNCTIONALS"
    system "rake test:functionals | grep tests.*assertions.*failures"
    puts "\nRUNNING CUCUMBER"
    system "bundle exec cucumber | grep '[scenarios|steps]'"
  end
  
  desc "review", "Find REVIEW-Remarks"
  def review
    puts "\nSearching for REVIEW-Remarks in all files"
    system "find . -type f -exec grep -H \" REVIEW\" {} \\; | grep -v \..git | grep -v log\/"
  end

  desc "todo", "Find TODO-Remarks"
  def todo
    puts "\nSearching for TODO-Remarks in all files"
    system "find . -type f -exec grep -H \"TODO\" {} \\; | grep -v \..git | grep -v log\/"
  end

  desc "style", "Find STYLE-Remarks"
  def style
    puts "\nSearching for STYLE-Remarks in all files"
    system "find . -type f -exec grep -H \"STYLE\" {} \\; | grep -v \..git | grep -v log\/"
  end
  
  desc "configure", "Configure application"
  def configure
    puts "HERE WE GO"
  end
    
end


