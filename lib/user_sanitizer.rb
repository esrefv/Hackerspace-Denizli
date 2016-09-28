class User::ParameterSanitizer < Devise::ParameterSanitizer
  private
  def sign_up
    default_params.permit(:name, :surname, :email, :card_id, :cardnumber, :password, :password_confirmation, :time_zone) # TODO add other params here
  end
end
