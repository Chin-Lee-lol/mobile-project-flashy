
import 'package:firebase_database/firebase_database.dart';
import 'package:flashy/home.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'dart:math';

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
class MyAppTest extends StatelessWidget {
  const MyAppTest({Key? key, required this.title, required this.id, required this.pos, required this.pCount, required this.ans}) : super(key: key);
  final String id;
  final String title;
  final List pos;
  final int pCount;
  final List<bool> ans;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Palette.kToDark,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page l0l'),
      home:  TestPage(title: title, id: id, pos: pos, pCount: pCount, ans:ans),
    );
  }
}

class TestPage extends StatefulWidget {
  const TestPage({Key? key, required this.title, required this.id, required this.pos, required this.pCount, required this.ans}) : super(key: key);

  final String title;
  final String id;
  final List pos;
  final int pCount;
  final List<bool> ans;
  @override
  State<TestPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<TestPage> {
  int count = 0;
  final List<Object?> frontlist = <String?> [];
  final List<Object?> backlist = <String?> [];
  var frontController = TextEditingController();
  var backController = TextEditingController();
  var rng = Random();


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
    List pos = [];
    if (widget.pCount == 0)
      {
      pos = List.generate(frontlist.length, (idx) => idx);
      pos.shuffle();
      }
    else
      {
        pos = widget.pos;
      }
    List<bool> ans = <bool> [];
    if (widget.pCount!= 0)
      {
        ans = widget.ans;
      }
    print(frontlist);
    print(ans);
    print(pos);
    print(widget.pCount);

    if (widget.pCount != frontlist.length) {
      return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) =>
                          MyAppHome(id:widget.id)));
                },
              ),
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Text(widget.title + '\'s Quiz'),
              ),
            ],
          ),

        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 50,
                    child: //Text('${pos[posCount]}')
                    SizedBox(
                      height: 300,
                      child: FlipCard(
                        direction: FlipDirection.HORIZONTAL,
                        flipOnTouch: false,
                        front: Container(
                          color: Colors.white,
                          child: Center(
                            child: Text(
                              '${frontlist[pos[widget.pCount]]}',
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
                                  'lol why are you reading this'
                              ),
                            )
                        ),
                      ),
                    )
                ),
                Expanded(
                  flex: 10,
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text((widget.pCount + 1).toString() + '/' +
                        frontlist.length.toString(),
                      style: TextStyle(
                          fontSize: 40
                      ),),
                  ),),
                Expanded(
                  flex: 35,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 200,
                        child: Transform.scale(
                          scale: 5,
                          child: IconButton(
                            icon: Image.asset('assets/check.png',
                              scale: 10,),
                            onPressed: () {
                              print('right');
                              ans.add(true);
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) =>
                                      MyAppTest(title: widget.title,
                                          id: widget.id,
                                          pos: pos,
                                          pCount: widget.pCount + 1,
                                          ans: ans)));
                            },
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        width: 190,
                        child: Transform.scale(
                          scale: 5,
                          child: IconButton(
                            icon: Image.asset('assets/cross.png',
                              scale: 10,),
                            onPressed: () {
                              print('wrong');
                              ans.add(false);
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) =>
                                      MyAppTest(title: widget.title,
                                          id: widget.id,
                                          pos: pos,
                                          pCount: widget.pCount + 1,
                                          ans: ans)));
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]
          ),
        ),
      );
    }
    else
      {
        int correct = 0;
        List <String> img = [];
        ans.forEach((element) {
          if (element) {
            correct++;
            img.add('assets/check.png');
          }
          else
            {
              img.add('assets/cross.png');
            }
        });
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
                    child: Text('Quiz result'),
                  ),
                ],
              ),

            ),
            body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 30,
                        child: Center(child: Text('${correct.toString()}/${frontlist.length.toString()}',
                        style: TextStyle(
                          fontSize: 100, fontWeight: FontWeight.bold
                        ),))),
                    Expanded(
                        flex: 70,
                        child: ListView.separated(
                            itemCount: frontlist.length,
                            separatorBuilder: (context,index){
                              return Divider();
                            },
                            itemBuilder: (BuildContext context, int index)
                            {
                              return ListTile(
                                onTap: (){
                                  showDialog(
                                      context: context,
                                      builder: (context) =>
                                  SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Dialog(
                                          backgroundColor: Colors.white,
                                          insetPadding: EdgeInsets.only(top:130, bottom: 220, left: 5, right: 5),
                                          child: Container(
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
                                                child: Text(
                                                  '${frontlist[index]}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 25,
                                                  ),
                                                ),
                                              ),
                                              back: Center(
                                                child: Text(
                                                  '${backlist[index]}',
                                                  style: TextStyle(fontSize: 20),
                                                ),
                                              ),
                                            ),
                                          ),
                                  ),
                                          ElevatedButton(
                                              onPressed: (){Navigator.pop(context);},
                                              child: Text('Okey'))
                                        ],
                                      )
                                  )
                                  );
                                },

                                title: Container(
                                  height: 40,
                                  margin: EdgeInsets.only(left: 20, right: 20, top: 5,bottom: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                            '${frontlist[index]}' // make it instant update
                                        ),
                                      ),
                                      Transform.scale(
                                        scale: 0.5,
                                          child: Image(image: AssetImage('${img[index]}'))
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }
                        )
                    )
                   ]
               )
            )
        );
      }
  }
}