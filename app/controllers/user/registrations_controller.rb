class User::RegistrationsController < Devise::RegistrationsController
  # layout 'user/application'
  before_action :authenticate_user!, except: [:new, :create]
  before_action :redirect_user, only: [:destroy]
  add_breadcrumb I18n.t('activerecord.models.user'), :user_root_path

  def edit
  end

  def new
    @user = User.new
    respond_with(@user)
  end

  def create
    @user = User.last
    @card = Card.find_by card_number: @user.cardnumber
    if @card.nil?
      flash[:danger] = 'Böyle bir kart bulunamadı.'
      redirect_to :back
    elsif @card.user == nil
      @user.card_id = @card.id
      @user.save
      flash[:success] = 'Kaydınız başarıyla gerçekleşmiştir.'
      redirect_to root_path
    else
      flash[:danger] = 'Bu kart kullanılmaktadır.'
      redirect_to :back
    end
  end

  private

  def redirect_user
    redirect_to user_root_path
  end

  def after_update_path_for(resource)
    user_root_path
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :surname, :card_id, :cardnumber, :time_zone)
  end
end