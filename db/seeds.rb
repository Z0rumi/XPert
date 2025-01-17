# Clear existing data
User.delete_all
Expert.destroy_all
Category.destroy_all
Project.destroy_all
CourseModule.destroy_all

# Create Users
user1 = User.create!(
  email: "staff@fiti.de",
  password: "password123",
  role: 2,
  initiated: false
)

user2 = User.create!(
  email: "intern@fiti.de",
  password: "password123",
  role: 1,
  initiated: false
)

user3 = User.create!(
  email: "max.mustermann@web.de",
  password: "password123",
  role: 0,
  initiated: true
)

user4 = User.create!(
  email: "maria.musterfrau@gmail.com",
  password: "password123",
  role: 0,
  initiated: true
)

user5 = User.create!(
  email: "admin@fiti.de",
  password: "password123",
  role: 3,
  initiated: false
)

# Create Categories

category1 = Category.create!(
    name: "Industrie 4.0"
)

category2 = Category.create!(
    name: "Digitale Technologien"
)

category3 = Category.create!(
    name: "Aus- und Weiterbildung"
)

category4 = Category.create!(
    name: "Wirtschaft, Management, Interkulturelles"
)

# Create Course Modules
course_module1 = CourseModule.create!(
  name: "Kurs ABC",
  description: "Im Kurs ABC übernehmen Sie Aufgaben DEF. Neben der Veranschaulichung von Thema GHI, ist es Ihre Aufgabe das detaillierte Erklären von JKL."
)

course_module2 = CourseModule.create!(
  name: "Kurs UVW",
    description: "Im Kurs UVW übernehmen Sie Aufgaben DEF. Neben der Veranschaulichung von Thema GHI, ist es Ihre Aufgabe das detaillierte Erklären von XYZ."
)

# Create Experts
expert1 = Expert.create!(
  salutation: "Herr",
  title: "Dr. Prof.",
  first_name: "Max",
  last_name: "Mustermann",
  nationality: "Deutsch",
  phone_number: "+491234567890",
  email: "max.mustermann@web.de",
  location: "Heilbronn",
  communication_languages: [ "Deutsch" ],
  teaching_languages: [ "Deutsch" ],
  hourly_rate: 100,
  daily_rate: 1000,
  travel_willingnesses: [ "Deutschland" ],
  remark_travel_willingness: "Ich möchte nur nach Peking fliegen",
  availability: "2 Wochen vor Termin",
  china_experience: "5 Jahre in Beijing gelebt",
  institution: "Hochschule Heilbronn",
  cooperation_opportunity: "Rocket League Cup",
  remarks: "-",
  categories: [ category1, category2 ],
  extra_category: "Künstliche Intelligenz",
  course_modules: [ course_module1 ],
  institution_association: true
)

expert2 = Expert.create!(
  salutation: "Frau",
  title: "Dr. Med.",
  first_name: "Maria",
  last_name: "Musterfrau",
  nationality: "Deutsch",
  phone_number: "+491234567890",
  email: "maria.musterfrau@gmail.com",
  location: "Stuttgart",
  communication_languages: [ "Deutsch" ],
  teaching_languages: [ "Deutsch" ],
  hourly_rate: 100,
  daily_rate: 1000,
  travel_willingnesses: [ "Deutschland" ],
  remark_travel_willingness: "Ich möchte nur nach Peking fliegen",
  availability: "3 Wochen vor Termin",
  china_experience: "4 Jahre durch China gereist",
  institution_association: false,
  cooperation_opportunity: "-",
  remarks: "-",
  categories: [ category3, category4 ],
  extra_category: "Künstliche Intelligenz",
  course_modules: [ course_module1 ]
)

# Link Users to Experts (optional)
user3.update!(expert_id: expert1.id)
user4.update!(expert_id: expert2.id)

# Create Projects
project1 = Project.create!(
  project_name: "Industrie 4.0 Workshop",
  main_topics: "Industrie 4.0, Automatisierung",
  start_date: "2025-05-01",
  end_date: "2025-12-15",
  project_type: "fachliche Weiterbildung",
  client: "Bayer AG",
  location: "Köln",
  city: "Köln"
)

project2 = Project.create!(
  project_name: "Digitale Transformation Workshop",
  main_topics: "Digitale Technologien, Business Strategien",
  start_date: "2025-01-10",
  end_date: "2025-01-20",
  project_type: "Dozentenfortbildung",
  client: "Bosch GmbH",
  location: "Online",
  city: "Online"
)

puts "Seeding completed: Created 5 users with roles, Created 4 Categories, Created 2 Experts, Linked 2 Expert Users to Experts, Created 2 Projects and Created 2 Course Modules."
