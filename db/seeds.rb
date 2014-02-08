connection = ActiveRecord::Base.connection();
5.times do |i|
  q = "INSERT INTO users (full_name, phone_number, email, created_at, updated_at) values ('Erin #{i}', 'erin+#{i}@carbonfive.com', '#{rand.to_s[2..11]}', NOW(), NOW())"
  connection.execute(q)
end
