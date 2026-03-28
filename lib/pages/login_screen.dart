import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_care/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isObscure = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? emailError;
  String? passError;

  void logUserIn() async{
    setState(() {
      emailError = null;
      passError = null;
    });
    final input = emailController.text.trim();
    final password = passwordController.text;

    if(input.isEmpty){
      setState(() {
        emailError = 'Username or email is required';
        return;
      });
    }
    if(password.isEmpty){
      setState(() {
        passError = 'Password is required';
        return;
      });
    }
    showDialog(context: context,barrierDismissible: false, builder: (context){
      return Center(
        child: CircularProgressIndicator(),
      );
    });

    try{
      String email = input;
      if(!input.contains('@')){
        final query = await FirebaseFirestore.instance.collection('users').where('username', isEqualTo: input).limit(1).get();
        if(query.docs.isEmpty){
          if(mounted) Navigator.pop(context);
          setState(() {
            emailError = 'Username not found';
            return;
          });
        }
        email = query.docs.first['email'];
      }
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch(e){
      setState(() {
        switch (e.code){
          case 'user-not-found':
            emailError = 'No user found';
            break;
          case 'invalid-email':
            emailError = 'Invalid email address';
            break;
          case 'wrong-password':
            passError = 'Incorrect password';
            break;
          case 'too-many-requests':
            passError = 'Too many attempts. Try again later';
            break;
          case 'invalid-credential':
            passError = 'Incorrect email or password';
            break;
            default:
              emailError = 'Login failed. Please try again';
              passError = null;
        }
      });
    }
    if(mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    Icon(Icons.lock, size: 100),
                    const SizedBox(height: 10),
                    Text(
                      "Login",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.account_circle_outlined),
                        labelText: "Username or Email",
                        errorText: emailError,
                      ),
                      onChanged: (_){
                        setState(() => emailError = null);
                      },
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: passwordController,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        labelText: "Password",
                        errorText: passError,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      onChanged: (_){
                        setState(() => passError = null);
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text("Forgot Password?"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () {
                  logUserIn();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 70),
                  child: Text(
                    "Sign In",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: 14),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: Text("Register"),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("OR"),
                    ),
                    Expanded(
                      child: Divider(
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/google');
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset('assets/logo/google.png'),
                    ),
                  ),

                  const SizedBox(width: 25),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/apple');
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset('assets/logo/apple.png'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(stream: FirebaseAuth.instance.authStateChanges(), builder: (context, snapshot){
        if(snapshot.hasData){
          return ScreenState();
        }
        else{
          return LoginScreen();
        }
      }),
    );
  }
}


// class GoogleLoginScreen extends StatefulWidget {
//   const GoogleLoginScreen({super.key});
//
//   @override
//   State<GoogleLoginScreen> createState() => _GoogleLoginScreenState();
// }
//
// class _GoogleLoginScreenState extends State<GoogleLoginScreen> {
//   bool _isObscureG = true;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(height: 50),
//               Container(
//                 alignment: Alignment.center,
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 10,
//                   horizontal: 20,
//                 ),
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: 100,
//                       width: 100,
//                       child: Image.asset('assets/logo/google.png'),
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       "Google ID Login",
//                       style: Theme.of(context).textTheme.headlineLarge,
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//                 child: Column(
//                   children: [
//                     TextField(
//                       decoration: InputDecoration(
//                         icon: Image.asset(
//                           'assets/logo/google.png',
//                           height: 25,
//                           width: 25,
//                         ),
//                         labelText: "E-mail",
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//                     TextField(
//                       obscureText: _isObscureG,
//                       decoration: InputDecoration(
//                         icon: Icon(Icons.lock),
//                         labelText: "Password",
//                         suffixIcon: IconButton(
//                           onPressed: () {
//                             setState(() {
//                               _isObscureG = !_isObscureG;
//                             });
//                           },
//                           icon: Icon(
//                             _isObscureG
//                                 ? Icons.visibility
//                                 : Icons.visibility_off,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(right: 20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     TextButton(
//                       onPressed: () {},
//                       child: Text("Forgot Password?"),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 15),
//               FilledButton(
//                 onPressed: () {
//                   Navigator.pushReplacementNamed(context, '/home');
//                 },
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(vertical: 15, horizontal: 70),
//                   child: Text("Sign In"),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Don't have an account?",
//                     style: TextStyle(fontSize: 14),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pushNamed(context, '/signup');
//                     },
//                     child: Text("Register now"),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class AppleLoginScreen extends StatefulWidget {
//   const AppleLoginScreen({super.key});
//
//   @override
//   State<AppleLoginScreen> createState() => _AppleLoginScreenState();
// }
//
// class _AppleLoginScreenState extends State<AppleLoginScreen> {
//   bool _isObscureA = true;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(height: 50),
//               Container(
//                 alignment: Alignment.center,
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 10,
//                   horizontal: 20,
//                 ),
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: 100,
//                       width: 100,
//                       child: Image.asset('assets/logo/apple.png'),
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       "Apple ID Login",
//                       style: Theme.of(context).textTheme.headlineLarge,
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//                 child: Column(
//                   children: [
//                     TextField(
//                       decoration: InputDecoration(
//                         icon: Image.asset(
//                           'assets/logo/apple.png',
//                           width: 25,
//                           height: 25,
//                         ),
//                         labelText: "Apple id",
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//                     TextField(
//                       decoration: InputDecoration(
//                         icon: Icon(Icons.lock),
//                         labelText: "Password",
//                         suffixIcon: IconButton(
//                           onPressed: () {
//                             setState(() {
//                               _isObscureA = !_isObscureA;
//                             });
//                           },
//                           icon: Icon(
//                             _isObscureA
//                                 ? Icons.visibility
//                                 : Icons.visibility_off,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(right: 20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     TextButton(
//                       onPressed: () {},
//                       child: Text("Forgot Password?"),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 15),
//               FilledButton(
//                 onPressed: () {
//                   Navigator.pushReplacementNamed(context, '/home');
//                 },
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(vertical: 15, horizontal: 70),
//                   child: Text("Sign In"),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Don't have an account?",
//                     style: TextStyle(fontSize: 14),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pushNamed(context, '/signup');
//                     },
//                     child: Text("Register now"),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
