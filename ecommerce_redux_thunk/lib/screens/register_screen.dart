import 'package:ecommerce_redux_thunk/constans/colors.dart';
import 'package:ecommerce_redux_thunk/screens/home_screen.dart';
import 'package:ecommerce_redux_thunk/screens/login_screen.dart';
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
    _usernameController.clear();
    _passwordController.clear();

    Navigator.pushNamed(context, HomeScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              TextField(
                controller: _usernameController,
                style: TextStyle(color: CustomColors.backgroundColor),
                decoration: const InputDecoration(
                  labelText: 'Username',
                  labelStyle: CustomTextStyles.buttonText,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.backgroundColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.backgroundColor),
                  ),
                ),
              ),
              TextField(
                controller: _passwordController,
                style: TextStyle(color: CustomColors.backgroundColor),
                decoration: const InputDecoration(
                  labelText: 'Password',
                  labelStyle: CustomTextStyles.buttonText,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.backgroundColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: CustomColors.backgroundColor),
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _registerUser,
                child: const Text(
                  'Signup',
                  style: CustomTextStyles.buttonText,
                )
              ),
              const SizedBox(height: 20),
              Text(
                'Already have an account?',
                style: CustomTextStyles.caption,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
                child: const Text(
                  'Login',
                  style: CustomTextStyles.buttonText,
                )
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await _userService.printJsonContent();
              },
              child: const Text(
                'Print Users',
                style: CustomTextStyles.smallButtonText,
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
                style: CustomTextStyles.smallButtonText,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await _userService.getJsonFilePath();
              },
              child: const Text(
                'Print Users Path',
                style: CustomTextStyles.smallButtonText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}