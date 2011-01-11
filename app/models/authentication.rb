class Authentication
  include Mongoid::Document
  include Mongoid::Timestamps
  field :provider
  field :uid
  referenced_in :user
  
  def provider_name
    case provider 
    when 'open_id' 
      "OpenID"
    when 'thirty_seven_signals' 
      '37 Signals'
    else
      provider.titleize
    end
  end
  
end
