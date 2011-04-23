class NewSignUpNotifier < Struct.new( :args )

  def perform
    user = User.find(args[0])
    Notifications::sign_up(user).deliver
  end

end