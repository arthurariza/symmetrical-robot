require "sidekiq-scheduler"

class Cart::DestroyAbandonedJob
  include Sidekiq::Job

  sidekiq_options queue: :critical

  def perform
    Cart.where(abandoned: true).where("last_interaction_at < ?", Cart::INACTIVE_DAYS_TO_REMOVE.days.ago).destroy_all
  end
end
