3.times do
  Task.create!(name: 'Sample Task')
end

2.times do
  Task.create!(name: 'Sample Task', is_done: true)
end
