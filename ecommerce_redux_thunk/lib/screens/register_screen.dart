import 'package:flutter/material.dart';
import '../constans/colors.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../services/user_service.dart';
import '../constans/texts.dart';
import '../widgets/user_bottom_bar.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ecommerce_redux_thunk/redux/states/app_state.dart';
import 'package:ecommerce_redux_thunk/redux/middlewares/user_thunk.dart';

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

  void _submit(Store<AppState> store) async {
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
    return StoreConnector<AppState, Store<AppState>>(
      converter: (store) => store,
      builder: (context, store) {
        return Scaffold(
          appBar: AppBar(title: const Text('Sign Up Page')),
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
          bottomNavigationBar: const UserBottomBar(),
        );
      },
    );
  }
}
