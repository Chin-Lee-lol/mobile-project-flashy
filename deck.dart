
// ignore_for_file: avoid_print

import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'card.dart';
import 'main.dart';

//ignore_for_file: prefer_const_constructors

class Palette {
  static const MaterialColor kToDark = const MaterialColor(
    0xFF4ecca3, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    const <int, Color>{
      50: const Color(0xFF4ecca3),//10%
      100: const Color(0xFF4ecca3),//20%
      200: const Color(0xFF4ecca3),//30%
      300: const Color(0xFF4ecca3),//40%
      400: const Color(0xFF4ecca3),//50%
      500: const Color(0xFF4ecca3),//60%
      600: const Color(0xFF4ecca3),//70%
      700: const Color(0xFF4ecca3),//80%
      800: const Color(0xFF4ecca3),//90%
      900: const Color(0xFF4ecca3),//100%
    },
  );
}

class DeckPage extends StatefulWidget {
  const DeckPage({Key? key, required this.title, required this.id}) : super(key: key);
  final String id;
  final String title;

  @override
  State<DeckPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<DeckPage> {
  final List<String?> decklist = <String?> [];
  var deckController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  int count = 0;

  @override
  Widget build(BuildContext context) {
    void refresh(){
      count++;
      print(count);
      decklist.clear();
      deckController.text = "";
      final deckRef = FirebaseDatabase.instance.ref();
      deckRef.child(widget.id).onChildAdded.forEach((element) {
        decklist.add(element.snapshot.key);
        setState((){});
      });
    }
    if (count == 0)
      {
        refresh();
      }
    final List<String?> searchList = decklist;
    @override
    void initState() {
      decklist.addAll(searchList);
      super.initState();
    }
    void filterSearchResults(String query) {
      List<String?> dummySearchList = <String?>[];
      dummySearchList.addAll(searchList);
      if(query.isNotEmpty) {
        List<String?> dummyListData = <String?>[];
        dummySearchList.forEach((item) {
          if(item!.contains(query)) {
            dummyListData.add(item);
          }
        });
        setState(() {
          decklist.clear();
          decklist.addAll(dummyListData);
        });
        return;
      } else {
        refresh();
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer:Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Palette.kToDark,
              ),
              child: Text('More options',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),),
            ),
            ListTile(
              title: const Text('About Us'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) =>
                      AlertDialog(
                        title: Text('This app was create to be a project app for my mobile '
                            'development class. \nThis app solely made by one people (which is me of course lol) '
                            'in one month. I did put a lot of effort and time into it, so I hope you enjoyed it :D'),
                        actions: [
                          ElevatedButton(
                            child: Text('Cool'),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                );
              },
            ),
            ListTile(
              title: const Text('Contact Us'),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) =>
                    AlertDialog(
                      title: Text('Found a bug? Wanted to suggest new feature?\n'
                          'Reached me out through \n\nchinl@cpp.edu\n\n'
                          'I might update if I feels like lol XD'),
                      actions: [
                        ElevatedButton(
                          child: Text('Cool'),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                );
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('id');
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (BuildContext ctx) => MyApp()));
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 8,
                  child:
                    TextField(
                      obscureText: false,
                      controller: searchController,
                      onChanged: (value) {filterSearchResults(searchController.text);},
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)
                        ),
                    hintText: 'Search',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          onPressed: (){
                            searchController.text = '';
                            refresh();
                          },
                          icon: Icon(Icons.clear)
                        )
                      ),
                    ),
              ),
               Expanded(
                flex: 80,
                  child:ListView.separated(
                      itemCount: decklist.length,
                      separatorBuilder: (context,index){
                        return Divider();
                      },
                      itemBuilder: (BuildContext context, int index)
                      {
                        return Dismissible(
                            key: UniqueKey(),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_){
                            FirebaseDatabase.instance.ref(
                                widget.id + '/' + decklist[index].toString()).remove(
                            ).then((value){decklist.removeAt(index);})
                                .catchError((error){print(2);}) as DatabaseReference;
                            refresh();
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            child: Container(
                              margin: EdgeInsets.only(right: 15),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                                ),
                            ),
                            ),
                          child: ListTile(
                            onTap: (){
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) =>
                                      MyAppCard(title: decklist[index].toString(), id: widget.id)));
                              },

                            title: Container(
                              height: 40,
                              margin: EdgeInsets.only(left: 20, right: 20, top: 5,bottom: 5),
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                        '${decklist[index]}' // make it instant update
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        )
                        );
                      }
                  )
               )
            ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
      onPressed: (){
        showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(
              title: Text('Create New Deck'),
              actions: [
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: TextField(
                    controller: deckController,
                    obscureText: false,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)
                        ),
                        hintText: 'Name',
                    ),
                  ),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      child: Text('Back'),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    ),
                    Spacer(),
                    ElevatedButton(
                      child: Text('Create'),
                      onPressed: () async {
                        DatabaseReference ref = FirebaseDatabase.instance.ref(widget.id);
                        await ref.update(
                          {
                            deckController.text :'',
                          }
                        ).then((value) {
                          print('succesfully create deck');
                          decklist.clear();
                          deckController.text = "";
                          final deckRef = FirebaseDatabase.instance.ref();
                          deckRef.child(widget.id).onChildAdded.forEach((element) {
                            decklist.add(element.snapshot.key);
                            setState((){});
                          });
                        }).catchError((error){
                          print('create deck fail');
                          print(error.toString());
                          decklist.clear();
                          deckController.text = "";
                          final deckRef = FirebaseDatabase.instance.ref();
                          deckRef.child(widget.id).onChildAdded.forEach((element) {
                            decklist.add(element.snapshot.key);
                            setState((){});
                          });
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            )
        );
      },
      tooltip: 'Create New Deck',
      child: const Icon(Icons.add),
    )
    );
  }
}