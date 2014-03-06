class User
  include DataMapper::Resource

  property :id,         Serial
  property :name,       String, required: true
  property :created_at, DateTime
  property :updated_at, DateTime

  has n, :reviews
  has n, :commits, through: :reviews
end
