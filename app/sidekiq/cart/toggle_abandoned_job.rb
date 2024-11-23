require "sidekiq-scheduler"

class Cart::ToggleAbandonedJob
  include Sidekiq::Job

  sidekiq_options queue: :critical

  def perform
    Cart.find_each do |cart|
      cart.toggle_abandoned
    end
  end
end
