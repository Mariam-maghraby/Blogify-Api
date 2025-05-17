class PostSerializer < ActiveModel::Serializer
    attributes :id, :title, :body, :author_id, :created_at, :updated_at

    attribute :author do
        object.user.as_json(except: [:password_digest])
    end

    has_many :tags
    has_many :comments

    def author_id
        object.user_id
    end
end