import 'package:firebase_core/firebase_core.dart';
import 'package:flashy/home.dart';
import 'package:flutter/material.dart';
//ignore_for_file: prefer_const_constructors
import 'package:flashy/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var id = prefs.getString('id');
  runApp(const MyApp());
  print(id);
  runApp(MaterialApp(home: id == null ? MyApp() : MyAppHome(id: id)));
}

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

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Palette.kToDark,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page l0l'),
      home: const Loginpage(),
    );
  }
}

class Loginpage extends StatefulWidget {
  const Loginpage({Key? key}) : super(key: key);

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var resetController = TextEditingController();
  String id = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
      children: [
        Expanded(
          flex: 40,
          child: Image(
              image:
              AssetImage('assets/Logo.png'
              ),
          ),
        ),
        Expanded(
            flex: 60,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10,bottom: 10),
                  child: Text(
                      'Login',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top:5,bottom: 5, left: 30, right: 30),
                  child: TextField(
                    controller: emailController,
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)
                      ),
                      hintText: 'Email Address',
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top:5,bottom: 20, left: 30, right: 30),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)
                        ),
                        hintText: 'Password',
                    ),
                  ),
                ),
                Container(
                  width: 250,
                  child: ElevatedButton(
                    child: Text('Login'),
                    onPressed: (){
                      print(emailController.text);
                      print(passwordController.text);
                      FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: emailController.text, password: passwordController.text)
                      .then((value) async {
                        print('login successfully');
                        id = value.user!.uid.toString();
                        print(id);
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setString('id', id);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => MyHomePage(title: '', uidd :id, idx:0)));
                      }).catchError((error){
                        print('failed to login');
                        print(error.toString());
                        showDialog(
                          context: context,
                          builder: (context) =>
                              AlertDialog(
                                title: Text('Login failed.\n' + error.toString()),
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
                        );
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top:5,bottom: 20),
                  child:  TextButton(
                      onPressed: (){
                        showDialog(
                          context: context,
                          builder: (context) =>
                              AlertDialog(
                                title: Text('Reset password'),
                                actions: [
                                TextField(
                                controller: resetController,
                                obscureText: false,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30)
                                  ),
                                  hintText: 'Email Address',
                                ),
                              ),
                                  Container(
                                    margin: EdgeInsets.only(top:20),
                                    child: Row(children: [
                                      ElevatedButton(
                                        child: Text('Back'),
                                        onPressed: (){
                                          resetController.text = '';
                                          Navigator.pop(context);
                                        },
                                      ),
                                      Spacer(),
                                      ElevatedButton(
                                        child: Text('Confirm'),
                                        onPressed: (){
                                          FirebaseAuth.instance.sendPasswordResetEmail(email: resetController.text)
                                          .then((value){
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  AlertDialog(
                                                    title: Text('Password reset has been set to your email'),
                                                    actions: [
                                                      ElevatedButton(
                                                        child: Text('Yeha'),
                                                        onPressed: (){
                                                          Navigator.pop(context);
                                                          Navigator.pop(context);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                            );
                                          })
                                          .catchError((error){
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  AlertDialog(
                                                    title: Text(error.toString()),
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
                                          });
                                          resetController.text = '';
                                        },
                                      ),
                                    ],),
                                  )
                                ],
                              ),
                        );
                      },
                      child: Text('Forgot password')
                  )
                ),
                Container(
                  margin: EdgeInsets.only(top:30),
                  child: Text(
                      'Don\'t have an account with us?'
                  ),
                ),
                TextButton(
                    onPressed: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignupPage()));
                    },
                    child: Text('Create an account')
                ),
              ],
            )
        ),
      ],
      )
    );
  }
}
