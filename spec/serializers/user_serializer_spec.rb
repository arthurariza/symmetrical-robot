require "rails_helper"

RSpec.describe UserSerializer, type: :serializer do
  let(:user) { create(:user) }
  let(:serializer) { described_class.new(user) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }
  let(:serialized_json) { JSON.parse(serialization.to_json) }

  it "includes the expected attributes" do
    expect(serialized_json.keys).to contain_exactly("id", "email", "created_at", "updated_at")
  end

  it "serializes the correct values" do
    expect(serialized_json["id"]).to eq(user.id)
    expect(serialized_json["email"]).to eq(user.email)
    expect(serialized_json["created_at"]).to eq(user.created_at.as_json)
    expect(serialized_json["updated_at"]).to eq(user.updated_at.as_json)
  end
end
