import 'package:fashion_organiser/controllers/logincontroller.dart';
import 'package:fashion_organiser/signupscreen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  bool isLoading = false;
  var userForm = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF071739),
      body: 
        Form(
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
                  controller: password,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(

                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 50),
                          backgroundColor: const Color(0XFFFEE9CE),
                        ),  
                        onPressed: () async {
                          
                          if(userForm.currentState!.validate()){
                            isLoading = true;
                            setState(() {});
                            // ignore: use_build_context_synchronously
                            await LoginController.login(email: email.text, password: password.text, context: context);
                            isLoading = false;
                            setState(() {});
                          }
                        
                        }, 
                        child: isLoading ? 
                        const CircularProgressIndicator(
                          color: Color(0XFF071739),
                        ) :
                        const Text(
                          "Sign In",
                          style: TextStyle(
                            color: Color(0XFF071739)
                          ),
                        )
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    const Text("Don't have an account?", style: TextStyle(color: Color(0XFFFEE9CE)),),
                    const SizedBox(width: 10,),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const SignupScreen();
                            }
                          )
                        );
                      },
                      child: const Text(
                        "Signup Here !!!",
                        style: TextStyle(
                          color: Color(0XFFA4B5C4),
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    )
                  ],
                ),
            ],
          )        
        ),
      ),
    );
  }
} 