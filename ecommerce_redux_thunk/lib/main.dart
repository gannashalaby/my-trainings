import 'package:ecommerce_redux_thunk/constans/colors.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ecommerceThunk());
}

class ecommerceThunk extends StatelessWidget {
  const ecommerceThunk({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Commerce Thunk',
      theme: ThemeData(
        colorScheme: ColorScheme(
          primary: CustomColors.bodyColor,//
          primaryContainer: CustomColors.backgroundColor,
          secondary: CustomColors.successColor,//
          // secondaryContainer: CustomColors.successColor,
          // background: CustomColors.bodyColor,
          surface: CustomColors.bodyColor,
          error: CustomColors.errorColor,//
          onPrimary: CustomColors.textColor,
          onSecondary: Colors.black,//
          // onBackground: CustomColors.textColor,
          onSurface: CustomColors.textColor,
          onError: Colors.white,//
          brightness: Brightness.light,
        ),
      ),
      home: const MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.backgroundColor,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
//Refrences:
// 1. https://www.geeksforgeeks.org/what-is-the-use-of-middleware-redux-thunk/ (until Steps to Setup of Redux with Thunk)
// 2. https://github.com/rashidwassan/flutter-ecommerce-app-ui/tree/main
