module StringExtensions

  def self.included(base)  
    String.extend StringExtensions::ClassMethods
    String.send :include, InstanceMethods
  end

  module ClassMethods
    # Characters which may be used in random strings  
    RAND_CHARS = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789"
    
    #
    # random string of 'len' characters length
    #
    def random_string(len)
      rand_max = RAND_CHARS.size
      ret = "" 
      len.times{ ret << RAND_CHARS[rand(rand_max)] }
      ret 
    end
    
  end
  
  module InstanceMethods
    def paragraphs(range=nil)
      unless range
        self.split("\n")
      else
        truncated = self.split("\n")[range].join("\n")
        truncated += "..." if (truncated.length < self.length)
        truncated
      end  
    end
  end
end

