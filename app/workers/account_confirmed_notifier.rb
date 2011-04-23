class AccountConfirmedNotifier < Struct.new( :args )
  
  # arg0 = invitation
  # arg1 = subject
  def perform
    user = User.find(args[0])
    Notifications::account_confirmed(user,args[1],args[2]).deliver
  end
  
end