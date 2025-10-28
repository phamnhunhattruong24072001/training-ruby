# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'bcrypt'

puts "🌱 Creating default roles..."

roles = [
  { name: "Super Admin", code: "super_admin", status: 0 },
  { name: "Admin", code: "admin", status: 1 },
  { name: "Manager", code: "manager", status: 2 },
  { name: "User", code: "user", status: 3 }
]

roles.each do |role|
  Role.find_or_create_by!(code: role[:code]) do |r|
    r.name = role[:name]
    r.status = role[:status]
  end
end

puts "✅ Roles seeded successfully!"

puts "🌱 Creating default positions..."

positions = [
  { name: "CEO", description: "Giám đốc điều hành, người có quyền cao nhất trong công ty." },
  { name: "Accountant", description: "Kế toán." },
  { name: "Manager", description: "Quản lý, phụ trách nhóm hoặc bộ phận." },
  { name: "Co-Leader", description: "Trưởng nhóm phụ trách công việc team." },
  { name: "Leader DEV", description: "Trưởng nhóm dự án" },
  { name: "Developer", description: "Nhân viên lập trình, phát triển tính năng." },
  { name: "Tester", description: "Nhân viên kiểm thử, đảm bảo chất lượng sản phẩm." }
]

positions.each do |pos|
  Position.find_or_create_by!(name: pos[:name]) do |p|
    p.description = pos[:description]
  end
end

puts "✅ Seeded positions successfully!"

puts "🌱 Creating default Super Admin user..."

super_admin_role   = Role.find_by(status: 0) || Role.find_by(code: "super_admin")

UserTeam.find_or_create_by!(email: "superadmin@example.com") do |user|
  user.username           = "superadmin"
  user.fullname           = "Super Administrator"
  user.display_name       = "Super Admin"
  user.role               = super_admin_role

  user.encrypted_password = BCrypt::Password.create("123456")
end

puts "✅ Super Admin created successfully!"
