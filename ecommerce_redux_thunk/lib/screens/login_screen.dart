import 'package:flutter/material.dart';
import '../screens/register_screen.dart';
import '../services/user_service.dart';
import '../constans/colors.dart';
import '../constans/texts.dart';
import '../screens/home_screen.dart';
import '../widgets/user_bottom_bar.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../redux/states/app_state.dart';
import '../redux/middlewares/user_thunk.dart';

class LoginScreen extends StatefulWidget {
  static const String id = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserService _userService = UserService();
  bool _isLoading = false;
  String? _error;

  void _submit(Store<AppState> store) async {
    final String name = _usernameController.text.trim();
    final String password = _passwordController.text.trim();
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final users = await _userService.getAllUsers();

    final bool usernameExists = users.userList.any((user) => user.name == name);
    final wrongPassword = users.userList.any(
      (user) => user.name == name && user.password != password,
    );

    if (!usernameExists) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Username does not exist!')));
      return;
    } else if (wrongPassword) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password is incorrect 😕!')),
      );
      return;
    }

    try {
      await store.dispatch(
        loginUserThunk(_usernameController.text, _passwordController.text),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Logged in successfully!")),
        );

        Navigator.pushNamed(context, HomeScreen.id);
      }
    } catch (e) {
      setState(() {
        _error = "Logging in failed: ${e.toString()}";
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
    return StoreConnector<AppState, Store<AppState>>(
      converter: (store) => store,
      builder: (context, store) {
        return Scaffold(
          appBar: AppBar(title: const Text('Log In Page')),
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
                          onPressed: () {
                            _submit(store);
                          },
                          child: const Text(
                            'Login',
                            style: CustomTextStyles.buttonText,
                          ),
                        ),
                  const SizedBox(height: 40),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account?',
                            style: TextStyle(
                              color: CustomColors.backgroundColor,
                            ),
                          ),
                          const SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, RegisterScreen.id);
                            },
                            child: Text(
                              'Signup Page',
                              style: TextStyle(
                                color: CustomColors.backgroundColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),
                      Text(
                        'Or',
                        style: TextStyle(color: CustomColors.backgroundColor),
                      ),
                      SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Continue as Guest?',
                            style: TextStyle(
                              color: CustomColors.backgroundColor,
                            ),
                          ),
                          const SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, HomeScreen.id);
                            },
                            child: Text(
                              'Home Page',
                              style: TextStyle(
                                color: CustomColors.backgroundColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: const UserBottomBar(),
        );
      },
    );
  }
}
