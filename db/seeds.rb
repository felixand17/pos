# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{Option.table_name} RESTART IDENTITY;")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{Sale.table_name} RESTART IDENTITY;")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{OrderDetail.table_name} RESTART IDENTITY;")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{Order.table_name} RESTART IDENTITY;")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{Tenant.table_name} RESTART IDENTITY;")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{Notification.table_name} CASCADE;")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{User.table_name} CASCADE;")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{Role.table_name} CASCADE;")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{Menu.table_name} RESTART IDENTITY;")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{Category.table_name} RESTART IDENTITY;")

Option.create([
  {option_name: 'enable_captain_order', option_value: 'true'},
  {option_name: 'captain_order_printer', option_value: '192.168.88.13'},
  {option_name: 'table_order_printer', option_value: '192.168.88.12'},
  {option_name: 'cashier_printer', option_value: '192.168.88.11'},
  {option_name: 'enable_service', option_value: 'false'},
  {option_name: 'buffet_mode', option_value: 'false'},
  {option_name: 'buffet_price', option_value: '75000'},
  {option_name: 'buffet_include_beverage', option_value: 'false'}
])

r1 = Role.create({name: "Waiters", description: "Can read menus. Can CRU orders"})
r2 = Role.create({name: "Cashier", description: "Can read menus. Can CRU orders"})
r3 = Role.create({name: "Tenant", description: "Can read and create menus. Can update and destroy own menus. Can R own orders"})
r4 = Role.create({name: "Admin", description: "Can view log and view reports"})
r5 = Role.create({name: "Super Admin", description: "Can perform any CRUD operation on any resource"})
r6 = Role.create({name: "Supervisor", description: "Can perform any CRUD orders, Change Available/Sold Out Menu"})
r7 = Role.create({name: "Manager", description: "Can perform any CRUD orders, can manage Menu"})

Permission.create([
  {name: 'All operations', subject_class: 'all', action: 'manage'},

  {name: 'All operations', subject_class: 'Category', action: 'manage'},
  {name: 'List', subject_class: 'Category', action: 'index'},
  {name: 'View', subject_class: 'Category', action: 'view'},
  {name: 'create and update', subject_class: 'Category', action: 'create'},
  {name: 'create and update', subject_class: 'Category', action: 'update'},
  {name: 'delete', subject_class: 'Category', action: 'destroy'},

  {name: 'All operations', subject_class: 'Menu', action: 'manage'},
  {name: 'List', subject_class: 'Menu', action: 'index'},
  {name: 'View', subject_class: 'Menu', action: 'view'},
  {name: 'create and update', subject_class: 'Menu', action: 'create'},
  {name: 'create and update', subject_class: 'Menu', action: 'update'},
  {name: 'delete', subject_class: 'Menu', action: 'destroy'},
  {name: 'update menu status', subject_class: 'Menu', action: 'sold_out'},
  {name: 'update menu status', subject_class: 'Menu', action: 'available'},

  {name: 'All operations', subject_class: 'Notification', action: 'manage'},
  {name: 'List', subject_class: 'Notification', action: 'index'},
  {name: 'View', subject_class: 'Notification', action: 'view'},
  {name: 'create and update', subject_class: 'Notification', action: 'create'},
  {name: 'create and update', subject_class: 'Notification', action: 'update'},
  {name: 'delete', subject_class: 'Notification', action: 'destroy'},

  {name: 'All operations', subject_class: 'Order', action: 'manage'},
  {name: 'List', subject_class: 'Order', action: 'index'},
  {name: 'View', subject_class: 'Order', action: 'view'},
  {name: 'create and update', subject_class: 'Order', action: 'create'},
  {name: 'create and update', subject_class: 'Order', action: 'update'},
  {name: 'delete', subject_class: 'Order', action: 'destroy'},
  {name: 'confirm', subject_class: 'Order', action: 'confirm'},
  {name: 'cancel', subject_class: 'Order', action: 'cancel'},

  {name: 'All operations', subject_class: 'OrderDetail', action: 'manage'},
  {name: 'List', subject_class: 'OrderDetail', action: 'index'},
  {name: 'View', subject_class: 'OrderDetail', action: 'view'},
  {name: 'create and update', subject_class: 'OrderDetail', action: 'create'},
  {name: 'create and update', subject_class: 'OrderDetail', action: 'update'},
  {name: 'delete', subject_class: 'OrderDetail', action: 'destroy'},
  {name: 'confirm', subject_class: 'OrderDetail', action: 'confirm'},
  {name: 'reject', subject_class: 'OrderDetail', action: 'reject'},
  {name: 'deliver', subject_class: 'OrderDetail', action: 'deliver'},

  {name: 'All operations', subject_class: 'Sale', action: 'manage'},
  {name: 'List', subject_class: 'Sale', action: 'index'},
  {name: 'View', subject_class: 'Sale', action: 'view'},
  {name: 'create and update', subject_class: 'Sale', action: 'create'},
  {name: 'create and update', subject_class: 'Sale', action: 'update'},
  {name: 'delete', subject_class: 'Sale', action: 'destroy'},
  {name: 'print bill', subject_class: 'Sale', action: 'bill'},

  {name: 'All operations', subject_class: 'Tenant', action: 'manage'},
  {name: 'List', subject_class: 'Tenant', action: 'index'},
  {name: 'View', subject_class: 'Tenant', action: 'view'},
  {name: 'create and update', subject_class: 'Tenant', action: 'create'},
  {name: 'create and update', subject_class: 'Tenant', action: 'update'},
  {name: 'delete', subject_class: 'Tenant', action: 'destroy'},

  {name: 'All operations', subject_class: 'User', action: 'manage'},
  {name: 'List', subject_class: 'User', action: 'index'},
  {name: 'View', subject_class: 'User', action: 'view'},
  {name: 'create and update', subject_class: 'User', action: 'create'},
  {name: 'create and update', subject_class: 'User', action: 'update'},
  {name: 'delete', subject_class: 'User', action: 'destroy'},
  {name: 'import player id', subject_class: 'User', action: 'import_player_id'},

  {name: 'All operations', subject_class: 'Option', action: 'manage'},
  {name: 'List', subject_class: 'Option', action: 'index'},
  {name: 'View', subject_class: 'Option', action: 'view'},
  {name: 'create and update', subject_class: 'Option', action: 'create'},
  {name: 'create and update', subject_class: 'Option', action: 'update'},
  {name: 'delete', subject_class: 'Option', action: 'destroy'},

  {name: 'All operations', subject_class: 'Role', action: 'manage'},
  {name: 'List', subject_class: 'Role', action: 'index'},
  {name: 'View', subject_class: 'Role', action: 'view'},
  {name: 'create and update', subject_class: 'Role', action: 'create'},
  {name: 'create and update', subject_class: 'Role', action: 'update'},
  {name: 'delete', subject_class: 'Role', action: 'destroy'},

  {name: 'All operations', subject_class: 'Permission', action: 'manage'},
  {name: 'List', subject_class: 'Permission', action: 'index'},
  {name: 'View', subject_class: 'Permission', action: 'view'},
  {name: 'create and update', subject_class: 'Permission', action: 'create'},
  {name: 'create and update', subject_class: 'Permission', action: 'update'},
  {name: 'delete', subject_class: 'Permission', action: 'destroy'},

  {name: 'All operations', subject_class: 'Table', action: 'manage'},
  {name: 'List', subject_class: 'Table', action: 'index'},
  {name: 'View', subject_class: 'Table', action: 'view'},
  {name: 'create and update', subject_class: 'Table', action: 'create'},
  {name: 'create and update', subject_class: 'Table', action: 'update'},
  {name: 'delete', subject_class: 'Table', action: 'destroy'},

  {name: 'Manage', subject_class: 'Report', action: 'manage'},
  {name: 'Manage', subject_class: 'Log', action: 'manage'},

  {name: 'Standard Operations', subject_class: 'order', action: 'manage'},
  {name: 'Standard Operations', subject_class: 'sale', action: 'manage'}
])

role_super = Role.find_by_name('Super Admin')
role_super.permissions << Permission.where(subject_class: 'all', action: "manage").last

role_admin = Role.find_by_name('Admin')
role_admin.permissions << Permission.where(subject_class: 'User', action: "view").last
role_admin.permissions << Permission.where(subject_class: 'User', action: "update").last
role_admin.permissions << Permission.where(subject_class: 'Report', action: "manage").last

