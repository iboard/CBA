class UserInviter < Struct.new( :args )

  # arg0 = invitation_id
  # arg1 = subject
  # arg2 = message
  def perform
    invitation = Invitation.find(args[0])
    Notifications::invite_user(invitation, args[1], args[2]).deliver
  end

end