import 'package:flutter/material.dart';
import 'package:ecommerce_redux_thunk/constans/colors.dart';
import 'package:ecommerce_redux_thunk/screens/home_screen.dart';
import 'package:ecommerce_redux_thunk/screens/login_screen.dart';
import 'package:ecommerce_redux_thunk/services/user_service.dart';
import 'package:ecommerce_redux_thunk/constans/texts.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ecommerce_redux_thunk/redux/states/user_state.dart';
import 'package:ecommerce_redux_thunk/redux/middleware/user_thunk.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = '/register';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserService _userService = UserService();
  bool _isLoading = false;
  String? _error;

  void _submit(Store<UserState> store) async {
    final String name = _usernameController.text.trim();
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final users = await _userService.getAllUsers();

    final usernameExists = users.userList.any((user) => user.name == name);
      if (usernameExists) {
        setState(() {
          _isLoading = false;
        });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Username already exists!',
            style: CustomTextStyles.errorTextStyle,
          ),
        ),
      );
      return;
    }

    try {
      await store.dispatch(
        registerUserThunk(_usernameController.text, _passwordController.text),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Signed up successfully!")),
        );
        _usernameController.clear();
        _passwordController.clear();

        Navigator.pushNamed(context, HomeScreen.id);
      }
    } catch (e) {
      setState(() {
        _error = "Registration failed: ${e.toString()}";
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<UserState, Store<UserState>>(
      converter: (store) => store,
      builder: (context, store) {
        return Scaffold(
          appBar: AppBar(title: const Text('Sign Up Screen')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  if (_error != null)
                    Text(_error!, style: CustomTextStyles.errorTextStyle),
                  TextFormField(
                    controller: _usernameController,
                    style: TextStyle(color: CustomColors.backgroundColor),
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      labelStyle: CustomTextStyles.buttonText,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: CustomColors.backgroundColor,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: CustomColors.backgroundColor,
                        ),
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter username' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController,
                    style: TextStyle(color: CustomColors.backgroundColor),
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      labelStyle: CustomTextStyles.buttonText,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: CustomColors.backgroundColor,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: CustomColors.backgroundColor,
                        ),
                      ),
                    ),
                    obscureText: true,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter password' : null,
                  ),
                  const SizedBox(height: 24),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () => _submit(store),
                          child: const Text(
                            'Signup',
                            style: CustomTextStyles.buttonText,
                          ),
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
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: StoreConnector<UserState, Store<UserState>>(
            converter: (store) => store,
            builder: (context, store) {
              return Container(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        store.dispatch(printUsersThunk());
                      },
                      child: const Text(
                        'Print Users',
                        style: CustomTextStyles.smallButtonText,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        store.dispatch(clearUsersThunk());
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
                      onPressed: () {
                        store.dispatch(printUserPathThunk());
                      },
                      child: const Text(
                        'Print Users Path',
                        style: CustomTextStyles.smallButtonText,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