role_manager = Role.find_by_name('Manager')
role_manager.permissions << Permission.where(subject_class: 'User', action: "manage").last
role_manager.permissions << Permission.where(subject_class: 'Menu', action: "manage").last
role_manager.permissions << Permission.where(subject_class: 'Sale', action: "manage").last
role_manager.permissions << Permission.where(subject_class: 'Order', action: "manage").last
role_manager.permissions << Permission.where(subject_class: 'OrderDetail', action: "manage").last

role_sv = Role.find_by_name('Supervisor')
role_sv.permissions << Permission.where(subject_class: 'User', action: "view").last
role_sv.permissions << Permission.where(subject_class: 'User', action: "update").last
role_sv.permissions << Permission.where(subject_class: 'Sale', action: "manage").last
role_sv.permissions << Permission.where(subject_class: 'Order', action: "manage").last
role_sv.permissions << Permission.where(subject_class: 'OrderDetail', action: "manage").last
role_sv.permissions << Permission.where(subject_class: 'Menu', action: "index").last
role_sv.permissions << Permission.where(subject_class: 'Menu', action: "view").last
role_sv.permissions << Permission.where(subject_class: 'Menu', action: "sold_out").last
role_sv.permissions << Permission.where(subject_class: 'Menu', action: "available").last

role_waiters = Role.find_by_name('Waiters')
role_waiters.permissions << Permission.where(subject_class: 'Notification', action: "index").last
role_waiters.permissions << Permission.where(subject_class: 'Notification', action: "view").last
role_waiters.permissions << Permission.where(subject_class: 'User', action: "view").last
role_waiters.permissions << Permission.where(subject_class: 'User', action: "update").last
role_waiters.permissions << Permission.where(subject_class: 'order', action: "manage").last

role_cashier = Role.find_by_name('Cashier')
role_cashier.permissions << Permission.where(subject_class: 'Notification', action: "index").last
role_cashier.permissions << Permission.where(subject_class: 'Notification', action: "view").last
role_cashier.permissions << Permission.where(subject_class: 'Sale', action: "index").last
role_cashier.permissions << Permission.where(subject_class: 'Sale', action: "view").last
role_cashier.permissions << Permission.where(subject_class: 'Sale', action: "create").last
role_cashier.permissions << Permission.where(subject_class: 'Sale', action: "bill").last
role_cashier.permissions << Permission.where(subject_class: 'User', action: "view").last
role_cashier.permissions << Permission.where(subject_class: 'User', action: "update").last

superadmin = User.create({name: "Superadmin Admin", email: "superadmin@kukumama.id", password: "119119", role_id: r7.id})
admin = User.create({name: "Admin KukuMama", email: "admin@kukumama.id", password: "119119", role_id: r4.id})
cashier = User.create({name: "Cashier KukuMama", email: "cashier@kukumama.id", password: "119119", role_id: r2.id})
waiters1 = User.create({name: "Waiters1 KukuMama", email: "waiters1@kukumama.id", password: "119119", role_id: r1.id})
waiters2 = User.create({name: "Waiters2 KukuMama", email: "waiters2@kukumama.id", password: "119119", role_id: r1.id})

tenant1 = User.create({name: "Bintang Priyambada", email: "papabuncithotdog@gmail.com", password: "119119", role_id: r3.id})
tenant2 = User.create({name: "Noven", email: "satekarjan@kukumama.id", password: "119119", role_id: r3.id})
tenant3 = User.create({name: "Popy Z", email: "popy_sharif@hotmail.com", password: "119119", role_id: r3.id})
tenant4 = User.create({name: "Handi Irawan", email: "hans_irawan@yahoo.com", password: "119119", role_id: r3.id})
tenant5 = User.create({name: "Hj. Zaenimar", email: "igabakarbuzen@kukumama.id", password: "119119", role_id: r3.id})
tenant6 = User.create({name: "H. Memed", email: "rezhanoviana@gmail.com", password: "119119", role_id: r3.id})
tenant7 = User.create({name: "Rezha Noviana", email: "rezhanoviana@gmail.com", password: "119119", role_id: r3.id})
tenant8 = User.create({name: "Moch. Reza", email: "nasgorbaba@gmail.com", password: "119119", role_id: r3.id})
tenant9 = User.create({name: "Bayu", email: "sitaosa@gmail.com", password: "119119", role_id: r3.id})
tenant10 = User.create({name: "Andri Gusman", email: "thegusmen@gmail.com", password: "119119", role_id: r3.id})
tenant11 = User.create({name: "Krish Tamaka", email: "krish.tamaka@gmail.com", password: "119119", role_id: r3.id})
tenant12 = User.create({name: "Ledi Keyki", email: "warungseminyak@gmail.com", password: "119119", role_id: r3.id})
tenant13 = User.create({name: "Angga", email: "anggawarisman92@gmail.com", password: "119119", role_id: r3.id})
tenant14 = User.create({name: "Yetti S", email: "Susilawati.yetti@yahoo.com", password: "119119", role_id: r3.id})
tenant15 = User.create({name: "M. Umar Kusumadana", email: "ademoh7@gmail.com", password: "119119", role_id: r3.id})
tenant16 = User.create({name: "Linda Heriana", email: "linda_heriana@yahoo.com", password: "119119", role_id: r3.id})
tenant17 = User.create({name: "Widiawati", email: "see_widiy@yahoo.com", password: "119119", role_id: r3.id})
tenant18 = User.create({name: "Abdul Halim Ahmad", email: "duls.adkar@gmail.com", password: "119119", role_id: r3.id})
tenant19 = User.create({name: "Rudi Santosa", email: "kedaidimsum168@gmail.com", password: "119119", role_id: r3.id})
tenant20 = User.create({name: "Merry Maryani", email: "qnary.production@gmail.com", password: "119119", role_id: r3.id})
tenant21 = User.create({name: "Martin ", email: "pojok.nasi@gmail.com", password: "119119", role_id: r3.id})
tenant22 = User.create({name: "Yusuf ", email: "yusuf@kukumama.id", password: "119119", role_id: r3.id})
tenant23 = User.create({name: "Chriestien ", email: "chriestien.liem@gmail.com", password: "119119", role_id: r3.id})
tenant24 = User.create({name: "Indra Novianto ", email: "indra.imi28@gmail.com", password: "119119", role_id: r3.id})
tenant25 = User.create({name: "Andin ", email: "andin@kukumama.id", password: "119119", role_id: r3.id})
tenant26 = User.create({name: "", email: "", password: "119119", role_id: r3.id})
tenant27 = User.create({name: "Rasdian ", email: "zayyot2807@gmail.com", password: "119119", role_id: r3.id})
tenant28 = User.create({name: "Ahmad Mahatir", email: "athir937@yahoo.com", password: "119119", role_id: r3.id})
tenant29 = User.create({name: "Merlina Limbang", email: "linalim18@gmail.com", password: "119119", role_id: r3.id})
tenant30 = User.create({name: "Bintang Priyambada", email: "papabuncithotdog@gmail.com", password: "119119", role_id: r3.id})
tenant31 = User.create({name: "Arsal Al'Razi", email: "arsal_razi@yahoo.com", password: "119119", role_id: r3.id})
tenant32 = User.create({name: "Anastasia", email: "anartphotowork@gmail.com", password: "119119", role_id: r3.id})
tenant33 = User.create({name: "Syntha Saraswaty", email: "syntha1909@gmail.com", password: "119119", role_id: r3.id})
tenant34 = User.create({name: "Bar", email: "bar@kukumama.id", password: "119119", role_id: r3.id})

food = Category.create({ name: 'Food' })
drink = Category.create({ name: 'Drink' })

menu_description = 'Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...'

