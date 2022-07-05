import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//ignore_for_file: prefer_const_constructors
//ignore_for_file: Avoid `print` calls in production code

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
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
                        'Sign up',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top:20,bottom: 20, left: 30, right: 30),
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
                      margin: EdgeInsets.only(top:5,bottom: 40, left: 30, right: 30),
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
                    SizedBox(
                      width: 250,
                      child: ElevatedButton(
                        child: Text('Sign up'),
                        onPressed: (){
                          print(emailController.text);
                          print(passwordController.text);
                          FirebaseAuth.instance.createUserWithEmailAndPassword(
                              email: emailController.text, password: passwordController.text)
                          .then((value){
                            Navigator.pop(context);
                            print('succesfully sign up');
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  AlertDialog(
                                    title: Text('Sign up successful!'),
                                    actions: [
                                      ElevatedButton(
                                        child: Text('Yeha!'),
                                        onPressed: (){
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                            );

                          }
                          ).catchError((error){
                            print('Failed to sign up');
                            print(error.toString());
                            showDialog(
                                context: context,
                                builder: (context) =>
                                    AlertDialog(
                                      title: Text('Sign up failed.\n' + error.toString()),
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
                        },
                      ),
                    ),
                  ],
                )
            ),
          ],
        )
    );
  }
}