import 'package:fashion_organiser/controllers/signupcontroller.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  
  bool isLoading = false;
  var userForm = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF071739),
      appBar: AppBar(
        backgroundColor: const Color(0XFF071739),
        foregroundColor: const Color(0XFFFEE9CE),
      ),
      body: 
        Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: userForm,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 100,
                          width: 100,
                          child: Image(image: AssetImage("assets/logo.png"))
                        ),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: email,
                          // ignore: body_might_complete_normally_nullable
                          validator: (value){
                            if(value==null || value.isEmpty){
                              return "Email is required";
                            }
                          },
                          style: TextStyle(color: Color(0XFFFEE9CE)),
                          decoration: const InputDecoration(label: Text("Email", style: TextStyle(color: Color(0XFFFEE9CE)),)),
                        ),
                        const SizedBox(height: 25),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: password,
                          // ignore: body_might_complete_normally_nullable
                          validator: (value){
                            if(value==null || value.isEmpty){
                              return "Password is required";
                            }
                          },
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          style: TextStyle(color: Color(0XFFFEE9CE)),
                          decoration: const InputDecoration(label: Text("Password", style: TextStyle(color: Color(0XFFFEE9CE)),)),
                        ),
                        const SizedBox(height: 25),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: name,
                          // ignore: body_might_complete_normally_nullable
                          validator: (value){
                            if(value==null || value.isEmpty){
                              return "Name is required";
                            }
                          },
                          style: TextStyle(color: Color(0XFFFEE9CE)),
                          decoration: const InputDecoration(label: Text("Name", style: TextStyle(color: Color(0XFFFEE9CE)),)),
                        ),
                        const SizedBox(height: 25),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(0, 50),
                                  backgroundColor: const Color(0XFFFEE9CE)
                                ), 
                                onPressed: () async {
                              
                                  if(userForm.currentState!.validate()) {
                                    isLoading = true;
                                    setState(() {});
                                    await SignupController.createAccount(email: email.text, password: password.text, name: name.text, context: context);
                                    isLoading = false;
                                    setState(() {});
                                  }
                                }, 
                                child: isLoading ?
                                const CircularProgressIndicator(
                                  color: Color(0XFF071739),
                                )  :
                                const Text(
                                  "Create an account",
                                  style: TextStyle(
                                    color: Color(0XFF071739),
                                  ),
                                )
                                ),
                            ),
                          ],
                        ),
                      ],          
                    ),
                  ),
                ),
              ),
            ),
          ],
        ), 
      );
  }
}