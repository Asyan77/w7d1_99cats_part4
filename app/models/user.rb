# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
    validates :username, :session_token, :password_digest, presence: true
    validates :username, :session_token, uniqueness: true
    attr_reader :password
    before_validation :ensure_session_token

    def password=(password)
        @password = password
        password_digest = BCrypt::Password.create(password)
    end

    def self.find_by_credentials(username, password)
        @user = User.find_by(username: username)

        if user && user.is_password?(password)
            return user
        else
            return nil
        end
    end

    def is_password?(password)
        bcryptobj = BCrypt::Password.new(self.password_digest)
        bcryptobj.is_password?(password)

    end

    def reset_session_token!
        self.session_token = generate_unique_session_token
        self.save!
        self.session_token
    end

    def generate_unique_session_token
        token = SecureRandom::urlsafe_base64
        while User.exists?(session_token: token)
            token = SecureRandom::urlsafe_base64
        end
        token
    end

    def ensure_session_token?
        self.session_token || = generate_unique_session_token
    end

end
