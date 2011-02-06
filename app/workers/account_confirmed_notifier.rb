class AccountConfirmedNotifier < Struct.new( :args )
  
  def perform
    user = User.find(args[0])
    Notifications::account_confirmed(user).deliver
  end
  
end