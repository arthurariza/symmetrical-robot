require "rails_helper"

describe User::GenerateJwtService do
  describe ".call" do
    it "returns a jwt" do
      user = create(:user)

      jwt = User::GenerateJwtService.call(user)

      expect(jwt).to be_present
      expect(JWT.decode(jwt, ENV.fetch("JWT_SECRET")).first["user_id"]).to eq(user.id)
    end
  end
end
