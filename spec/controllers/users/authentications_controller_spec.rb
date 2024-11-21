require "rails_helper"

describe Users::AuthenticationsController, type: :request do
  describe "create" do
    it "returns a jwt when credentials are correct" do
      user = create(:user, email: "admin@admin.com", password: "password")

      post users_authentications_path, params: { email: user.email, password: user.password }

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body["token"]).to be_present
    end

    it "returns an error when credentials are incorrect" do
      post users_authentications_path, params: { email: "admin@admin.com", password: "password" }

      expect(response).to have_http_status(:unauthorized)
      expect(response.parsed_body[:error]).to eq("Invalid email or password")
    end
  end
end
