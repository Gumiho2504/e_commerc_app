class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final Role role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    Role? role,
  }) : role = role ?? Role.user;
}

enum Role { admin, user }

class Product {}