t1 = Tenant.create({name: 'Sate Karjan', description: menu_description, user_id: tenant1.id, phone_number: '087726442944', identity_number: nil, slot: 'A'})
t2 = Tenant.create({name: 'Saung hay Joe', description: menu_description, user_id: tenant2.id, phone_number: '081218952268', identity_number: '3276025601680000', slot: 'B'})
t3 = Tenant.create({name: 'Dori and Friends Steak House', description: menu_description, user_id: tenant3.id, phone_number: '082126024089', identity_number: '3273205312570002', slot: 'C'})
t4 = Tenant.create({name: 'Iga Bakar Bu zen', description: menu_description, user_id: tenant4.id, phone_number: '081221045651', identity_number: '3273205312570002', slot: 'D'})
t5 = Tenant.create({name: 'Soto H.Memed', description: menu_description, user_id: tenant5.id, phone_number: '083821236531', identity_number: '3273201812570001', slot: 'E'})
t6 = Tenant.create({name: 'Wildwings', description: menu_description, user_id: tenant6.id, phone_number: '081224800609', identity_number: '3273203011880002', slot: 'F'})
t7 = Tenant.create({name: 'Nasi Goreng Baba', description: menu_description, user_id: tenant7.id, phone_number: '08122454460', identity_number: '3273071010890002', slot: 'G'})
t8 = Tenant.create({name: 'Mama Ida', description: menu_description, user_id: tenant8.id, phone_number: '081910384454', identity_number: '3273122911800013', slot: 'H'})
t9 = Tenant.create({name: 'Bakmi Gaul', description: menu_description, user_id: tenant9.id, phone_number: '08112345626', identity_number: '3273061903890003', slot: 'I'})
t10 = Tenant.create({name: "Mom's Chicken", description: menu_description, user_id: tenant10.id, phone_number: '081223120999', identity_number: '3273241507760011', slot: 'J'})
t11 = Tenant.create({name: 'Bebek Samara', description: menu_description, user_id: tenant11.id, phone_number: '081286387723', identity_number: '', slot: 'K'})
t12 = Tenant.create({name: 'Warung Matah Bali', description: menu_description, user_id: tenant12.id, phone_number: '0817210640', identity_number: '', slot: 'L'})
t13 = Tenant.create({name: 'Nasi Kucing Juralit', description: menu_description, user_id: tenant13.id, phone_number: '082214723815', identity_number: '', slot: 'M'})
t14 = Tenant.create({name: 'Djatoeri Pempek Palembang', description: menu_description, user_id: tenant14.id, phone_number: '08112394906', identity_number: '', slot: 'N'})
t15 = Tenant.create({name: 'Siomay Boden', description: menu_description, user_id: tenant15.id, phone_number: '08174961536', identity_number: '', slot: 'O'})
t33 = Tenant.create({name: 'Ocha Suki & BBQ', description: menu_description, user_id: tenant16.id, phone_number: '0816619760', identity_number: '', slot: 'P'})
t32 = Tenant.create({name: 'Ketan Susu Canting Tradisional', description: menu_description, user_id: tenant17.id, phone_number: '0816619760', identity_number: '', slot: 'Q'})
t31 = Tenant.create({name: "Dul's Yaki", description: menu_description, user_id: tenant18.id, phone_number: '081289602887', identity_number: '', slot: 'R'})
t30 = Tenant.create({name: 'Kedai Dimsum 168', description: menu_description, user_id: tenant19.id, phone_number: '081320201168', identity_number: '', slot: 'S'})
t29 = Tenant.create({name: 'Nasi Kuah Ayam Kampung', description: menu_description, user_id: tenant20.id, phone_number: '081220093015', identity_number: '', slot: 'T'})
t28 = Tenant.create({name: 'Pojok Nasi Goang', description: menu_description, user_id: tenant21.id, phone_number: '083822231000', identity_number: '', slot: 'U'})
t27 = Tenant.create({name: 'Es Campur Pak Oyen', description: menu_description, user_id: tenant22.id, phone_number: '081222906582', identity_number: '', slot: 'V'})
t26 = Tenant.create({name: 'Holiday Taste', description: menu_description, user_id: tenant23.id, phone_number: '081809105198', identity_number: '', slot: 'W'})
t25 = Tenant.create({name: 'Pantry`s Talk', description: menu_description, user_id: tenant24.id, phone_number: '081223803230', identity_number: '', slot: 'X'})
t24 = Tenant.create({name: 'Djajan', description: menu_description, user_id: tenant25.id, phone_number: '081221218233', identity_number: '', slot: 'Y'})
t23 = Tenant.create({name: 'Jeje Seafood', description: menu_description, user_id: tenant26.id, phone_number: '', identity_number: '', slot: 'Z'})
t22 = Tenant.create({name: 'Canaa-yaa Chouliner', description: menu_description, user_id: tenant27.id, phone_number: '085794944747/081224265277', identity_number: '', slot: 'Stall E'})
t21= Tenant.create({name: 'Mie Tek-Tek Mang Athir', description: menu_description, user_id: tenant28.id, phone_number: '08112240982', identity_number: '941213310013', slot: 'Stall H'})
t20 = Tenant.create({name: 'Middle East Kebab', description: menu_description, user_id: tenant29.id, phone_number: '08122007323', identity_number: '', slot: 'Stall A'})
t19= Tenant.create({name: 'Papa Buncit Grilled Hotdog', description: menu_description, user_id: tenant30.id, phone_number: '087726442944', identity_number: '941213310013', slot: 'Stall F'})
t18 = Tenant.create({name: 'Unlock', description: menu_description, user_id: tenant31.id, phone_number: '085294421617', identity_number: '', slot: 'Stall B'})
t17= Tenant.create({name: 'Mabohay', description: menu_description, user_id: tenant32.id, phone_number: '082295205030', identity_number: '941213310013', slot: 'Stall G'})
t16 = Tenant.create({name: 'Dapur Damara', description: menu_description, user_id: tenant29.id, phone_number: '085314112300', identity_number: '', slot: 'Stall D'})
t34 = Tenant.create({name: 'Bar', description: menu_description, user_id: tenant34.id, phone_number: '085314112300', identity_number: '', slot: 'Stall D'})

