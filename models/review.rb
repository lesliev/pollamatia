class Review
  include DataMapper::Resource

  property :id,         Serial
  property :created_at, DateTime

  belongs_to :user, required: true
  belongs_to :commit, required: true
end
