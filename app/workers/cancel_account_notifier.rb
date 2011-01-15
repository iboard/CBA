class CancelAccountNotifier < Struct.new( :args )
  
  def perform
    Notifications::cancel_account(args).deliver
  end
  
end