class Repo
  include DataMapper::Resource

  property :id,                 Serial
  property :github_commit_url,  String, required: true
  property :local_path,         String, required: true
  property :name,               String, unique: true
  property :created_at,         DateTime
  property :updated_at,         DateTime
end
