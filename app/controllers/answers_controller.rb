class AnswersController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def new
    @answer = Answer.new
  end

  def index
    @answers = Answer.all
  end

  def show
    @answer= Answer.find(params[:id])
  end

  def create
    @answer = Answer.new(answer_params)
    @card = Card.find_by_id @answer.card_id

    unless @card.user.nil?
      @answer.user_id = @card.user.id
    end

    respond_to do |format|
      if  @answer.user.nil?
        format.html { redirect_to root_path, notice: 'Bu karta ait kullanıcı bulunamadı.' }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      elsif @answer.value == 200 && @answer.user.is_active?
        @answer.status = true
        @answer.online_at = Time.now
        @answer.save
        format.html { redirect_to root_path, notice: 'Kullanıcı şuan online.' }
        format.json { render root_path, status: :created, location: @answer }
      else
        format.html { redirect_to root_path, notice: 'Kullanıcı admin tarafından aktifleştirilmemiştir.' }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end

  end

  def update
    @answer = Answer.find_by_card_id(params[:card_id])

    respond_to do |format|
      if @answer.value == 200
        @answer.status = false
        @answer.offline_at = Time.now
        @answer.update(answer_params)
        format.html { redirect_to root_path, notice: 'Kullanıcı şuan offline.' }
        format.json { render root_path, status: :updated, location: @answer }
      else
        format.html { redirect_to root_path, notice: 'Hatalı bir işlem.' }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:card_id, :value, :user_id, :online_at, :offline_at, :status )
  end

end
