import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:readify/controllers/logincntrl.dart';
import 'package:readify/view/auth/forgotpassword.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _eMailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String? _validateEmail(String? value) {
    const Pattern pattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    final RegExp regex = RegExp(pattern.toString());
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.emailempty;
    } else if (!regex.hasMatch(value)) {
      return AppLocalizations.of(context)!.emailcorrect;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.passwordempty;
    } else if (value.length < 6) {
      return AppLocalizations.of(context)!.passwordcorrect;
    }
    return null;
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
    _eMailController.addListener(_emailListener);
    _passwordController.addListener(_passwordListener);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _eMailController.removeListener(_emailListener);
    _passwordController.removeListener(_passwordListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 100),
              /*Image.asset(
              'assets/images/logo.png',
              height: 150,
              width: 150,
            ),*/
              const SizedBox(height: 30),
              Text(
                AppLocalizations.of(context)!.login,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _eMailController,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.email,
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
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.password,
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



                          loginControl(context,
                              email: _eMailController.text,
                              password: _passwordController.text);
                        }
                      },
                      child: Text(
                        AppLocalizations.of(context)!.login,
                      ),
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
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgotPasswordScreen()));
                      },
                      child: Text(
                        AppLocalizations.of(context)!.forgot_password,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpPage()));
                      },
                      child: Text(
                        AppLocalizations.of(context)!.signup,
                      ),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
