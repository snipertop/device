# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


100.times do |i|
    Staff.create(number:"170301#{i}", name:"测试#{i}", department:"信息设备处", position:"工程师" )
    Computer.create(code:"01002#{i}", brand:"HP", version:"HP282G4", place:"X216", state:"在用", date:"2009/10/26", configure:" E7500/2G/500G/HP 19''", remarks:"黄磊主任说是转给马江雁了，电脑未找到",staff_id:i )
end
