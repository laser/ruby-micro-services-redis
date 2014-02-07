5.times do |i|
  User.create(full_name: "Erin #{i}", email: "erin+#{i}@carbonfive.com", phone_number: "#{rand(7)}")
end
