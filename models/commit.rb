class Commit
  include DataMapper::Resource

  property :id,         Serial
  property :ref,        String, required: true
  property :author,     String, required: true, length: 255
  property :header,     String, required: true, length: 255
  property :body,       Text
  property :date,       DateTime, required: true
  property :created_at, DateTime
  property :updated_at, DateTime

  belongs_to  :repo, required: false
  has n,      :reviews
  has n,      :users, through: :reviews

  def commit_html(github)
    %Q(<a href="#{github}/#{ref}" target="_blank">#{header}</a><br/>)
  end

  def body_html
    body.split("\n").join("<br/>")
  end
end
