coaches_data = [
  { name: '李雅静', phone: '13800000001', bio: '10年瑜伽教学经验，擅长哈他瑜伽和阴瑜伽' },
  { name: '王美玲', phone: '13800000002', bio: '全美瑜伽联盟RYT-500认证，流瑜伽专家' },
  { name: '张晨曦', phone: '13800000003', bio: '专注理疗瑜伽和孕产瑜伽' }
]

coaches = coaches_data.map do |data|
  Coach.find_or_create_by!(phone: data[:phone]) do |c|
    c.name = data[:name]
    c.bio = data[:bio]
  end
end

courses_data = [
  { name: '哈他瑜伽', description: '基础瑜伽体式练习，适合所有级别', duration_minutes: 60 },
  { name: '流瑜伽', description: '流畅的体式串联，提升心肺功能', duration_minutes: 75 },
  { name: '阴瑜伽', description: '深度拉伸，放松身心', duration_minutes: 90 },
  { name: '理疗瑜伽', description: '针对肩颈腰背痛的修复练习', duration_minutes: 60 },
  { name: '晨间唤醒', description: '清晨轻柔瑜伽，开启美好一天', duration_minutes: 45 }
]

courses = courses_data.map do |data|
  Course.find_or_create_by!(name: data[:name]) do |c|
    c.description = data[:description]
    c.duration_minutes = data[:duration_minutes]
  end
end

member_names = [
  '赵小云', '钱小芳', '孙小美', '李小红', '周晓燕',
  '吴晓丽', '郑小梅', '王小芳', '冯小娟', '陈小敏',
  '褚小英', '卫小萍', '蒋小琴', '沈小珍', '韩小丽',
  '杨小燕', '朱小娟', '秦小霞', '尤小英', '许小梅',
  '何小芳', '吕小珍', '施小萍', '张小丽', '孔小琴',
  '曹小敏', '严小燕', '华小娟', '金小英', '魏小霞',
  '陶小珍', '姜小芳', '戚小萍', '谢小丽', '邹小琴',
  '喻小敏', '柏小燕', '水小娟', '窦小英', '章小霞',
  '云小芳', '苏小珍', '潘小萍', '葛小丽', '奚小琴',
  '范小敏', '彭小燕', '郎小娟', '鲁小英', '韦小霞'
]

member_names.each_with_index do |name, idx|
  phone = "139#{format('%08d', idx + 1)}"
  Member.find_or_create_by!(phone: phone) do |m|
    m.name = name
    m.status = :active
    m.member_since = Date.today - rand(30..365).days
  end
end

week_start = Date.today.beginning_of_week
slots = [
  { day: 0, hour: 7, course: courses[4], coach: coaches[0] },
  { day: 0, hour: 9, course: courses[0], coach: coaches[0] },
  { day: 0, hour: 18, course: courses[1], coach: coaches[1] },
  { day: 1, hour: 9, course: courses[3], coach: coaches[2] },
  { day: 1, hour: 18, course: courses[0], coach: coaches[0] },
  { day: 1, hour: 19, course: courses[2], coach: coaches[1] },
  { day: 2, hour: 7, course: courses[4], coach: coaches[1] },
  { day: 2, hour: 9, course: courses[1], coach: coaches[1] },
  { day: 2, hour: 18, course: courses[3], coach: coaches[2] },
  { day: 3, hour: 9, course: courses[0], coach: coaches[0] },
  { day: 3, hour: 18, course: courses[1], coach: coaches[1] },
  { day: 3, hour: 19, course: courses[2], coach: coaches[0] },
  { day: 4, hour: 7, course: courses[4], coach: coaches[2] },
  { day: 4, hour: 9, course: courses[3], coach: coaches[2] },
  { day: 4, hour: 18, course: courses[0], coach: coaches[0] },
  { day: 5, hour: 9, course: courses[1], coach: coaches[1] },
  { day: 5, hour: 10, course: courses[2], coach: coaches[0] },
  { day: 6, hour: 9, course: courses[0], coach: coaches[0] },
  { day: 6, hour: 10, course: courses[1], coach: coaches[1] },
  { day: 6, hour: 15, course: courses[2], coach: coaches[2] }
]

slots.each do |slot|
  start_time = (week_start + slot[:day].days).to_datetime + slot[:hour].hours
  Schedule.find_or_create_by!(coach_id: slot[:coach].id, start_time: start_time) do |s|
    s.course_id = slot[:course].id
    s.capacity = 12
  end
end

puts "Seed data created successfully!"
puts "Coaches: #{Coach.count}"
puts "Courses: #{Course.count}"
puts "Members: #{Member.count}"
puts "Schedules: #{Schedule.count}"
