module Users
  class CreateFromGoogleAuth
    attr_reader :google_auth_data

    def initialize(google_auth_data)
      @google_auth_data = google_auth_data
    end

    def call
      user = User.where(email:).first_or_create(user_params)

      return user if user.persisted?

      raise StandardError, user.errors.full_messages.join(', ') unless user.save

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
