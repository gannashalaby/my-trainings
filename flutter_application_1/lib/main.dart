import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

enum Actions { increment }

TextStyle myNormalStyle = TextStyle(color: Colors.blue, fontSize: 18.0);

int counterReducer(int state, dynamic action) {
  return action == Actions.increment ? state + 1 : state;
}

void main() {
  final store = Store<int>(counterReducer, initialState: 0);

  runApp(FlutterReduxApp(title: 'Flutter Redux Demo', store: store));
}

class FlutterReduxApp extends StatelessWidget {
  final Store<int> store;
  final String title;

  FlutterReduxApp({super.key, required this.title, required this.store});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider<int>(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData.dark(),
        home: MyHomePage(title: title, store: store),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.store});

  final Store<int> store;
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.title, style: TextStyle(color: Colors.red)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StoreConnector<int, String>(
              converter: (store) => store.state.toString(),
              builder: (context, counter) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'You have pushed the button this many times:',
                      style: myNormalStyle,
                    ),
                    Text(
                      '$counter',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: StoreConnector<int, VoidCallback>(
        converter: (store) {
          return () => store.dispatch(Actions.increment);
        },
        builder: (context, callback) {
          return FloatingActionButton(
            onPressed: callback,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
            backgroundColor: Colors.black54,
            foregroundColor: Colors.red,
          );
        }
      )
    );
  }
}
//Refrence: https://pub.dev/documentation/flutter_redux/latest/
