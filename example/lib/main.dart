import 'package:flutter/material.dart';
import 'package:flutter_emoji_selector/flutter_emoji_selector.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'EMOJI demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emoji Selector')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: TextButton(
              child: const Text('Open Emoji Selector 😀'),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  enableDrag: false,
                  builder: (context) {
                    return BottomSheet(
                      onClosing: () {},
                      enableDrag: false,
                      builder: ((context) {
                        return EmojiSelector(
                          onEmojiSelected: (emoji) {
                            print(emoji.char); // prints the emoji
                            print(emoji.name); // prints the emoji name
                          },
                        );
                      }),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
