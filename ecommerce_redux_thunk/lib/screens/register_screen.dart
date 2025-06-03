import 'package:flutter/material.dart';
import 'package:ecommerce_redux_thunk/services/user_service.dart';
import 'package:ecommerce_redux_thunk/models/user_model.dart';
import 'package:ecommerce_redux_thunk/constans/texts.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = '/register';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserService _userService = UserService();

  Future<void> _registerUser() async {
    final String name = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    if (name.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both username and password')),
      );
      return;
    }

    final users = await _userService.getAllUsers();

    final usernameExists = users.userList.any((user) => user.name == name);
      if (usernameExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username already exists!')),
        );
        return;
    }
  
    final int newId = users.userList.isEmpty
        ? 1
        : users.userList.map((u) => u.id).reduce((a, b) => a > b ? a : b) + 1;

    final newUser = User(id: newId, name: name, password: password);

    await _userService.addUser(newUser);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User registered succesfully!')),
    );

    // Optionally clear fields
    _usernameController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _registerUser,
              child: const Text(
                'Register',
                style: CustomTextStyles.buttonText,
              )
            ),
            ElevatedButton(
              onPressed: () async {
                await _userService.printJsonContent();
              },
              child: const Text(
                'Print Users',
                style: CustomTextStyles.buttonText,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await _userService.clearAllUsers();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All users deleted.')),
                );
              },
              child: const Text(
                'Clear Users',
                style: CustomTextStyles.buttonText,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await _userService.getJsonFilePath();
              },
              child: const Text(
                'Print Users Path',
                style: CustomTextStyles.buttonText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}