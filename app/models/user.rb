class User < ApplicationRecord
    has_many :microposts, dependent: :destroy

    has_many :active_relationships, class_name: "Relationship",
                                    foreign_key: "follower_id",
                                    dependent: :destroy
    has_many :following, through: :active_relationships, source: :followed
    has_many :passive_relationships, class_name: "Relationship",
                                    foreign_key: "followed_id",
                                    dependent: :destroy
    has_many :followers, through: :passive_relationships

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

    before_save { self.email.downcase! }

    validates :name, presence: true, length: {
        maximum: 50
    }

    validates :email, presence: true, length: { 
        maximum: 255 
    }, format: { 
        with: VALID_EMAIL_REGEX 
    }, uniqueness: true

    has_secure_password
    validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                      BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    def feed
        following_ids_str = 'SELECT followed_id FROM Relationships ' +
                            'WHERE follower_id = :user_id'
        query = "user_id IN (#{following_ids_str}) OR user_id = :user_id"
        Micropost.where(query, user_id: id)
    end

    def follow(other_user)
        following << other_user
    end

    # Unfollows a user.
    def unfollow(other_user)
        following.delete(other_user)
    end
    
    # Returns true if the current user is following the other user.
    def following?(other_user)
        following.include?(other_user)
    end
end
