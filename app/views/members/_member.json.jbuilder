json.extract! member, :id, :name, :title, :bio, :active, :votes_count, :created_at, :updated_at
json.url member_url(member, format: :json)
