class User {
  int id;
  String name;
  String email;
  User(this.id, this.name, this.email);
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}
void main() {
  List<User> users = [
    User(01, 'New York', 'newyork@citymail.com'),
    User(02, 'Los Angeles', 'losangeles@citymail.com'),
    User(03, 'Chicago', 'chicago@citymail.com'),
    User(04, 'Houston', 'houston@citymail.com'),
    User(05, 'Phoenix', 'phoenix@citymail.com'),
    User(06, 'Philadelphia', 'philadelphia@citymail.com'),
    User(07, 'San Antonio', 'sanantonio@citymail.com'),
    User(08, 'San Diego', 'sandiego@citymail.com'),
    User(09, 'Dallas', 'dallas@citymail.com'),
    User(010, 'San Jose', 'sanjose@citymail.com'),
  ];
  for (User user in users) {
    print(user.toJson());
  }
}