Menu.create([
  { name: "Sate Buntel", description: menu_description, price: '25000', category_id: food.id, tenant_id: t1.id },
  { name: "Sate Kambing", description: menu_description, price: '48000', category_id: food.id, tenant_id: t1.id },
  { name: "Sate Ayam", description: menu_description, price: '39000', category_id: food.id, tenant_id: t1.id },
  { name: "Gule Kambing", description: menu_description, price: '35000', category_id: food.id, tenant_id: t1.id },
  { name: "Gule Ayam", description: menu_description, price: '35000', category_id: food.id, tenant_id: t1.id },
  { name: "Tongseng Kambing", description: menu_description, price: '35000', category_id: food.id, tenant_id: t1.id },
  { name: "Tongseng Ayam", description: menu_description, price: '35000', category_id: food.id, tenant_id: t1.id },
  { name: "Sop Kambing", description: menu_description, price: '35000', category_id: food.id, tenant_id: t1.id },
  { name: "Sop Ayam", description: menu_description, price: '35000', category_id: food.id, tenant_id: t1.id },
  { name: "Nasi Putih", description: menu_description, price: '5000', category_id: food.id, tenant_id: t1.id },
  { name: "Lontong", description: menu_description, price: '5000', category_id: food.id, tenant_id: t1.id },

  { name: "Ayam Bakar Sambal Hijau", description: menu_description, price: '35000', category_id: food.id, tenant_id: t2.id },
  { name: "Ayam Penyet", description: menu_description, price: '35000', category_id: food.id, tenant_id: t2.id },
  { name: "Nasi Pecel Madiun", description: menu_description, price: '25000', category_id: food.id, tenant_id: t2.id },
  { name: "Nasi Bakar Saung Hay Joe", description: menu_description, price: '20000', category_id: food.id, tenant_id: t2.id },
  { name: "Gado-Gado Siram", description: menu_description, price: '27500', category_id: food.id, tenant_id: t2.id },
  { name: "Ayam Bakar/Penyet", description: menu_description, price: '20000', category_id: food.id, tenant_id: t2.id },
  { name: "Tahu/Tempe", description: menu_description, price: '2500', category_id: food.id, tenant_id: t2.id },
  { name: "Sambal Lalapan", description: menu_description, price: '5000', category_id: food.id, tenant_id: t2.id },
  { name: "Kerupuk Putih isi 5", description: menu_description, price: '6000', category_id: food.id, tenant_id: t2.id },

  { name: "Dori Filled Blackpapper", description: "Dori Fish Filled + French Fries + Mix Vegetable", price: '27500', category_id: food.id, tenant_id: t3.id },
  { name: "Dori Filled Satay", description: "Dori Fish Filled + French Fries + Mix Vegetable", price: '27500', category_id: food.id, tenant_id: t3.id },
  { name: "Dori Filled Mashroom", description: "Dori Fish Filled + French Fries + Mix Vegetable", price: '27500', category_id: food.id, tenant_id: t3.id },
  { name: "Dori Filled BBQ Sauce", description: "Dori Fish Filled + French Fries + Mix Vegetable", price: '27500', category_id: food.id, tenant_id: t3.id },
  { name: "Dori Filled Sambal Matah", description: "Dori Fish Filled + French Fries + Mix Vegetable sambal Matah", price: '28500', category_id: food.id, tenant_id: t3.id },
  { name: "Chicken Steak Blackpapper", description: "Chicken Filled + French Fries + Mix Vegetable", price: '30000', category_id: food.id, tenant_id: t3.id },
  { name: "Chicken Steak Satay", description: "Chicken Filled + French Fries + Mix Vegetable", price: '30000', category_id: food.id, tenant_id: t3.id },
  { name: "Chicken Steak Mashroom", description: "Chicken Filled + French Fries + Mix Vegetable", price: '30000', category_id: food.id, tenant_id: t3.id },
  { name: "Chicken Steak BBQ Sauce", description: "Chicken Filled + French Fries + Mix Vegetable", price: '30000', category_id: food.id, tenant_id: t3.id },
  { name: "Chicken Cordon Blue", description: "Chicken Filled with Melted Cheese + French Fries", price: '32500', category_id: food.id, tenant_id: t3.id },
  { name: "Chicken Sambal Matah", description: "Chicken Panir with french fries + Mix vegetable", price: '29500', category_id: food.id, tenant_id: t3.id },
  { name: "Beef Steak Blackpapper", description: "Beef Filled + French Fries + Mix Vegetable", price: '38000', category_id: food.id, tenant_id: t3.id },
  { name: "Beef Steak Satay", description: "Beef Filled + French Fries + Mix Vegetable", price: '38000', category_id: food.id, tenant_id: t3.id },
  { name: "Beef Steak Mashroom", description: "Beef Filled + French Fries + Mix Vegetable", price: '38000', category_id: food.id, tenant_id: t3.id },
  { name: "Beef Steak BBQ Sauce", description: "Beef Filled + French Fries + Mix Vegetable", price: '38000', category_id: food.id, tenant_id: t3.id },
  { name: "Beef Cordon Blue", description: "Beef Filled with melted chesse + French Fries", price: '39000', category_id: food.id, tenant_id: t3.id },
  { name: "Beef Sambal Matah", description: "Beef Panir with french fries + Mix vegetable", price: '39000', category_id: food.id, tenant_id: t3.id },
  { name: "Dori Pop Rock BBQ Powder", description: "Dori Fish Strip Filled + French fries", price: '23000', category_id: food.id, tenant_id: t3.id },
  { name: "Dori Pop Rock Corn Powder", description: "Dori Fish Strip Filled + French fries", price: '23000', category_id: food.id, tenant_id: t3.id },
  { name: "Dori Pop Rock Original Powder", description: "Dori Fish Strip Filled + French fries", price: '23000', category_id: food.id, tenant_id: t3.id },
  { name: "Chicken Pop Rock BBQ Powder", description: "Chicken Strip Filled + French fries", price: '23500', category_id: food.id, tenant_id: t3.id },
  { name: "Chicken Pop Rock Corn Powder", description: "Chicken Strip Filled + French fries", price: '23500', category_id: food.id, tenant_id: t3.id },
  { name: "Chicken Pop Rock Original Powder", description: "Chicken Strip Filled + French fries", price: '23500', category_id: food.id, tenant_id: t3.id },
  { name: "Beef Pop Rock BBQ Powder", description: "Beef Strip Filled + French fries", price: '26000', category_id: food.id, tenant_id: t3.id },
  { name: "Beef Pop Rock Corn Powder", description: "Beef Strip Filled + French fries", price: '26000', category_id: food.id, tenant_id: t3.id },
  { name: "Beef Pop Rock Original Powder", description: "Beef Strip Filled + French fries", price: '26000', category_id: food.id, tenant_id: t3.id },
  { name: "Mix Platter", description: "Chicken strip + French Fries + Sausage +  Crab Stick", price: '32500', category_id: food.id, tenant_id: t3.id },

  { name: "Iga Bakar", description: menu_description, price: '35000', category_id: food.id, tenant_id: t4.id },
  { name: "Sop Iga", description: menu_description, price: '35000', category_id: food.id, tenant_id: t4.id },
  { name: "Sop Buntut", description: menu_description, price: '35000', category_id: food.id, tenant_id: t4.id },
  { name: "Nasi Putih", description: menu_description, price: '5000', category_id: food.id, tenant_id: t4.id },

  { name: "Soto Bandung", description: menu_description, price: '25000', category_id: food.id, tenant_id: t5.id },
  { name: "Soto Betawi", description: menu_description, price: '30000', category_id: food.id, tenant_id: t5.id },
  { name: "Nasi Putih", description: menu_description, price: '5000', category_id: food.id, tenant_id: t5.id },

  { name: "Chicken Wings", description: menu_description, price: '25000', category_id: food.id, tenant_id: t6.id },
  { name: "Gulai Ayam Jantan", description: menu_description, price: '25000', category_id: food.id, tenant_id: t6.id },
  { name: "Cabe Hijau Ayam Jantan", description: menu_description, price: '25000', category_id: food.id, tenant_id: t6.id },
  { name: "French Fries", description: menu_description, price: '8000', category_id: food.id, tenant_id: t6.id },
  { name: "Nasi Putih", description: menu_description, price: '5000', category_id: food.id, tenant_id: t6.id },

  { name: "Nasi Goreng Ala Baba", description: menu_description, price: '17000', category_id: food.id, tenant_id: t7.id },
  { name: "Topping Ayam", description: menu_description, price: '3000', category_id: food.id, tenant_id: t7.id },
  { name: "Topping Sosis", description: menu_description, price: '3000', category_id: food.id, tenant_id: t7.id },
  { name: "Topping Bakso", description: menu_description, price: '3000', category_id: food.id, tenant_id: t7.id },
  { name: "Topping Ati Ampela", description: menu_description, price: '3000', category_id: food.id, tenant_id: t7.id },
  { name: "Topping Telor Ceplok/Dadar", description: menu_description, price: '3000', category_id: food.id, tenant_id: t7.id },
  { name: "Topping Udang", description: menu_description, price: '5000', category_id: food.id, tenant_id: t7.id },
  { name: "Topping Cumi", description: menu_description, price: '5000', category_id: food.id, tenant_id: t7.id },
  { name: "Topping Sapi", description: menu_description, price: '7000', category_id: food.id, tenant_id: t7.id },
  { name: "Topping Kambing", description: menu_description, price: '7000', category_id: food.id, tenant_id: t7.id },
  { name: "Emping", description: menu_description, price: '2000', category_id: food.id, tenant_id: t7.id },
  { name: "Kerupuk Udang", description: menu_description, price: '2000', category_id: food.id, tenant_id: t7.id },

  { name: "Paket Ayam Bejek", description: menu_description, price: '40000', category_id: food.id, tenant_id: t8.id },
  { name: "Paket Tulang Jambal", description: menu_description, price: '40000', category_id: food.id, tenant_id: t8.id },
  { name: "Paket Pepes Ayam", description: menu_description, price: '40000', category_id: food.id, tenant_id: t8.id },
  { name: "Paket Gepuk", description: menu_description, price: '45000', category_id: food.id, tenant_id: t8.id },
  { name: "Paket Dendeng Balado", description: menu_description, price: '45000', category_id: food.id, tenant_id: t8.id },
  { name: "Jengkol Special Mama Ida", description: menu_description, price: '30000', category_id: food.id, tenant_id: t8.id },

  { name: "Bakmie Special Ayam Jamur", description: "3 Bakso + Sayur", price: '28000', category_id: food.id, tenant_id: t9.id },
  { name: "Bakmie Cincang Sapi Istimewa", description: "3 Bakso + Sayur", price: '28000', category_id: food.id, tenant_id: t9.id },
  { name: "Bakmie Rica Daun Jeruk", description: "3 Bakso + Sayur", price: '28000', category_id: food.id, tenant_id: t9.id },
  { name: "Bakso Melted Cheese", description: "3 Bakso + Sayur", price: '28000', category_id: food.id, tenant_id: t9.id },
  { name: "Bakso Cincang Sapi", description: "1 Bakso 100gr + 3 Bakso Kecil + Sayur", price: '28000', category_id: food.id, tenant_id: t9.id },
  { name: "Bakso Rica", description: "1 Bakso 100gr + 3 Bakso Kecil + Sayur", price: '28000', category_id: food.id, tenant_id: t9.id },
  { name: "Bakso Uradial", description: "1 Bakso 100gr + 3 Bakso Kecil + Sayur", price: '28000', category_id: food.id, tenant_id: t9.id },
  { name: "Lomie Gaul", description: "Mie + kangkung + 3 Bakso + siraman kuah kental nikmat", price: '28000', category_id: food.id, tenant_id: t9.id },
  { name: "Bakso Goreng Gaul", description: "isi 5 pcs", price: '28000', category_id: food.id, tenant_id: t9.id },
  { name: "Bakmie Gaul Special (Menu Of The Month)", description: menu_description, price: '50000', category_id: food.id, tenant_id: t9.id },

  { name: "Mom's Original", description: "1 Ayam + 1 Nasi + 3 Pcs Kruzkruz", price: '30000', category_id: food.id, tenant_id: t10.id },
  { name: "Chickloen (isi 5)", description: "Lumpia Ayam", price: '24500', category_id: food.id, tenant_id: t10.id },
  { name: "Kruzkruz (isi 15pcs)", description: "Bola Kentang", price: '20000', category_id: food.id, tenant_id: t10.id },
  { name: "Nasi Panggang Ayam (Breakfast only)", description: menu_description, price: '25000', category_id: food.id, tenant_id: t10.id },
  { name: "Mom's Wings (5 Pcs Hot Wings)", description: "Mom's Wings", price: '25000', category_id: food.id, tenant_id: t10.id },

  { name: "Bebek Penyet", description: menu_description, price: '35000', category_id: food.id, tenant_id: t11.id },
  { name: "Bebek Serundeng", description: menu_description, price: '35000', category_id: food.id, tenant_id: t11.id },
  { name: "Bebek Sambal Embe", description: menu_description, price: '35000', category_id: food.id, tenant_id: t11.id },
  { name: "Bebek Sambal Hejo", description: menu_description, price: '35000', category_id: food.id, tenant_id: t11.id },
  { name: "Bebek Dabu-Dabu/Matah", description: menu_description, price: '35000', category_id: food.id, tenant_id: t11.id },
  { name: "Bebek Woku", description: menu_description, price: '37000', category_id: food.id, tenant_id: t11.id },
  { name: "Bebek Rica-Rica", description: menu_description, price: '37000', category_id: food.id, tenant_id: t11.id },

  { name: "Ayam Sambal Matah", description: menu_description, price: '33000', category_id: food.id, tenant_id: t12.id },
  { name: "Lidah Sambal Matah", description: menu_description, price: '38000', category_id: food.id, tenant_id: t12.id },
  { name: "Mie Goreng Sambal Matah", description: menu_description, price: '17000', category_id: food.id, tenant_id: t12.id },

  { name: "Nasi Kucing Abon", description: menu_description, price: '10000', category_id: food.id, tenant_id: t13.id },
  { name: "Nasi Kucing Ikan Peda", description: menu_description, price: '10000', category_id: food.id, tenant_id: t13.id },
  { name: "Nasi Kucing Cumi", description: menu_description, price: '10000', category_id: food.id, tenant_id: t13.id },
  { name: "Nasi Kucing Rendang", description: menu_description, price: '10000', category_id: food.id, tenant_id: t13.id },
  { name: "Nasi Kucing Ayam Suir", description: menu_description, price: '10000', category_id: food.id, tenant_id: t13.id },
  { name: "Nasi Kucing Ikan Tongkol", description: menu_description, price: '10000', category_id: food.id, tenant_id: t13.id },
  { name: "Tusuk Sosis 1pcs", description: menu_description, price: '10000', category_id: food.id, tenant_id: t13.id },
  { name: "Tusuk Nugget 1pcs", description: menu_description, price: '10000', category_id: food.id, tenant_id: t13.id },
  { name: "Tusuk Ro La De", description: menu_description, price: '10000', category_id: food.id, tenant_id: t13.id },
  { name: "Tusuk Kulit", description: menu_description, price: '10000', category_id: food.id, tenant_id: t13.id },
  { name: "Tusuk Telor Puyuh", description: menu_description, price: '10000', category_id: food.id, tenant_id: t13.id },
  { name: "Tusuk Ceker", description: menu_description, price: '10000', category_id: food.id, tenant_id: t13.id },
  { name: "Tusuk Ati Ampela", description: menu_description, price: '10000', category_id: food.id, tenant_id: t13.id },
  { name: "Tahu Goreng", description: menu_description, price: '5000', category_id: food.id, tenant_id: t13.id },
  { name: "Tempe Goreng", description: menu_description, price: '5000', category_id: food.id, tenant_id: t13.id },
  { name: "Bakwan Jagung", description: menu_description, price: '5000', category_id: food.id, tenant_id: t13.id },
  { name: "Bakwan Sayuran", description: menu_description, price: '5000', category_id: food.id, tenant_id: t13.id },
  { name: "Ayam Bakar Manis Khas Angkringan", description: menu_description, price: '20000', category_id: food.id, tenant_id: t13.id },
  { name: "Ayam Bakar Pedas Khas Angkringan", description: menu_description, price: '20000', category_id: food.id, tenant_id: t13.id },

  { name: "Pempek Paket 1", description: "Kapal Selam + Lenjer", price: '27000', category_id: food.id, tenant_id: t14.id },
  { name: "Pempek Paket 2", description: "Lenjer 3pcs", price: '24000', category_id: food.id, tenant_id: t14.id },
  { name: "Pempek Lenggang", description: menu_description, price: '25000', category_id: food.id, tenant_id: t14.id },
  { name: "Tekwan", description: menu_description, price: '25000', category_id: food.id, tenant_id: t14.id },
  { name: "Model", description: menu_description, price: '25000', category_id: food.id, tenant_id: t14.id },
  { name: "Pempek Satuan, Kapal Selam", description: menu_description, price: '20000', category_id: food.id, tenant_id: t14.id },
  { name: "Pempek Satuan, Lenjer", description: menu_description, price: '8000', category_id: food.id, tenant_id: t14.id },
  { name: "Kerupuk Palembang", description: menu_description, price: '10000', category_id: food.id, tenant_id: t14.id },

  { name: "Bakso Tahu", description: "Siomay, Tahu Putih, Tahu Kering, Kol, Paria, Telor", price: '18000', category_id: food.id, tenant_id: t15.id },
  { name: "Batagor", description: "Siomay Kering, Tahu Kering", price: '18000', category_id: food.id, tenant_id: t15.id },

  { name: "Cuankie", description: menu_description, price: '20000', category_id: food.id, tenant_id: t16.id },
  { name: "Cireng", description: menu_description, price: '18000', category_id: food.id, tenant_id: t16.id },
  { name: "Cilok", description: menu_description, price: '20000', category_id: food.id, tenant_id: t16.id },
  { name: "Es Lilin", description: menu_description, price: '6000', category_id: food.id, tenant_id: t16.id },
  { name: "Kripik", description: menu_description, price: '22500', category_id: food.id, tenant_id: t16.id },

  { name: "Lumpia Basah Original", description: menu_description, price: '16000', category_id: food.id, tenant_id: t17.id },
  { name: "Lumpia Basah Ayam", description: menu_description, price: '18000', category_id: food.id, tenant_id: t17.id },
  { name: "Lumpia Basah Baso", description: menu_description, price: '17000', category_id: food.id, tenant_id: t17.id },
  { name: "Lumpia Basah Sapi Cincang", description: menu_description, price: '19000', category_id: food.id, tenant_id: t17.id },
  { name: "Lumpia Goreng Ayam Paprika", description: menu_description, price: '20000', category_id: food.id, tenant_id: t17.id },
  { name: "American Risoles", description: menu_description, price: '15000', category_id: food.id, tenant_id: t17.id },
  { name: "Double Telur", description: menu_description, price: '3000', category_id: food.id, tenant_id: t17.id },

  { name: "Simple Waffle", description: menu_description, price: '17500', category_id: food.id, tenant_id: t18.id },
  { name: "Waffle Sundae", description: menu_description, price: '21000', category_id: food.id, tenant_id: t18.id },
  { name: "Waffle Complicated", description: menu_description, price: '22500', category_id: food.id, tenant_id: t18.id },
  { name: "Waffle Kadu", description: menu_description, price: '21000', category_id: food.id, tenant_id: t18.id },
  { name: "Simple Panini", description: menu_description, price: '17500', category_id: food.id, tenant_id: t18.id },
  { name: "Panini Chicken", description: menu_description, price: '22000', category_id: food.id, tenant_id: t18.id },
  { name: "Panini Meat Beef", description: menu_description, price: '23000', category_id: food.id, tenant_id: t18.id },
  { name: "Simple Kadu", description: menu_description, price: '18000', category_id: food.id, tenant_id: t18.id },

  { name: "Long Sausages", description: menu_description, price: '20000', category_id: food.id, tenant_id: t19.id },
  { name: "Super Long Sausages", description: menu_description, price: '25000', category_id: food.id, tenant_id: t19.id },
  { name: "Big Hotdog", description: menu_description, price: '25000', category_id: food.id, tenant_id: t19.id },
  { name: "Super Big Hotdog", description: menu_description, price: '30000', category_id: food.id, tenant_id: t19.id },
  { name: "Fries Sausages", description: menu_description, price: '25000', category_id: food.id, tenant_id: t19.id },
  { name: "Snail Sausages", description: menu_description, price: '30000', category_id: food.id, tenant_id: t19.id },

  { name: "Kebab Sapi", description: menu_description, price: '19000', category_id: food.id, tenant_id: t20.id },
  { name: "Kebab Mini", description: menu_description, price: '17000', category_id: food.id, tenant_id: t20.id },
  { name: "Kebab Fries", description: menu_description, price: '22000', category_id: food.id, tenant_id: t20.id },
  { name: "Black Kebab", description: menu_description, price: '22000', category_id: food.id, tenant_id: t20.id },
  { name: "Wiener", description: menu_description, price: '17000', category_id: food.id, tenant_id: t20.id },
  { name: "Wiener Jumbo", description: menu_description, price: '20000', category_id: food.id, tenant_id: t20.id },
  { name: "Black Wiener", description: menu_description, price: '22000', category_id: food.id, tenant_id: t20.id },
  { name: "Syawarna", description: menu_description, price: '17000', category_id: food.id, tenant_id: t20.id },
  { name: "Bakso Bakar", description: menu_description, price: '15000', category_id: food.id, tenant_id: t20.id },
  { name: "Tambah Telor", description: menu_description, price: '2500', category_id: food.id, tenant_id: t20.id },

  { name: "Mie Tek-Tek Rebus", description: menu_description, price: '17500', category_id: food.id, tenant_id: t21.id },
  { name: "Mie Tek-Tek Goreng", description: menu_description, price: '17500', category_id: food.id, tenant_id: t21.id },
  { name: "Mie Tek-Tek Rebus Special", description: menu_description, price: '21000', category_id: food.id, tenant_id: t21.id },
  { name: "Mie Tek-Tek Goreng Special", description: menu_description, price: '21000', category_id: food.id, tenant_id: t21.id },
  { name: "Balungan", description: menu_description, price: '15000', category_id: food.id, tenant_id: t21.id },
  { name: "Sate Usus dan Telur", description: menu_description, price: '5000', category_id: food.id, tenant_id: t21.id },

  { name: "Kue Cubit Original", description: menu_description, price: '15000', category_id: food.id, tenant_id: t22.id },
  { name: "Kue Cubit Green Tea Pandan", description: menu_description, price: '16000', category_id: food.id, tenant_id: t22.id },
  { name: "Martabak Mini Keju", description: menu_description, price: '15000', category_id: food.id, tenant_id: t22.id },
  { name: "Martabak Mini Ceres 2 Rasa", description: menu_description, price: '15000', category_id: food.id, tenant_id: t22.id },
  { name: "Martabak Mini Coklat", description: menu_description, price: '15000', category_id: food.id, tenant_id: t22.id },
  { name: "Martabak Mini Selai Buah", description: menu_description, price: '15000', category_id: food.id, tenant_id: t22.id },
  { name: "Pisang Bakar Keju Original", description: menu_description, price: '15000', category_id: food.id, tenant_id: t22.id },
  { name: "Pisang Bakar Keju Spesial", description: menu_description, price: '18000', category_id: food.id, tenant_id: t22.id },
  { name: "Klappertaart Keju", description: menu_description, price: '15000', category_id: food.id, tenant_id: t22.id },
  { name: "Klappertaart Coklat", description: menu_description, price: '15000', category_id: food.id, tenant_id: t22.id },
  { name: "Klappertaart Almond Keju", description: menu_description, price: '15000', category_id: food.id, tenant_id: t22.id },
  { name: "Klappertaart Almond Coklat", description: menu_description, price: '15000', category_id: food.id, tenant_id: t22.id },

  { name: "Udang Goreng Tepung", description: menu_description, price: '32000', category_id: food.id, tenant_id: t23.id },
  { name: "Udang Asam Manis", description: menu_description, price: '32000', category_id: food.id, tenant_id: t23.id },
  { name: "Udang Saus Tiram", description: menu_description, price: '32000', category_id: food.id, tenant_id: t23.id },
  { name: "Udang Lada Hitam", description: menu_description, price: '32000', category_id: food.id, tenant_id: t23.id },
  { name: "Udang Saus Padang", description: menu_description, price: '32000', category_id: food.id, tenant_id: t23.id },
  { name: "Udang Saus Singapore", description: menu_description, price: '32000', category_id: food.id, tenant_id: t23.id },
  { name: "Udang Rica-Rica", description: menu_description, price: '32000', category_id: food.id, tenant_id: t23.id },
  { name: "Cumi Goreng Tepung", description: menu_description, price: '30000', category_id: food.id, tenant_id: t23.id },
  { name: "Cumi Asam Manis", description: menu_description, price: '30000', category_id: food.id, tenant_id: t23.id },
  { name: "Cumi Saus Tiram", description: menu_description, price: '30000', category_id: food.id, tenant_id: t23.id },
  { name: "Cumi Lada Hitam", description: menu_description, price: '30000', category_id: food.id, tenant_id: t23.id },
  { name: "Cumi Saus Padang", description: menu_description, price: '30000', category_id: food.id, tenant_id: t23.id },
  { name: "Cumi Saus Singapore", description: menu_description, price: '30000', category_id: food.id, tenant_id: t23.id },
  { name: "Cumi Rica-Rica", description: menu_description, price: '30000', category_id: food.id, tenant_id: t23.id },
  { name: "Kepiting Goreng Tepung", description: menu_description, price: '42000', category_id: food.id, tenant_id: t23.id },
  { name: "Kepiting Asam Manis", description: menu_description, price: '42000', category_id: food.id, tenant_id: t23.id },
  { name: "Kepiting Saus Tiram", description: menu_description, price: '42000', category_id: food.id, tenant_id: t23.id },
  { name: "Kepiting Lada Hitam", description: menu_description, price: '42000', category_id: food.id, tenant_id: t23.id },
  { name: "Kepiting Saus Padang", description: menu_description, price: '42000', category_id: food.id, tenant_id: t23.id },
  { name: "Kepiting Saus Singapore", description: menu_description, price: '42000', category_id: food.id, tenant_id: t23.id },
  { name: "Kepiting Rica-Rica", description: menu_description, price: '42000', category_id: food.id, tenant_id: t23.id },
  { name: "Bawal Goreng", description: menu_description, price: '32000', category_id: food.id, tenant_id: t23.id },
  { name: "Bawal Bakar", description: menu_description, price: '32000', category_id: food.id, tenant_id: t23.id },
  { name: "Krapu Goreng", description: menu_description, price: '30000', category_id: food.id, tenant_id: t23.id },
  { name: "Krapu Bakar", description: menu_description, price: '30000', category_id: food.id, tenant_id: t23.id },
  { name: "Gurame Goreng", description: menu_description, price: '35000', category_id: food.id, tenant_id: t23.id },
  { name: "Gurame Bakar", description: menu_description, price: '35000', category_id: food.id, tenant_id: t23.id },
  { name: "Kangkung Cha Udang", description: menu_description, price: '25000', category_id: food.id, tenant_id: t23.id },
  { name: "Capcay Seafood", description: menu_description, price: '25000', category_id: food.id, tenant_id: t23.id },

  { name: "Nasi Gila", description: menu_description, price: '28000', category_id: food.id, tenant_id: t24.id },
  { name: "Nasi Sapi Lada Hitam", description: menu_description, price: '30000', category_id: food.id, tenant_id: t24.id },
  { name: "Seblak Ceker", description: menu_description, price: '18000', category_id: food.id, tenant_id: t24.id },
  { name: "Seblak Galau", description: menu_description, price: '18000', category_id: food.id, tenant_id: t24.id },
  { name: "Nasi Putih", description: menu_description, price: '5000', category_id: food.id, tenant_id: t24.id },

  { name: "Bushet Dah", description: "Bruschetta mix 3 flavour", price: '20000', category_id: food.id, tenant_id: t25.id },
  { name: "Fill In", description: "Chicken fillet & french fries", price: '30000', category_id: food.id, tenant_id: t25.id },
  { name: "Nechis", description: "Chicken wings, kentang, sosis, scalop", price: '30000', category_id: food.id, tenant_id: t25.id },
  { name: "Frikadellen", description: "Mix grill bread with meat" , price: '30000', category_id: food.id, tenant_id: t25.id },
  { name: "Tongsis", description: "Tongkat Cheese Stick", price: '25000', category_id: food.id, tenant_id: t25.id },
  { name: "Red Spa", description: "Spaghetti Bolognese", price: '30000', category_id: food.id, tenant_id: t25.id },
  { name: "Pudel", description: "Puding delicious", price: '20000', category_id: food.id, tenant_id: t25.id },
  { name: "Browndong", description: "Brownies Es Dondong", price: '20000', category_id: food.id, tenant_id: t25.id },

  { name: "Ice Cream Crunchy Triple X", description: menu_description, price: '19500', category_id: food.id, tenant_id: t26.id },
  { name: "Chocolate Melody", description: menu_description, price: '21500', category_id: food.id, tenant_id: t26.id },
  { name: "Tropical Desert", description: menu_description, price: '22500', category_id: food.id, tenant_id: t26.id },
  { name: "Coconut Green Tea Single", description: menu_description, price: '18500', category_id: food.id, tenant_id: t26.id },
  { name: "Coconut Green Tea Jumbo", description: menu_description, price: '25000', category_id: food.id, tenant_id: t26.id },
  { name: "Melow Drama Queen", description: menu_description, price: '24000', category_id: food.id, tenant_id: t26.id },
  { name: "Melow Drama King", description: menu_description, price: '24000', category_id: food.id, tenant_id: t26.id },
  { name: "Melow Drama Prince", description: menu_description, price: '30000', category_id: food.id, tenant_id: t26.id },
  { name: "Melow Drama Princess", description: menu_description, price: '26500', category_id: food.id, tenant_id: t26.id },
  { name: "Mango Melow Melted", description: menu_description, price: '25000', category_id: food.id, tenant_id: t26.id },
  { name: "Holiday Desert", description: menu_description, price: '29500', category_id: food.id, tenant_id: t26.id },
  { name: "Fresh Island", description: menu_description, price: '27000', category_id: food.id, tenant_id: t26.id },
  { name: "Pink Beach", description: menu_description, price: '26500', category_id: food.id, tenant_id: t26.id },
  { name: "Nuttela Crushed Hotplate", description: menu_description, price: '29000', category_id: food.id, tenant_id: t26.id },
  { name: "Flame Nutella Crushed Hotplate", description: menu_description, price: '31000', category_id: food.id, tenant_id: t26.id },
  { name: "Berry Harvest", description: menu_description, price: '24500', category_id: food.id, tenant_id: t26.id },

  { name: "Es Campur", description: menu_description, price: '14000', category_id: food.id, tenant_id: t27.id },
  { name: "Es Teler", description: menu_description, price: '14000', category_id: food.id, tenant_id: t27.id },
  { name: "Es Doger", description: menu_description, price: '15000', category_id: food.id, tenant_id: t27.id },
  { name: "Es Alpukat Negro", description: menu_description, price: '15000', category_id: food.id, tenant_id: t27.id },
  { name: "Es Campur Peyeum Bandung", description: menu_description, price: '15000', category_id: food.id, tenant_id: t27.id },

  { name: "Nasi Ayam Kremes", description: menu_description, price: '35000', category_id: food.id, tenant_id: t28.id },
  { name: "Nasi Ikan Colo-colo", description: menu_description, price: '40000', category_id: food.id, tenant_id: t28.id },
  { name: "Nasi Goang Melak Sunda", description: menu_description, price: '45000', category_id: food.id, tenant_id: t28.id },
  { name: "Nasi Rawon Daging/Iga", description: menu_description, price: '45000', category_id: food.id, tenant_id: t28.id },
  { name: "Nasi Iga Penyet", description: menu_description, price: '50000', category_id: food.id, tenant_id: t28.id },

  { name: "Nasi Santan Kuah Ayam Kampung", description: menu_description, price: '35000', category_id: food.id, tenant_id: t29.id },

  { name: "Hakau", description: menu_description, price: '22000', category_id: food.id, tenant_id: t30.id },
  { name: "Siomay Kukus", description: menu_description, price: '22000', category_id: food.id, tenant_id: t30.id },
  { name: "Xiau Longpau", description: menu_description, price: '22000', category_id: food.id, tenant_id: t30.id },
  { name: "Paikut", description: menu_description, price: '22000', category_id: food.id, tenant_id: t30.id },
  { name: "Kaica", description: menu_description, price: '22000', category_id: food.id, tenant_id: t30.id },
  { name: "Lomakai", description: menu_description, price: '22000', category_id: food.id, tenant_id: t30.id },
  { name: "Angsio Kaki Ayam", description: menu_description, price: '22000', category_id: food.id, tenant_id: t30.id },
  { name: "Isitkau", description: menu_description, price: '22000', category_id: food.id, tenant_id: t30.id },
  { name: "Kuotie", description: menu_description, price: '22000', category_id: food.id, tenant_id: t30.id },
  { name: "Ekado", description: menu_description, price: '22000', category_id: food.id, tenant_id: t30.id },
  { name: "Bapau Tausa", description: menu_description, price: '22000', category_id: food.id, tenant_id: t30.id },
  { name: "Bapau Chasaw", description: menu_description, price: '22000', category_id: food.id, tenant_id: t30.id },
  { name: "Bapau Naiyu", description: menu_description, price: '22000', category_id: food.id, tenant_id: t30.id },
  { name: "Bapau Pandan", description: menu_description, price: '22000', category_id: food.id, tenant_id: t30.id },
  { name: "Bapau Talas", description: menu_description, price: '22000', category_id: food.id, tenant_id: t30.id },
  { name: "Bapau Art", description: menu_description, price: '22000', category_id: food.id, tenant_id: t30.id },
  { name: "Lumpiah Kulit Tahu", description: menu_description, price: '22000', category_id: food.id, tenant_id: t30.id },
  { name: "Isit Goreng Mayones", description: menu_description, price: '22000', category_id: food.id, tenant_id: t30.id },
  { name: "Siomay Goreng", description: menu_description, price: '22000', category_id: food.id, tenant_id: t30.id },
  { name: "Pangsit Kucai", description: menu_description, price: '22000', category_id: food.id, tenant_id: t30.id },

  { name: "Yakitori Moriawase", description: menu_description, price: '32500', category_id: food.id, tenant_id: t31.id },
  { name: "Yakitori Konbo", description: menu_description, price: '28000', category_id: food.id, tenant_id: t31.id },
  { name: "Shifudo Moriawase", description: menu_description, price: '35000', category_id: food.id, tenant_id: t31.id },
  { name: "Amaze Balls", description: menu_description, price: '20000', category_id: food.id, tenant_id: t31.id },

  { name: "Ketan Susu Topping Durian", description: "Ketan putih pulen + SKM + vla durian + kuah susu Full Cream", price: '25000', category_id: food.id, tenant_id: t32.id },
  { name: "Ketan Susu Topping Tape Ijo", description: "Ketan putih pulen + SKM + tape ketan + kuah susu full cream", price: '16000', category_id: food.id, tenant_id: t32.id },
  { name: "Ketan Susu Topping Abon", description: "Ketan putih pulen + taburan abon sapi", price: '16000', category_id: food.id, tenant_id: t32.id },
  { name: "Ketan Susu Topping Keju", description: "Ketan putih pulen + SKM + taburan keju parut + susu cair full cream", price: '16000', category_id: food.id, tenant_id: t32.id },
  { name: "Ketan Susu Topping Messes Ceres", description: menu_description, price: '16000', category_id: food.id, tenant_id: t32.id },
  { name: "Ketan Susu Topping Pisang", description: menu_description, price: '16000', category_id: food.id, tenant_id: t32.id },
  { name: "Ketan Susu Topping Oreo", description: menu_description, price: '16000', category_id: food.id, tenant_id: t32.id },
  { name: "Ketan Susu Topping Mix Keju Ceres", description: menu_description, price: '18000', category_id: food.id, tenant_id: t32.id },
  { name: "Ketan Susu Topping Mix Durian Keju", description: menu_description, price: '22000', category_id: food.id, tenant_id: t32.id },
  { name: "Ketan Susu Topping Mix Abon Keju", description: menu_description, price: '22000', category_id: food.id, tenant_id: t32.id },
  { name: "Roti Bakar Gembul Susu Coklat", description: menu_description, price: '13500', category_id: food.id, tenant_id: t32.id },
  { name: "Roti Bakar Gembul Susu Coklat Keju", description: menu_description, price: '15500', category_id: food.id, tenant_id: t32.id },
  { name: "Roti Bakar Gembul Susu Keju", description: menu_description, price: '15500', category_id: food.id, tenant_id: t32.id },
  { name: "Roti Bakar Gembul Susu Coklat Keju Milo", description: menu_description, price: '12500', category_id: food.id, tenant_id: t32.id },
  { name: "Roti Bakar Telur", description: menu_description, price: '12500', category_id: food.id, tenant_id: t32.id },
  { name: "Roti Bakar Telur Kornet", description: menu_description, price: '15500', category_id: food.id, tenant_id: t32.id },
  { name: "Roti Susu Nutella", description: menu_description, price: '18500', category_id: food.id, tenant_id: t32.id },
  { name: "Roti Susu Banana", description: menu_description, price: '16500', category_id: food.id, tenant_id: t32.id },
  { name: "Roti Mentega Gula", description: menu_description, price: '11500', category_id: food.id, tenant_id: t32.id },
  { name: "Roti Bakar Gembul", description: "Gula + Kornet + Keju", price: '20500', category_id: food.id, tenant_id: t32.id },

  { name: "Veggie Suki Hotpot (Vegetarian)", description: menu_description, price: '23000', category_id: food.id, tenant_id: t33.id },
  { name: "Veggie Suki Asam pedas Hotpot", description: menu_description, price: '24500', category_id: food.id, tenant_id: t33.id },
  { name: "Chicken Suki Hotpot", description: menu_description, price: '27000', category_id: food.id, tenant_id: t33.id },
  { name: "Chicken Suki Asam Pedas Hotpot", description: menu_description, price: '28500', category_id: food.id, tenant_id: t33.id },
  { name: "Beef Suki Hotpot", description: menu_description, price: '29500', category_id: food.id, tenant_id: t33.id },
  { name: "Beef Suki Asam Pedas Hotpot", description: menu_description, price: '31500', category_id: food.id, tenant_id: t33.id },
  { name: "Fish Suki Hotpot", description: menu_description, price: '29000', category_id: food.id, tenant_id: t33.id },
  { name: "Fish Suki Asam Pedas Hotpot", description: menu_description, price: '31000', category_id: food.id, tenant_id: t33.id },
  { name: "Mixed Suki Hotpot", description: menu_description, price: '32000', category_id: food.id, tenant_id: t33.id },
  { name: "Mixed Suki Asam Pedas Hotpot", description: menu_description, price: '33500', category_id: food.id, tenant_id: t33.id },
  { name: "Premium Suki Hotpot", description: menu_description, price: '34500', category_id: food.id, tenant_id: t33.id },
  { name: "Premium SUki Asam Pedas Hotpot", description: menu_description, price: '36500', category_id: food.id, tenant_id: t33.id },
  { name: "Extra Beef", description: menu_description, price: '14000', category_id: food.id, tenant_id: t33.id },
  { name: "Extra Chicken", description: menu_description, price: '12000', category_id: food.id, tenant_id: t33.id },
  { name: "Chicken Sweet", description: menu_description, price: '8000', category_id: food.id, tenant_id: t33.id },
  { name: "Chicken Salty", description: menu_description, price: '8000', category_id: food.id, tenant_id: t33.id },
  { name: "Chicken Spicy", description: menu_description, price: '8000', category_id: food.id, tenant_id: t33.id },
  { name: "Beef Seet", description: menu_description, price: '8000', category_id: food.id, tenant_id: t33.id },
  { name: "Beef Salty", description: menu_description, price: '8000', category_id: food.id, tenant_id: t33.id },
  { name: "Beef Spicy", description: menu_description, price: '8000', category_id: food.id, tenant_id: t33.id },
  { name: "Mixed Beef & Chicken Sweet", description: menu_description, price: '8000', category_id: food.id, tenant_id: t33.id },
  { name: "Mixed Beef & Chicken Salty", description: menu_description, price: '8000', category_id: food.id, tenant_id: t33.id },
  { name: "Mixed Beef & Chicken Spicy", description: menu_description, price: '8000', category_id: food.id, tenant_id: t33.id },
  { name: "Rice Bowl Beef Ala Ocha", description: menu_description, price: '8000', category_id: food.id, tenant_id: t33.id },
  { name: "Rice Bowl Chicken Ala Ocha", description: menu_description, price: '8000', category_id: food.id, tenant_id: t33.id },
  { name: "Rice Bowl Fish With Singapore Sauce", description: menu_description, price: '8000', category_id: food.id, tenant_id: t33.id },
  { name: "Rice Bowl Squid With Singapore Sauce", description: menu_description, price: '8000', category_id: food.id, tenant_id: t33.id },
  { name: "Rice Bowl Shrimp With Singapore Sauce", description: menu_description, price: '8000', category_id: food.id, tenant_id: t33.id },
  { name: "Rice Bowl Egg Chicken Roll", description: menu_description, price: '8000', category_id: food.id, tenant_id: t33.id },
  { name: "Rice Bowl Shrimp Roll", description: menu_description, price: '8000', category_id: food.id, tenant_id: t33.id },
  { name: "Rice Bowl Spicy Chicken", description: menu_description, price: '8000', category_id: food.id, tenant_id: t33.id },
  { name: "Rice Bowl Ekkado", description: menu_description, price: '8000', category_id: food.id, tenant_id: t33.id },

  { name: "Aqua", description: menu_description, price: '3000', category_id: drink.id, tenant_id: t34.id },
  { name: "Coca Cola", description: menu_description, price: '7000', category_id: drink.id, tenant_id: t34.id },
  { name: "Sprite", description: menu_description, price: '7000', category_id: drink.id, tenant_id: t34.id },
  { name: "Fanta", description: menu_description, price: '6000', category_id: drink.id, tenant_id: t34.id },
  { name: "Tebs Tea", description: menu_description, price: '6000', category_id: drink.id, tenant_id: t34.id },
  { name: "Fruit Tea", description: menu_description, price: '6000', category_id: drink.id, tenant_id: t34.id },
  { name: "Fresh Tea", description: menu_description, price: '6000', category_id: drink.id, tenant_id: t34.id },
  { name: "Pocari Sweat", description: menu_description, price: '10000', category_id: drink.id, tenant_id: t34.id },
  { name: "Coffee", description: menu_description, price: '12000', category_id: drink.id, tenant_id: t34.id },
  { name: "Tea", description: menu_description, price: '8000', category_id: drink.id, tenant_id: t34.id },
  { name: "Duren Lumer", description: menu_description, price: '25000', category_id: drink.id, tenant_id: t34.id },
])
