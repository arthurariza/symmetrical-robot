require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe Cart::ToggleAbandonedJob, type: :job do
  it "toggle carts as abandoned based on Cart's toggle_abandoned" do
    Sidekiq::Testing.inline!

    cart1 = create(:cart, last_interaction_at: 4.hours.ago, abandoned: false)
    cart2 = create(:cart, last_interaction_at: 1.hour.ago, abandoned: true)
    cart3 = create(:cart, last_interaction_at: 2.hour.ago, abandoned: false)

    Cart::ToggleAbandonedJob.perform_async

    expect(cart1.reload.abandoned).to be true
    expect(cart2.reload.abandoned).to be false
    expect(cart3.reload.abandoned).to be false
  end

  it 'enqueues the job in the critical queue' do
    Sidekiq::Testing.fake!

    expect {
      Cart::ToggleAbandonedJob.perform_async
    }.to change(Cart::ToggleAbandonedJob.jobs, :size).by(1)

    expect(Cart::ToggleAbandonedJob.jobs.last['queue']).to eq('critical')
  end
end
