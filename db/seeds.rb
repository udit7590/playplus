
# Create admin user
User.create(username: 'udit7590', email: 'udit.mittal1990@gmail.com',
role: User.roles[:admin], first_name: 'Udit', last_name: 'Mittal', password: Rails.application.secrets['admin_password']
).confirm!
