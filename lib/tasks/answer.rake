namespace :answer do
  desc 'update answers'
  task answers: [:environment] do
    @answers = Answer.all.order(:id) { |a| a.status == true}

    @answers.each do |answer|
      if Time.now >= answer.online_at + 10800
        answer.status = false
        answer.offline_at = Time.now
        answer.save!
      end
    end
  end
end