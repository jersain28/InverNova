import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:invernova/screens/alarms.dart';
import 'package:invernova/screens/login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email = "", password = "", name = "";
  TextEditingController namecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController mailcontroller = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  registration() async {
    // ignore: unnecessary_null_comparison
    if (password != null &&
        namecontroller.text != "" &&
        mailcontroller.text != "") {
      try {
        // ignore: unused_local_variable
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          "Registered Successfully",
          style: TextStyle(fontSize: 20.0),
        )));
        // ignore: use_build_context_synchronously
        Navigator.push(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(builder: (context) => const Alarms(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Password Provided is too Weak",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          );
        } else if (e.code == "email-already-in-use") {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Account Already exists",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          );
        }
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 2.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                        color: const Color(0xFFedf0f8),
                        borderRadius: BorderRadius.circular(30)),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Name';
                        }
                        return null;
                      },
                      controller: namecontroller,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Name",
                        hintStyle: TextStyle(
                          color: Color(0xFFb2b7bf),
                          fontSize: 18.0,
                        ),
                        prefixIcon: Icon(
                          Icons.person,
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 2.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                        color: const Color(0xFFedf0f8),
                        borderRadius: BorderRadius.circular(30)),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Email';
                        }
                        return null;
                      },
                      controller: mailcontroller,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Email",
                        hintStyle:
                            TextStyle(color: Color(0xFFb2b7bf), fontSize: 18.0),
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 2.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                        color: const Color(0xFFedf0f8),
                        borderRadius: BorderRadius.circular(30)),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Password';
                        }
                        return null;
                      },
                      controller: passwordcontroller,
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
                    onTap: () {
                      if (_formkey.currentState!.validate()) {
                        setState(() {
                          email = mailcontroller.text;
                          name = namecontroller.text;
                          password = passwordcontroller.text;
                        });
                      }
                      registration();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(
                        vertical: 13.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF273671),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Text(
                          "Sign Up",
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
          /*const SizedBox(
            height: 40.0,
          ),
          const Text(
            "or LogIn with",
            style: TextStyle(
                color: Color(0xFF273671),
                fontSize: 22.0,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 30.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage(
                  'assets/images/google.png',
                ),
              ),

              // Image.asset(
              //   "images/google.png",
              //   height: 45,
              //   width: 45,
              //   fit: BoxFit.cover,
              // ),
              
              const SizedBox(
                width: 30.0,
              ),
              Image.asset(
                "images/apple.png",
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              )
            ],
          ),*/
          const SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already have an account?",
                style: TextStyle(
                  color: Color(0xFF8c8e98),
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  width: 5.0,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LogIn(),
                  ),
                );
              },
              child: const Text(
                "LogIn",
                style: TextStyle(
                  color: Color(0xFF273671),
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
