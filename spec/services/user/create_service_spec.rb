require "rails_helper"

describe User::CreateService, type: :service do
  describe ".call" do
    it "creates an user" do
      user = User::CreateService.call("admin@admin.com", "password", "password")

      expect(user).to be_persisted
    end

    context "when user is invalid" do
      it "returns an user with errors" do
        user = User::CreateService.call("", "", "")

        expect(user).not_to be_persisted
        expect(user.errors.full_messages).to include("Email can't be blank")
        expect(user.errors.full_messages).to include("Password can't be blank")
      end
    end
  end
end
