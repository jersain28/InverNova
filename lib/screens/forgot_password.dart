import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:invernova/screens/signup.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String email = "";
  TextEditingController mailcontroller = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Password Reset Email has been sent !",
            style: TextStyle(fontSize: 20.0),
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "No user found for that email.",
            style: TextStyle(fontSize: 20.0),
          ),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: const Image(
                image: AssetImage('assets/images/InverNovaLogo.jpg'),
              ),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Container(
            alignment: Alignment.topCenter,
            child: const Text(
              "Password Recovery",
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 30.0,
                fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              alignment: Alignment.center,
              child: const Text(
                "Enter your mail",
                style: TextStyle(
                  color: Color(0xFF8c8e98),
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Form(
                  key: _formkey,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 10.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFedf0f8),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Email';
                              }
                              return null;
                            },
                            controller: mailcontroller,
                            style: const TextStyle(color: Color(0xFF8c8e98),),
                            decoration: const InputDecoration(
                              hintText: "Email",
                              hintStyle: TextStyle(
                                fontSize: 18.0,
                                color: Color(0xFF8c8e98),
                              ),
                              prefixIcon: Icon(
                                Icons.mail,
                                color: Color(0xFF8c8e98),
                                size: 30.0,
                              ),
                              border: InputBorder.none),
                            ),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              if(_formkey.currentState!.validate()){
                                setState(() {
                                  email=mailcontroller.text;
                                },
                              );
                              resetPassword();
                            }
                          },
                          child: Container(
                            width: 140,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 28, 129, 47),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Center(
                              child: Text(
                                "Send Email",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account?",
                              style: TextStyle(
                                fontSize: 18.0, color: Color(0xFF8c8e98),
                              ),
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignUp(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Create",
                                style: TextStyle(
                                  color:Color.fromARGB(255, 28, 129, 47),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }
  }
