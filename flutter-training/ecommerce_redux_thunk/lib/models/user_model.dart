class UserList {
  List<User> userList;

  UserList({required this.userList});

  factory UserList.fromJson(Map<String, dynamic> json) {
    var userListFromJson = json['user'] as List;
    List<User> users = userListFromJson
        .map((userJson) => User.fromJson(userJson))
        .toList();
    return UserList(userList: users);
  }

  Map<String, dynamic> toJson() {
    return {'user': userList.map((user) => user.toJson()).toList()};
  }
}

class User {
  final int id;
  final String name;
  final String password;

  User({required this.id, required this.name, required this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json['id'], name: json['name'], password: json['password']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'password': password};
  }
}
