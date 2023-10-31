import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'login_page.dart';



class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _eMailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    const Pattern pattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    final RegExp regex = RegExp(pattern.toString());
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    } else if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  void _fullNameListener() {
    print(_fullNameController.text);
  }

  void _emailListener() {
    print(_eMailController.text);
  }

  void _passwordListener() {
    print(_passwordController.text);
  }

  @override
  void initState() {
    // TODO: implement initState
    _fullNameController.addListener(_fullNameListener);
    _eMailController.addListener(_emailListener);
    _passwordController.addListener(_passwordListener);

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _fullNameController.removeListener(_fullNameListener);
    _eMailController.removeListener(_emailListener);
    _passwordController.removeListener(_passwordListener);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 60),
              /*Image.asset(
              'assets/images/logo.png',
              height: 150,
              width: 150,
            ),*/
              const SizedBox(height: 30),
              const Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _fullNameController,
                      decoration: const InputDecoration(
                        hintText: 'Full Name',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: _validateName,
                      onSaved: (value) {
                        _fullNameController.text = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _eMailController,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: _validateEmail,
                      onSaved: (value) {
                        _eMailController.text = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: _validatePassword,
                      onSaved: (value) {
                        _passwordController.text = value!;
                      },
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          var userResult =
                          await firebaseAuth.createUserWithEmailAndPassword(
                              email: _eMailController.text,
                              password: _passwordController.text);
                          _formKey.currentState!.reset();
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                  "Successfully registered, you are being redirected to the login page...")));

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          );
                        }
                      },
                      child: const Text('Sign Up'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Or sign up with',
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () async {
                                final GoogleSignInAccount? googleUser =
                                await GoogleSignIn().signIn();
                                if (googleUser != null) {
                                  final GoogleSignInAuthentication? googleAuth =
                                  await googleUser?.authentication;
                                  final credential =
                                  GoogleAuthProvider.credential(
                                    accessToken: googleAuth?.accessToken,
                                    idToken: googleAuth?.idToken,
                                  );
                                  final UserCredential userCredential =
                                  await firebaseAuth
                                      .signInWithCredential(credential);
                                  final user = userCredential.user;
                                  if (user != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Successfully registered with Google.')));
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const LoginPage()),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Failed to sign up with Google.')));
                                  }
                                }
                              },
                              icon: const Icon(Icons.mail_outline),
                              label: const Text('Google'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding:
                                const EdgeInsets.symmetric(vertical: 15),
                                minimumSize: const Size(150, 50),
                              ),
                            ),
                            const SizedBox(width: 20),
                            ElevatedButton.icon(
                              onPressed: () async {
                                try {
                                  final LoginResult result = await FacebookAuth.instance.login();
                                  if (result.status == LoginStatus.success) {
                                    final OAuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.token);
                                    final UserCredential userCredential = await firebaseAuth.signInWithCredential(credential);
                                    final user = userCredential.user;
                                    if (user != null) {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully registered with Facebook.')));
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const LoginPage()),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to sign up with Facebook.')));
                                    }
                                  }
                                } catch (e) {
                                  print('Error during Facebook login: $e');
                                }
                              },
                              icon: const Icon(Icons.facebook_outlined),
                              label: const Text('Facebook'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blue[700],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding:
                                const EdgeInsets.symmetric(vertical: 15),
                                minimumSize: const Size(150, 50),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Column(
                          children: [
                            Text(
                              'Already have an account?',
                              style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                            );
                          },
                          child: const Text('Log In'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            minimumSize: const Size(double.infinity, 50),
                            side: const BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
