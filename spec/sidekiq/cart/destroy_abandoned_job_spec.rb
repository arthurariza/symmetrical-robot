require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe Cart::DestroyAbandonedJob, type: :job do
  it 'destroys only old abandoned carts' do
    Sidekiq::Testing.inline!

    old_abandoned_cart = create(:cart, abandoned: true, last_interaction_at: (Cart::INACTIVE_DAYS_TO_REMOVE + 1).days.ago)
    recent_abandoned_cart = create(:cart, abandoned: true, last_interaction_at: (Cart::INACTIVE_DAYS_TO_REMOVE - 1).days.ago)
    active_cart = create(:cart, abandoned: false, last_interaction_at: Time.current)

    expect { Cart::DestroyAbandonedJob.perform_async }.to change { Cart.count }.by(-1)
    expect(Cart.exists?(old_abandoned_cart.id)).to be false
    expect(Cart.exists?(recent_abandoned_cart.id)).to be true
    expect(Cart.exists?(active_cart.id)).to be true
  end

  it 'enqueues the job in the critical queue' do
    Sidekiq::Testing.fake!

    expect {
      Cart::DestroyAbandonedJob.perform_async
    }.to change(Cart::DestroyAbandonedJob.jobs, :size).by(1)

    expect(Cart::DestroyAbandonedJob.jobs.last['queue']).to eq('critical')
  end
end
