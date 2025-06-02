import 'dart:convert';
import 'dart:io';

import '../models/user_model.dart';
import 'package:path_provider/path_provider.dart';

class UserService {
  final String _fileName = 'users.json';
  
  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$_fileName';
  }

  Future<File> _getFile() async {
    final path = await _getFilePath();
    final file = File(path);

    if (!await file.exists()) {
      await file.create(recursive: true);
      await file.writeAsString(jsonEncode({'user': []}));
    }

    return file;
  }

  Future<UserList> getAllUsers() async {
    final file = await _getFile();
    final content = await file.readAsString();
    final json = jsonDecode(content);
    return UserList.fromJson(json);
  }

  Future<void> addUser(User newUser) async {
    final file = await _getFile();
    final userList = await getAllUsers();

    final updatedList = List<User>.from(userList.userList)..add(newUser);
    final updatedUserList = UserList(userList: updatedList);

    final json = jsonEncode(updatedUserList.toJson());
    await file.writeAsString(json);
  }

  // Future<void> deleteUser() async {
  //   try {
  //     final file = File(_filePath);
  //     if (await file.exists()) {
  //       await file.delete();
  //     }
  //   } catch (e) {
  //     print('Error deleting user data: $e');
  //   }
  // }
}