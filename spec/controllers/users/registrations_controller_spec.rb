require "rails_helper"

describe Users::RegistrationsController, type: :request do
  describe "create" do
    it "returns http status created when user is valid" do
      allow(User::CreateService).to receive(:call).and_return(create(:user, email: "admin@admin.com"))

      post users_registrations_path, params: { registration: { email: "admin@admin.com", password: "password", password_confirmation: "password" } }

      expect(response).to have_http_status(:created)
      expect(response.parsed_body["email"]).to eq("admin@admin.com")
    end

    it "returns http status unprocessable_entity when user is invalid" do
      post users_registrations_path, params: { registration: { email: "", password: "", password_confirmation: "" } }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
