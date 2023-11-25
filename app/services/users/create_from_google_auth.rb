module Users
  class CreateFromGoogleAuth
    attr_reader :google_auth_data, :user

    def initialize(google_auth_data)
      @google_auth_data = google_auth_data
    end

    def call
      ActiveRecord::Base.transaction do
        @user = User.where(email:).first_or_initialize(user_params)
        user.save!
      end

      user
    end

    private

    def email
      google_auth_data['emailAddresses']&.first&.dig('value')
    end

    def user_params
      names = google_auth_data['names']&.first

      {
        first_name: names&.dig('givenName'),
        last_name: names&.dig('familyName'),
        email:
      }
    end
  end
end
