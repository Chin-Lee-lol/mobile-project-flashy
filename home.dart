import 'package:flutter/material.dart';
import 'deck.dart';
import 'quiz.dart';

class Palette {
  static const MaterialColor kToDark = MaterialColor(
    0xFF4ecca3, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xFF4ecca3),//10%
      100: Color(0xFF4ecca3),//20%
      200: Color(0xFF4ecca3),//30%
      300: Color(0xFF4ecca3),//40%
      400: Color(0xFF4ecca3),//50%
      500: Color(0xFF4ecca3),//60%
      600: Color(0xFF4ecca3),//70%
      700: Color(0xFF4ecca3),//80%
      800: Color(0xFF4ecca3),//90%
      900: Color(0xFF4ecca3),//100%
    },
  );
}
class MyAppHome extends StatelessWidget {
  const MyAppHome({Key? key, required this.id}) : super(key: key);
  final String id;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Palette.kToDark,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page l0l'),
      home:  MyHomePage(title: '', uidd: id, idx: 0),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.uidd, required this.idx}) : super(key: key);

  final String title;
  final String uidd;
  final int idx;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = <Widget>[
      DeckPage(title: 'Your Deck', id: widget.uidd ),
      QuizPage(title: 'Quiz', id: widget.uidd),
    ];

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Deck',
            backgroundColor: Colors.lightBlue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb),
            label: 'Quiz',
            backgroundColor: Colors.redAccent,
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.attach_money),
          //   label: 'Deals',
          //   backgroundColor: Colors.lightGreen,
          // ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.settings),
          //   label: 'Settings',
          //   backgroundColor: Colors.grey,
          // ),
        ],
        selectedItemColor: Colors.black,
        currentIndex: _selectedIndex, //New
        onTap: _onItemTapped,         //New
      ),
    );
  }
}
