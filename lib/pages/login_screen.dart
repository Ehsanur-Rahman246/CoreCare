import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_care/data_provider.dart';
import 'package:core_care/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in_web/web_only.dart' as web;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart';

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
  StreamSubscription? _googleAuthSub;

  void logUserIn() async {
    setState(() {
      emailError = null;
      passError = null;
    });
    final input = emailController.text.trim();
    final password = passwordController.text;

    if (input.isEmpty) {
      setState(() {
        emailError = 'Username or email is required';
      });
      return;
    }
    if (password.isEmpty) {
      setState(() {
        passError = 'Password is required';
      });
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Center(child: CircularProgressIndicator());
      },
    );

    try {
      String email = input;
      if (!input.contains('@')) {
        final query = await FirebaseFirestore.instance
            .collection('users')
            .where('username', isEqualTo: input)
            .limit(1)
            .get();
        if (query.docs.isEmpty) {
          if (mounted) Navigator.pop(context);
          setState(() {
            emailError = 'Username not found';
          });
          return;
        }
        email = query.docs.first['email'];
      }
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && mounted) {
        final dataProvider = Provider.of<DataProvider>(context, listen: false);
        dataProvider.beginSession();
        await dataProvider.fetchUser(user.uid);
        dataProvider.finishSession();
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
      setState(() {
        switch (e.code) {
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
  }

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _googleAuthSub = GoogleSignIn.instance.authenticationEvents.listen((
        event,
      ) async {
        final googleUser = switch (event) {
          GoogleSignInAuthenticationEventSignIn() => event.user,
          _ => null,
        };
        if (googleUser == null) return;
        await _handleGoogleUser(googleUser.id, googleUser.email);
      });
    }
  }

  Future<void> _loginWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn.instance.authenticate();
      await _handleGoogleUser(googleUser.id, googleUser.email);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Google sign-in failed: $e');
    }
  }

  Future<void> _handleGoogleUser(String googleId, String? googleEmail) async {
    _showLoadingDialog();
    try {
      final query = await FirebaseFirestore.instance
          .collection('users')
          .where('googleId', isEqualTo: googleId)
          .limit(1)
          .get();
      if (query.docs.isEmpty) {
        if (mounted) Navigator.of(context, rootNavigator: true).pop();
        Fluttertoast.showToast(msg: 'No account linked to this Google account');
        await GoogleSignIn.instance.signOut();
        return;
      }
      final uid = query.docs.first['uid'] as String;
      await _fetchAndNavigate(uid);
    } catch (e) {
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
      Fluttertoast.showToast(msg: 'Login failed: $e');
    }
  }

  Future<void> _loginWithApple() async {
    _showLoadingDialog();
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email],
      );

      final query = await FirebaseFirestore.instance
          .collection('users')
          .where('appleId', isEqualTo: appleCredential.userIdentifier)
          .limit(1)
          .get();
      if (query.docs.isEmpty) {
        if (mounted) Navigator.of(context, rootNavigator: true).pop();
        Fluttertoast.showToast(msg: 'No account linked to this Apple ID');
        return;
      }

      final uid = query.docs.first['uid'] as String;
      await _fetchAndNavigate(uid);
    } catch (e) {
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
      Fluttertoast.showToast(msg: 'Apple sign-in failed: $e');
    }
  }

  Future<void> _fetchAndNavigate(String uid) async {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    dataProvider.beginSession();
    await dataProvider.fetchUser(uid);
    dataProvider.finishSession();
    if (mounted) {
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void dispose() {
    _googleAuthSub?.cancel();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
                      onChanged: (_) {
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
                      onChanged: (_) {
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
                    onTap: kIsWeb ? null : _loginWithGoogle,
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: kIsWeb
                          ? Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.surface,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.asset('assets/logo/google.png'),
                                ),
                                Opacity(
                                  opacity: 0.005,
                                  child: SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: web.renderButton(
                                      configuration: GSIButtonConfiguration(
                                        size: GSIButtonSize.large,
                                        shape: GSIButtonShape.pill,
                                        minimumWidth: 5000,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container(
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
                  ),

                  const SizedBox(width: 25),
                  GestureDetector(
                    onTap: _loginWithApple,
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
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          final provider = context.watch<DataProvider>();

          if (!provider.sessionRestored ||
              provider.isFetchingUser ||
              provider.currentUser == null) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return ScreenState();
        }
        return LoginScreen();
      },
    );
  }
}

// class ForgotPasswordScreen extends StatefulWidget {
//   final String prefill;
//   final bool mustReset;
//   final VoidCallback? onDone;
//
//   const ForgotPasswordScreen({
//     super.key,
//     required this.prefill,
//     this.mustReset = false,
//     this.onDone,
//   });
//
//   @override
//   State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
// }
//
// class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
//   final _inputController = TextEditingController();
//   String? _inputError;
//   bool _isLoading = false;
//   String? _resolvedUid;
//   String? _resolvedEmail;
//   bool _hasGoogle = false;
//   bool _hasPhone = false;
//   String? _linkedPhone;
//
//   _Step _step = _Step.identify;
//
//   @override
//   void initState() {
//     super.initState();
//     _inputController.text = widget.prefill;
//   }
//
//   @override
//   void dispose() {
//     _inputController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _resolveAccount() async {
//     final input = _inputController.text.trim();
//     if (input.isEmpty) {
//       setState(() => _inputError = 'Enter your username or email');
//       return;
//     }
//
//     setState(() {
//       _isLoading = true;
//       _inputError = null;
//     });
//
//     try {
//       QuerySnapshot<Map<String, dynamic>> snap;
//       if (input.contains('@')) {
//         snap = await FirebaseFirestore.instance
//             .collection('users')
//             .where('email', isEqualTo: input)
//             .limit(1)
//             .get();
//       } else {
//         snap = await FirebaseFirestore.instance
//             .collection('users')
//             .where('username', isEqualTo: input)
//             .limit(1)
//             .get();
//
//         if (snap.docs.isEmpty) {
//           setState(() {
//             _inputError = input.contains('@')
//                 ? 'No account found with that email'
//                 : 'Username not found';
//             _isLoading = false;
//           });
//           return;
//         }
//
//         final data = snap.docs.first.data();
//         _resolvedUid = data['uid'] as String?;
//         _resolvedEmail = data['email'] as String?;
//         _hasGoogle =
//             (data['googleId'] != null &&
//             (data['googleId'] as String).isNotEmpty);
//         _linkedPhone = data['phone'] as String?;
//         _hasPhone = _linkedPhone != null && _linkedPhone!.isNotEmpty;
//
//         setState(() {
//           _step = _Step.chooseMethod;
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _inputError = 'Something went wrong. Try again.';
//         _isLoading = false;
//       });
//     }
//   }
//
//   void _goToVerified() => setState(() => _step = _Step.verified);
//
//   void _navigateHome() {
//     if (!mounted) return;
//     if (widget.onDone != null) {
//       widget.onDone!();
//     } else {
//       Navigator.of(context).pushNamedAndRemoveUntil('/home', (_) => false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Recover your account')),
//       body: AnimatedSwitcher(duration: const Duration(milliseconds: 250), child: _buildStep(),),
//     );
//   }
//
//   Widget _buildStep() {
//     switch (_step) {
//       case _Step.identify:
//         return _IdentifyStep(
//           key: const ValueKey(_Step.identify),
//           controller: _inputController,
//           error: _inputError,
//           isLoading: _isLoading,
//           onNext: _resolveAccount,
//         );
//       case _Step.chooseMethod:
//         return _ChooseMethodStep(
//           email: _resolvedEmail!,
//           hasGoogle: _hasGoogle,
//           hasPhone: _hasPhone,
//           onChosen: (method) {
//             _navigateToMethod(method);
//           },
//         );
//       case _Step.emailOtp:
//         return _EmailOtpStep(
//           key: ValueKey(_Step.emailOtp),
//           email: _resolvedEmail!,
//           uid: _resolvedUid!,
//           onVerified: _goToVerified,
//         );
//       case _Step.googleVerify:
//         return _GoogleVerifyStep(
//           key: ValueKey(_Step.googleVerify),
//           uid: _resolvedUid!,
//           onVerified: _goToVerified,
//         );
//       case _Step.phoneOtp:
//         return _PhoneOtpStep(
//           key: ValueKey(_Step.phoneOtp),
//           phone: _linkedPhone!,
//           onVerified: _goToVerified,
//         );
//       case _Step.verified:
//         return _VerifiedStep(
//           key: ValueKey(_Step.verified),
//           email: _resolvedEmail!,
//           uid: _resolvedUid!,
//           mustReset: widget.mustReset,
//           onSkip: _navigateHome,
//           onNavigateHome: _navigateHome,
//         );
//     }
//   }
//
//   void _navigateToMethod(_Method method) {
//     setState(() {
//       switch (method) {
//         case _Method.email:
//           _step = _Step.emailOtp;
//           break;
//         case _Method.google:
//           _step = _Step.googleVerify;
//           break;
//         case _Method.phone:
//           _step = _Step.phoneOtp;
//           break;
//       }
//     });
//   }
// }
//
// enum _Step {
//   identify,
//   chooseMethod,
//   emailOtp,
//   googleVerify,
//   phoneOtp,
//   verified,
// }
//
// enum _Method { email, google, phone }
//
// class _IdentifyStep extends StatelessWidget {
//   final TextEditingController controller;
//   final String? error;
//   final bool isLoading;
//   final VoidCallback onNext;
//
//   const _IdentifyStep({
//     super.key,
//     required this.controller,
//     required this.error,
//     required this.isLoading,
//     required this.onNext,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final th = Theme.of(context).textTheme;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('Find your account', style: th.headlineSmall),
//         const SizedBox(height: 8),
//         Text(
//           'Enter the username or email linked to your account.',
//           style: th.bodyMedium,
//         ),
//         const SizedBox(height: 25),
//         TextField(
//           controller: controller,
//           decoration: InputDecoration(
//             prefixIcon: Icon(Icons.person_search_rounded),
//             labelText: 'Username or email',
//             errorText: error,
//           ),
//         ),
//         const SizedBox(height: 25),
//         FilledButton(
//           style: FilledButton.styleFrom(minimumSize: Size(double.infinity, 50)),
//           onPressed: isLoading ? null : onNext,
//           child: isLoading
//               ? const SizedBox(
//                   height: 20,
//                   width: 20,
//                   child: CircularProgressIndicator(strokeWidth: 2),
//                 )
//               : const Text('Continue'),
//         ),
//       ],
//     );
//   }
// }
//
// class _ChooseMethodStep extends StatelessWidget {
//   final String email;
//   final bool hasGoogle;
//   final bool hasPhone;
//   final void Function(_Method) onChosen;
//
//   const _ChooseMethodStep({
//     required this.email,
//     required this.hasGoogle,
//     required this.hasPhone,
//     required this.onChosen,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final th = Theme.of(context).textTheme;
//
//     return Column(
//       children: [
//         Text('How do you like to Verify?', style: th.headlineSmall),
//         const SizedBox(height: 8),
//         Text(
//           'Choose a recovery method for your account.',
//           style: th.bodyMedium,
//         ),
//         const SizedBox(height: 25),
//         _MethodTile(
//           icon: Icons.email_outlined,
//           title: 'Email',
//           subtitle: _maskEmail(email),
//           enabled: true,
//           onTap: () => onChosen(_Method.email),
//         ),
//         const SizedBox(height: 12),
//         _MethodTile(
//           icon: Icons.account_circle_outlined,
//           title: 'Google',
//           subtitle: hasGoogle
//               ? 'Use your linked Google account'
//               : 'Not linked to this account',
//           enabled: hasGoogle,
//           onTap: () => onChosen(_Method.google),
//         ),
//         const SizedBox(height: 12),
//         _MethodTile(
//           icon: Icons.phone_outlined,
//           title: 'Phone',
//           subtitle: hasPhone
//               ? 'OTP via your linked number'
//               : 'No phone number linked',
//           enabled: hasPhone,
//           onTap: () => onChosen(_Method.phone),
//         ),
//       ],
//     );
//   }
//
//   String _maskEmail(String email) {
//     final parts = email.split('@');
//     if (parts.length != 2) return email;
//     final name = parts[0];
//     final domain = parts[1];
//     if (name.length <= 2) return '${name[0]}***@$domain';
//     return '${name[0]}${'*' * (name.length - 2)}${name[name.length - 1]}@$domain';
//   }
// }
//
// class _MethodTile extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String subtitle;
//   final bool enabled;
//   final VoidCallback onTap;
//
//   const _MethodTile({
//     required this.icon,
//     required this.title,
//     required this.subtitle,
//     required this.enabled,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final ch = Theme.of(context).colorScheme;
//     return Opacity(
//       opacity: enabled ? 1.0 : 0.4,
//       child: GestureDetector(
//         onTap: enabled ? onTap : null,
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
//           decoration: BoxDecoration(
//             color: ch.surface,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(
//               color: enabled ? ch.primary : ch.outline,
//               width: enabled ? 1 : 0.5,
//             ),
//           ),
//           child: Row(
//             children: [
//               Icon(icon, color: enabled ? ch.primary : ch.onSurface),
//               const SizedBox(width: 15),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                         color: enabled ? ch.primary : ch.onSurface,
//                       ),
//                     ),
//                     const SizedBox(height: 3),
//                     Text(
//                       subtitle,
//                       style: Theme.of(context).textTheme.labelSmall,
//                     ),
//                   ],
//                 ),
//               ),
//               if (enabled) Icon(Icons.chevron_right, color: ch.primary),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _EmailOtpStep extends StatefulWidget {
//   final String email;
//   final String uid;
//   final VoidCallback onVerified;
//
//   const _EmailOtpStep({
//     super.key,
//     required this.email,
//     required this.uid,
//     required this.onVerified,
//   });
//
//   @override
//   State<_EmailOtpStep> createState() => _EmailOtpStepState();
// }
//
// class _EmailOtpStepState extends State<_EmailOtpStep> {
//   final _otpController = TextEditingController();
//   String? _otpError;
//   bool _isSending = false;
//
//   String? _generatedCode;
//
//   @override
//   void initState() {
//     super.initState();
//     _sendCode();
//   }
//
//   @override
//   void dispose() {
//     _otpController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _sendCode() async {
//     setState(() => _isSending = true);
//     await Future.delayed(const Duration(seconds: 1));
//     _generatedCode = (100000 + Random().nextInt(900000)).toString();
//
//     if (mounted) {
//       setState(() {
//         _isSending = false;
//       });
//       _showCodeDialog(_generatedCode!);
//     }
//   }
//
//   void _showCodeDialog(String code) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text('OTP'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text('Your code is'),
//             const SizedBox(height: 12),
//             Text(
//               code,
//               style: Theme.of(
//                 context,
//               ).textTheme.headlineMedium?.copyWith(letterSpacing: 6),
//             ),
//           ],
//         ),
//         actions: [
//           FilledButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Got it'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _verifyCode() {
//     final entered = _otpController.text.trim();
//     if (entered != _generatedCode) {
//       setState(() => _otpError = 'Incorrect code. Try again.');
//       return;
//     }
//     widget.onVerified();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final th = Theme.of(context).textTheme;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('Check your email', style: th.headlineSmall),
//         const SizedBox(height: 8),
//         RichText(
//           text: TextSpan(
//             style: th.bodyMedium,
//             children: [
//               TextSpan(text: 'We sent a 6 digit code to '),
//               TextSpan(
//                 text: widget.email,
//                 style: TextStyle(
//                   color: Theme.of(context).colorScheme.primary,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               TextSpan(text: '.'),
//             ],
//           ),
//         ),
//         const SizedBox(height: 25),
//         if (_isSending)
//           const Center(child: CircularProgressIndicator())
//         else ...[
//           TextField(
//             controller: _otpController,
//             keyboardType: TextInputType.number,
//             inputFormatters: [
//               FilteringTextInputFormatter.digitsOnly,
//               LengthLimitingTextInputFormatter(6),
//             ],
//             decoration: InputDecoration(
//               prefixIcon: Icon(Icons.pin_outlined),
//               labelText: 'Verification code',
//               errorText: _otpError,
//             ),
//             onChanged: (_) {
//               if (_otpError != null) setState(() => _otpError = null);
//             },
//           ),
//           const SizedBox(height: 12),
//           TextButton(
//             onPressed: _isSending ? null : _sendCode,
//             child: Text('Resend code'),
//           ),
//           const SizedBox(height: 12),
//           FilledButton(
//             style: FilledButton.styleFrom(
//               minimumSize: Size(double.infinity, 50),
//             ),
//             onPressed: _verifyCode,
//             child: Text('Verify'),
//           ),
//         ],
//       ],
//     );
//   }
// }
//
// class _GoogleVerifyStep extends StatefulWidget {
//   final String uid;
//   final VoidCallback onVerified;
//
//   const _GoogleVerifyStep({
//     super.key,
//     required this.uid,
//     required this.onVerified,
//   });
//
//   @override
//   State<_GoogleVerifyStep> createState() => _GoogleVerifyStepState();
// }
//
// class _GoogleVerifyStepState extends State<_GoogleVerifyStep> {
//   bool _isLoading = false;
//   String? _error;
//   StreamSubscription? _googleAuthSub;
//
//   Future<void> _handleGoogleUser(String googleId) async {
//     final snap = await FirebaseFirestore.instance
//         .collection('users')
//         .where('googleId', isEqualTo: googleId)
//         .where('uid', isEqualTo: widget.uid)
//         .limit(1)
//         .get();
//
//     if (snap.docs.isEmpty) {
//       await GoogleSignIn.instance.signOut();
//       if (mounted) {
//         setState(() {
//           _error = 'This Google account is not linked to that profile.';
//           _isLoading = false;
//         });
//       }
//       return;
//     }
//     widget.onVerified();
//   }
//
//   Future<void> _signInWithGoogle() async {
//     setState(() {
//       _isLoading = true;
//       _error = null;
//     });
//
//     try {
//       final googleUser = await GoogleSignIn.instance.authenticate();
//       await _handleGoogleUser(googleUser.id);
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _error = 'Google sign-in failed. Try another method';
//           _isLoading = false;
//         });
//       }
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     if (kIsWeb) {
//       _googleAuthSub = GoogleSignIn.instance.authenticationEvents.listen((
//         event,
//       ) async {
//         final googleUser = switch (event) {
//           GoogleSignInAuthenticationEventSignIn() => event.user,
//           _ => null,
//         };
//         if (googleUser == null) return;
//         setState(() => _isLoading = true);
//         await _handleGoogleUser(googleUser.id);
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     _googleAuthSub?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final th = Theme.of(context).textTheme;
//     final ch = Theme.of(context).colorScheme;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('Verify with Google', style: th.headlineSmall),
//         const SizedBox(height: 8),
//         Text(
//           'Sign in with the Google account linked to your profile.',
//           style: th.bodyMedium,
//         ),
//         const SizedBox(height: 25),
//         if (_error != null)
//           Padding(
//             padding: const EdgeInsets.only(bottom: 12),
//             child: Text(
//               _error!,
//               style: TextStyle(color: ch.error, fontSize: 12),
//             ),
//           ),
//         if(_isLoading)
//           const Center(child: CircularProgressIndicator(),)
//         else if (kIsWeb)
//           SizedBox(
//             height: 50,
//             width: double.infinity,
//             child: Stack(
//               children: [
//                 FilledButton(
//                   style: FilledButton.styleFrom(
//                     minimumSize: Size(double.infinity, 50),
//                     backgroundColor: ch.surface,
//                     foregroundColor: ch.onSurface,
//                   ),
//                   onPressed: () {},
//                   child: Text('Continue with Google'),
//                 ),
//                 Opacity(
//                   opacity: 0.005,
//                   child: SizedBox(
//                     height: 50,
//                     width: double.infinity,
//                     child: web.renderButton(
//                       configuration: GSIButtonConfiguration(
//                         size: GSIButtonSize.large,
//                         minimumWidth: 5000,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         else
//           FilledButton.icon(
//             style: FilledButton.styleFrom(
//               minimumSize: Size(double.infinity, 50),
//               backgroundColor: ch.surface,
//               foregroundColor: ch.onSurface,
//             ),
//             onPressed: _signInWithGoogle,
//             icon: Icon(Icons.account_circle_outlined),
//             label: Text('Continue with Google'),
//           ),
//       ],
//     );
//   }
// }
//
// class _PhoneOtpStep extends StatefulWidget {
//   final String phone;
//   final VoidCallback onVerified;
//
//   const _PhoneOtpStep({
//     super.key,
//     required this.phone,
//     required this.onVerified,
//   });
//
//   @override
//   State<_PhoneOtpStep> createState() => _PhoneOtpStepState();
// }
//
// class _PhoneOtpStepState extends State<_PhoneOtpStep> {
//   final _otpController = TextEditingController();
//   String? _otpError;
//   String? _code;
//
//   @override
//   void initState() {
//     super.initState();
//     _sendCode();
//   }
//
//   @override
//   void dispose() {
//     _otpController.dispose();
//     super.dispose();
//   }
//
//   void _sendCode() {
//     _code = (100000 + Random().nextInt(900000)).toString();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!mounted) return;
//       showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//           title: Text('SMS OTP'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Your code is: '),
//               const SizedBox(height: 12),
//               Center(
//                 child: Text(
//                   _code!,
//                   style: Theme.of(
//                     context,
//                   ).textTheme.headlineMedium?.copyWith(letterSpacing: 6),
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             FilledButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('Got it'),
//             ),
//           ],
//         ),
//       );
//     });
//   }
//
//   String _maskPhone(String phone) {
//     if (phone.length <= 4) return phone;
//     return '${phone.substring(0, 3)}${'*' * (phone.length - 6)}${phone.substring(phone.length - 3)}';
//   }
//
//   void _verify() {
//     final entered = _otpController.text.trim();
//     if (entered.isEmpty) {
//       setState(() => _otpError = 'Incorrect code. Try again.');
//       return;
//     }
//     widget.onVerified();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final th = Theme.of(context).textTheme;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('Phone verification', style: th.headlineSmall),
//         const SizedBox(height: 8),
//         Text(
//           'A 6-digit code was sent to ${_maskPhone(widget.phone)}.',
//           style: th.bodyMedium,
//         ),
//         const SizedBox(height: 25),
//         TextField(
//           controller: _otpController,
//           keyboardType: TextInputType.number,
//           inputFormatters: [
//             FilteringTextInputFormatter.digitsOnly,
//             LengthLimitingTextInputFormatter(6),
//           ],
//           decoration: InputDecoration(
//             prefixIcon: Icon(Icons.sms_outlined),
//             labelText: 'Verification code',
//             errorText: _otpError,
//           ),
//           onChanged: (_) {
//             if (_otpError != null) setState(() => _otpError = null);
//           },
//         ),
//         const SizedBox(height: 12),
//         TextButton(onPressed: _sendCode, child: Text('Resend code')),
//         const SizedBox(height: 12),
//         FilledButton(
//           style: FilledButton.styleFrom(minimumSize: Size(double.infinity, 50)),
//           onPressed: _verify,
//           child: Text('Verify'),
//         ),
//       ],
//     );
//   }
// }
//
// class _VerifiedStep extends StatefulWidget {
//   final String email;
//   final String uid;
//   final bool mustReset;
//   final VoidCallback onSkip;
//   final VoidCallback onNavigateHome;
//
//   const _VerifiedStep({
//     super.key,
//     required this.email,
//     required this.uid,
//     required this.mustReset,
//     required this.onSkip,
//     required this.onNavigateHome,
//   });
//
//   @override
//   State<_VerifiedStep> createState() => _VerifiedStepState();
// }
//
// class _VerifiedStepState extends State<_VerifiedStep> {
//   bool _showResetForm = false;
//   bool _resetEmailSent = false;
//   bool _isSending = false;
//   String? _sendError;
//
//   final _newPassController = TextEditingController();
//   final _confirmPassController = TextEditingController();
//   String? _passError;
//   String? _confirmError;
//   bool _obscure1 = true;
//   bool _obscure2 = true;
//
//   Future<void> _sendResetEmail() async {
//     setState(() {
//       _isSending = true;
//     });
//     try {
//       await FirebaseAuth.instance.sendPasswordResetEmail(email: widget.email);
//       setState(() {
//         _resetEmailSent = true;
//         _isSending = false;
//       });
//     } on FirebaseAuthException catch (e) {
//       setState(() {
//         _sendError = e.message ?? 'Failed to send reset email';
//         _isSending = false;
//       });
//     }
//   }
//
//   Future<void> _applyNewPassword() async {
//     final newPass = _newPassController.text;
//     final confirm = _confirmPassController.text;
//     bool isValid = true;
//
//     setState(() {
//       _passError = null;
//       _confirmError = null;
//     });
//     if (newPass.isEmpty) {
//       setState(() => _passError = 'Enter a new password');
//       isValid = false;
//     } else if (newPass.length < 8) {
//       setState(() => _passError = 'At least 8 characters');
//       isValid = false;
//     }
//
//     if (confirm.isEmpty) {
//       setState(() => _confirmError = 'Confirm your password');
//       isValid = false;
//     } else if (confirm != newPass) {
//       setState(() => _confirmError = 'Passwords do not match');
//       isValid = false;
//     }
//     if (!isValid) return;
//     setState(() => _isSending = true);
//
//     try {
//       await Future.delayed(const Duration(milliseconds: 800));
//       if (!mounted) return;
//       await showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//           title: Text('Password updated'),
//           content: Text('Taking you to your dashboard'),
//           actions: [
//             FilledButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//       widget.onNavigateHome();
//     } catch (e) {
//       setState(() {
//         _passError = 'Something went wrong. Try again';
//         _isSending = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final th = Theme.of(context).textTheme;
//     final ch = Theme.of(context).colorScheme;
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(
//               Icons.verified_rounded,
//               color: CustomColors.greenPrimary(context),
//               size: 28,
//             ),
//             const SizedBox(width: 8),
//             Text('Identity verified', style: th.headlineSmall),
//           ],
//         ),
//         const SizedBox(height: 8),
//         Text(
//           widget.mustReset
//               ? 'Identity confirmed. Please reset your password to continue.'
//               : 'You\'re in. Would you like to reset your password?',
//           style: th.bodyMedium,
//         ),
//         const SizedBox(height: 25),
//         if (!_showResetForm) ...[
//           if (!widget.mustReset) ...[
//             OutlinedButton(
//               style: OutlinedButton.styleFrom(
//                 minimumSize: Size(double.infinity, 50),
//               ),
//               onPressed: () async {
//                 final dp = Provider.of<DataProvider>(context, listen: false);
//                 await dp.fetchUser(widget.uid);
//                 widget.onSkip();
//               },
//               child: Text('Skip'),
//             ),
//             const SizedBox(height: 12),
//           ],
//           FilledButton(
//             style: FilledButton.styleFrom(
//               minimumSize: Size(double.infinity, 50),
//             ),
//             onPressed: () => setState(() => _showResetForm = true),
//             child: Text('Reset my password'),
//           ),
//         ] else if (_resetEmailSent) ...[
//           Row(
//             children: [
//               Icon(Icons.mark_email_read_rounded),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Text(
//                   'A reset link was sent to ${widget.email}. '
//                   'Click the link in the email, then come back and sign in.',
//                   style: th.bodySmall,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20,),
//           FilledButton(
//               style: FilledButton.styleFrom(
//                 minimumSize: Size(double.infinity, 50),
//               ),
//               onPressed: widget.onNavigateHome, child: Text('Go to dashboard')),
//         ]else ...[
//           // Reset form — shows two options: send reset email (Firebase)
//           // or set a new password right here (dummy).
//           Text('Choose how to reset', style: th.titleMedium),
//           const SizedBox(height: 16),
//
//           // Option A — Firebase reset email.
//           Text('Option A — Reset via email link', style: th.labelLarge),
//           const SizedBox(height: 8),
//           if (_sendError != null)
//             Padding(
//               padding: const EdgeInsets.only(bottom: 8),
//               child: Text(_sendError!,
//                   style: TextStyle(color: ch.error, fontSize: 12)),
//             ),
//           OutlinedButton.icon(
//             style: OutlinedButton.styleFrom(
//                 minimumSize: const Size(double.infinity, 50)),
//             onPressed: _isSending ? null : _sendResetEmail,
//             icon: _isSending
//                 ? const SizedBox(
//                 height: 18,
//                 width: 18,
//                 child: CircularProgressIndicator(strokeWidth: 2))
//                 : const Icon(Icons.email_outlined),
//             label: const Text('Send reset link to my email'),
//           ),
//           const SizedBox(height: 24),
//
//           // Option B — in-app dummy reset.
//           Text('Option B — Set new password now (demo)',
//               style: th.labelLarge),
//           const SizedBox(height: 8),
//           TextField(
//             controller: _newPassController,
//             obscureText: _obscure1,
//             decoration: InputDecoration(
//               prefixIcon: const Icon(Icons.lock_outline_rounded),
//               labelText: 'New password',
//               helperText: '*At least 8 characters',
//               errorText: _passError,
//               suffixIcon: IconButton(
//                 icon: Icon(_obscure1
//                     ? Icons.visibility_rounded
//                     : Icons.visibility_off_rounded),
//                 onPressed: () => setState(() => _obscure1 = !_obscure1),
//               ),
//             ),
//             onChanged: (_) {
//               if (_passError != null) setState(() => _passError = null);
//             },
//           ),
//           const SizedBox(height: 16),
//           TextField(
//             controller: _confirmPassController,
//             obscureText: _obscure2,
//             decoration: InputDecoration(
//               prefixIcon: const Icon(Icons.lock_clock_outlined),
//               labelText: 'Confirm new password',
//               errorText: _confirmError,
//               suffixIcon: IconButton(
//                 icon: Icon(_obscure2
//                     ? Icons.visibility_rounded
//                     : Icons.visibility_off_rounded),
//                 onPressed: () => setState(() => _obscure2 = !_obscure2),
//               ),
//             ),
//             onChanged: (_) {
//               if (_confirmError != null) setState(() => _confirmError = null);
//             },
//           ),
//           const SizedBox(height: 20),
//           FilledButton(
//             style: FilledButton.styleFrom(
//                 minimumSize: const Size(double.infinity, 50)),
//             onPressed: _isSending ? null : _applyNewPassword,
//             child: _isSending
//                 ? const SizedBox(
//                 height: 22,
//                 width: 22,
//                 child: CircularProgressIndicator(strokeWidth: 2))
//                 : const Text('Update password'),
//           ),
//           const SizedBox(height: 12),
//           TextButton(
//             onPressed: () => setState(() => _showResetForm = false),
//             child: const Text('Go back'),
//           ),
//         ],
//       ],
//     );
//   }
// }
