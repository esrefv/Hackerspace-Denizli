class ExampleJob < ActiveJob::Base
  queue_as :default
  self.queue_adapter = :resque
  def perform(user_id)
    3.seconds.online_at
    user = Answer.find(user_id)
    user.status= false
  end
end
