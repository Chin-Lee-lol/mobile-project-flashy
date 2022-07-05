
// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'package:firebase_database/firebase_database.dart';
import 'package:flashy/deck.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

import 'home.dart';

//ignore_for_file: prefer_const_constructors
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
class MyAppCard extends StatelessWidget {
  const MyAppCard({Key? key, required this.id, required this.title}) : super(key: key);
  final String id;
  final String title;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Palette.kToDark,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page l0l'),
      home:  CardPage(title: title, id: id),
    );
  }
}


class CardPage extends StatefulWidget {
  const CardPage({Key? key, required this.title, required this.id, }) : super(key: key);
  final String id;
  final String title;

  @override
  State<CardPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CardPage> {
  int count = 0;
  final List<Object?> frontlist = <String?> [];
  final List<Object?> backlist = <String?> [];
  List<String> pos = <String>[];
  var frontController = TextEditingController();
  var backController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    void refresh(bool increase){
        frontlist.clear();
        backlist.clear();
        final deckRef = FirebaseDatabase.instance.ref();
        print('before count ' + count.toString());
        deckRef.child(widget.id +'/' + widget.title).onChildAdded.forEach((element){
          deckRef.child(widget.id +'/' + widget.title + '/' + element.snapshot.key.toString() + '/front').onChildAdded.forEach((element){
            frontlist.add(element.snapshot.key);
          });
          deckRef.child(widget.id +'/' + widget.title + '/' + element.snapshot.key.toString() + '/back').onChildAdded.forEach((element){
            backlist.add(element.snapshot.key);
            if (mounted) {
              setState((){});
            }
          });
          if (increase) {
            count++;
          }
          print('final ' + count.toString());
        });
    }
    if (count == 0) {
      refresh(true);
    }
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: (){
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) =>
                          MyAppHome(id: widget.id)));
                },
              ),
              Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Text(widget.title),
              ),
            ],
          ),
          
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 80,
                    child:ListView.separated(
                        itemCount: frontlist.length,
                        separatorBuilder: (context,index){
                          return Divider();
                        },
                        itemBuilder: (BuildContext context, int index)
                        {
                          return Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.endToStart,
                              onDismissed: (_){
                                count--;
                                print ('index = ' + index.toString());
                                print ('length = ' + frontlist.length.toString());
                                print (frontlist);
                                if (index != frontlist.length-1)
                                  // ignore: curly_braces_in_flow_control_structures
                                  {
                                  for (int i = index; i < frontlist.length - 1; i++)
                                    {
                                      print ('hi i: '+ i.toString());
                                      DatabaseReference ref2 = FirebaseDatabase.instance
                                          .ref('${widget.id}/${widget.title}/' + (i+1).toString() + '/front');
                                      ref2.set(
                                          {
                                            frontlist[i+1].toString() : '',
                                          }
                                      ).then((value){
                                        frontController.text = "";
                                      }).catchError((error){
                                      });
                                      DatabaseReference ref3 = FirebaseDatabase.instance
                                          .ref(widget.id + '/' + widget.title + '/' + (i+1).toString() + '/back');
                                      ref3.set(
                                          {
                                            backlist[i+1].toString() : ''
                                          }
                                      ).then((value){
                                        backController.text = "";
                                      }).catchError((error){
                                      });
                                    }
                                  FirebaseDatabase.instance.ref(
                                      widget.id + '/' + widget.title + '/' + frontlist.length.toString()).remove(
                                  ).then((value){print('delete');refresh(false);});
                                  }
                                else
                                  {
                                    FirebaseDatabase.instance.ref(
                                        widget.id + '/' + widget.title + '/' + frontlist.length.toString()).remove(
                                    ).then((value){print('delete');});
                                    refresh(false);
                                }
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
                              child: SizedBox(
                                width: 400,
                                height: 200,
                                child: ListTile(
                                    onTap: (){
                                    },

                                    title: SizedBox(
                                      height: 400,
                                      child: FlipCard(
                                        direction: FlipDirection.HORIZONTAL,
                                        front: Container(
                                          color: Colors.white,
                                          child: Center(
                                            child: Text(
                                                '${frontlist[index]}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25,
                                              ),
                                            ),
                                          ),
                                        ),
                                        back: Container(
                                         color: Colors.white,
                                            child: Center(
                                              child: Text(
                                                  '${backlist[index]}',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            )
                                        ),
                                      )
                                    ),
                                  ),
                                ),
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
                    SingleChildScrollView(
                      child: Dialog(
                        backgroundColor: Colors.white,
                        insetPadding: EdgeInsets.only(top:130, bottom: 220, left: 5, right: 5),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top:20),
                              child: Text('Create New Card',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          Container(
                            margin: EdgeInsets.only(bottom: 20, top: 20,left: 5,right: 5),
                            height: 250,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10)
                              )
                            ),
                            child: FlipCard(
                              direction: FlipDirection.HORIZONTAL,
                              front:
                                  Center(
                                    child: TextField(
                                      obscureText: false,
                                      controller: frontController,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(30)
                                          ),
                                          hintText: '(Front)',
                                      ),
                                    ),
                                  ),
                              back: Center(
                                child: TextField(
                                  obscureText: false,
                                  controller: backController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30)
                                    ),
                                    hintText: '(Back)',
                                  ),
                                ),
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
                                onPressed: () {
                                  if (frontController.text != '' && backController.text != '') {
                                  count++;
                                  DatabaseReference ref2 = FirebaseDatabase.instance
                                      .ref('${widget.id}/${widget.title}/' + count.toString() + '/front');
                                   ref2.set(
                                      {
                                        frontController.text : '',
                                      }
                                  ).then((value){
                                    print('succesfully create front ' + count.toString());
                                    frontController.text = "";
                                  }).catchError((error){
                                  });
                                  DatabaseReference ref3 = FirebaseDatabase.instance
                                      .ref(widget.id + '/' + widget.title + '/' + count.toString() + '/back');
                                   ref3.set(
                                      {
                                        backController.text : ''
                                      }
                                  ).then((value){
                                    print('succesfully create back '+ count.toString());
                                    backController.text = "";
                                  }).catchError((error){
                                  });
                                  // Navigator.pop(context);
                                  refresh(true);
                                  // Navigator.pushReplacement(context,
                                  //     MaterialPageRoute(builder: (context) =>
                                  //         CardPage(title: widget.title, id: widget.id)));
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => MyAppCard(title: widget.title, id: widget.id)),
                                        (Route<dynamic> route) => false,
                                  );
                                  }
                                  else{
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          AlertDialog(
                                            title: Text('Front or Back cannot be empty!'),
                                            actions: [
                                              ElevatedButton(
                                                child: Text('Aww, okey :('),
                                                onPressed: (){
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          ),
                                    );
                                  }
                                  },
                              ),
                            ],
                          ),
                        ]),
                      ),
                    )
            );
          },
          tooltip: 'Create New Card',
          child: const Icon(Icons.add),
        )
    );
  }
}