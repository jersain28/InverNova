import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:invernova/screens/forgot_password.dart';
import 'package:invernova/screens/home_screen.dart';
import 'package:invernova/screens/signup.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LoginState();
}

class _LoginState extends State<LogIn> {

String email="", password="";

TextEditingController emailcontroller= TextEditingController();
TextEditingController passwordcontroller= TextEditingController();

final _formkey = GlobalKey<FormState>();

userLogin()async{
  try{
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    // ignore: use_build_context_synchronously
    Navigator.push(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }on FirebaseAuthException catch(e){
    if(e.code=='user-not-found'){
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.orangeAccent,
        content: Text(
          'No User Found for that Email',
          style: TextStyle(fontSize: 18.0),
        ),
      ));
    }else if(e.code=='wrong-password'){
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.orangeAccent,
        content: Text(
          'Wrong Password Provided by User',
          style: TextStyle(fontSize: 18.0),
        ),
      ));
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: const Image(image: AssetImage('assets/images/InverNovaLogo.jpg'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFedf0f8),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextFormField(
                      controller: emailcontroller,
                      validator: (value) {
                          if(value==null||value.isEmpty){
                            return 'Please Enter Email';
                          }
                          return null;
                        },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Email",
                        hintStyle: TextStyle(
                          color: Color(0xFFb2b7bf),
                          fontSize: 18.0,
                        ),
                        prefixIcon: Icon(
                          Icons.mail,
                          color: Color(0xFF8c8e98),
                          size: 30.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFedf0f8),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextFormField(
                      controller: passwordcontroller,
                      validator: (value) {
                          if(value==null||value.isEmpty){
                            return 'Please Enter Password';
                          }
                          return null;
                        },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Password",
                        hintStyle: TextStyle(
                          color: Color(0xFFb2b7bf),
                          fontSize: 18.0,
                        ),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Color(0xFF8c8e98),
                          size: 30.0,
                        ),
                      ),
                      obscureText: true,
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  GestureDetector(
                    onTap: (){
                      if(_formkey.currentState!.validate()){
                        setState(() {
                          email= emailcontroller.text;
                          password=passwordcontroller.text;
                        });
                      }
                      userLogin();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(
                        vertical: 13.0,
                        horizontal: 30.0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [
                          Color.fromARGB(255, 3, 210, 9),
                          Color.fromARGB(255, 10, 163, 2),
                          Color.fromARGB(255, 0, 173, 6)
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        ),
                        ),
                        child: const Center(
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w500),
                            ),
                            
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Container(
                alignment: Alignment.center,
                child: GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context)=> const ForgotPassword(),
                    ),
                  );
                },
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: Color(0xFF8c8e98),
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?",
                    style: TextStyle(
                      color: Color(0xFF8c8e98),
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const SignUp(),
                      ),
                    );
                  },
                  child: const Text(
                    "SignUp",
                    style: TextStyle(
                      color: Color.fromARGB(255, 28, 129, 47),
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }
  }