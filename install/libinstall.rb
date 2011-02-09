# Helper for installation-script


def terminate msg
  puts msg
  exit 1
end

def run_and_check(prompt,cmd,excepted,msg,suffix="\n")
  print "%-40.40s" % prompt
  print ": "
  p=File.popen(cmd,"r")
  rc=p.read.strip
  p.close
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