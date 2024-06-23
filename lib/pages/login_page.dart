import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_real_estate/pages/forgotpassword.dart';
import 'package:flutter_real_estate/pages/home.dart';
import 'package:flutter_real_estate/pages/register_page.dart';
import 'package:flutter_real_estate/pages/root.dart';
import 'package:flutter_real_estate/services/auth_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

final AuthService _authService = AuthService();

class _LoginPageState extends State<LoginPage> {
  late Color myColor;
  late Size mediaSize;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberUser = false;
  bool _passwordVisible = false;

  // final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    myColor = Theme.of(context).primaryColor;
    mediaSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: myColor,
        image: DecorationImage(
          image: const AssetImage("assets/images/bg.png"),
          fit: BoxFit.cover,
          colorFilter:
              ColorFilter.mode(myColor.withOpacity(0.2), BlendMode.dstATop),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Positioned(top: 80, child: _buildTop()),
          Positioned(bottom: 0, child: _buildBottom()),
        ]),
      ),
    );
  }

  Widget _buildTop() {
    return SizedBox(
      width: mediaSize.width,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_on_sharp,
            size: 100,
            color: Colors.white,
          ),
          Text(
            "FIND ME",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 40,
                letterSpacing: 2),
          )
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return SizedBox(
      width: mediaSize.width,
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        )),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome",
          style: TextStyle(
              color: myColor, fontSize: 32, fontWeight: FontWeight.w500),
        ),
        _buildGreyText("Please login with your information"),
        const SizedBox(height: 60),
        _buildGreyText("Email address"),
        _buildInputField(emailController),
        const SizedBox(height: 40),
        _buildGreyText("Password"),
        _buildInputField(passwordController, isPassword: true),
        const SizedBox(height: 20),
        _buildRememberForgot(),
        const SizedBox(height: 20),
        _buildLoginButton(),
        const SizedBox(height: 20),
        _buildOtherLogin(),
      ],
    );
  }

  Widget _buildGreyText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.grey),
    );
  }

  Widget _buildInputField(TextEditingController controller,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !_passwordVisible,
      decoration: InputDecoration(
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _passwordVisible ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              )
            : null,
      ),
    );
  }

  Widget _buildRememberForgot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
                value: rememberUser,
                onChanged: (value) {
                  setState(() {
                    rememberUser = value!;
                  });
                }),
            _buildGreyText("Remember me"),
          ],
        ),
        TextButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ForgotPassword()));
            },
            child: _buildGreyText("Forgot Password?"))
      ],
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () async {
        if (emailController.text.isEmpty || passwordController.text.isEmpty) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: const Text('Both email and password are required.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Closes the AlertDialog
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              });
        } else {
          try {
            UserCredential userCredential = await FirebaseAuth.instance
                .signInWithEmailAndPassword(
                email: emailController.text,
                password: passwordController.text,
            );
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomePage()));
          } on FirebaseAuthException catch (e) {
            String message;
            switch (e.code) {
              case 'user-not-found':
                message = 'No user found for that email.';
                break;
              case 'wrong-password':
                message = 'Wrong password provided.';
                break;
              default:
                message = 'An error occurred. Please try again.';
          }
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Login Failed'),
                    content: const Text('Invalid Email or Password!'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Ok'),
                      )
                    ],
                  );
                });
          }
        }
      },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 20,
        shadowColor:
            myColor, // Ensure myColor is defined in your widget or globally
        minimumSize: const Size.fromHeight(60),
      ),
      child: const Text("LOGIN"),
    );
  }

  Widget _buildOtherLogin() {
    return Center(
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.grey, fontSize: 16),
              children: <TextSpan>[
                TextSpan(text: "New User? "),
                TextSpan(
                  text: "Sign Up",
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RegisterPage()));
                    },
                ),
                const TextSpan(text: "/ Or Login in With;"),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Image.asset("assets/images/facebook.jpg", width: 70),
                onPressed: () {
                  // Implement Facebook login logic
                  debugPrint("Facebook login pressed");
                },
              ),
              IconButton(
                icon: Image.asset("assets/images/twitter.png", width: 90),
                onPressed: () {
                  // Implement Twitter login logic
                  debugPrint("Twitter login pressed");
                },
              ),
              IconButton(
                icon: Image.asset("assets/images/google.png", width: 70),
                onPressed: () async {
                  // Implement Google login logic
                  debugPrint("Google login pressed");
                  User? user = await _authService.signInWithGoogle();
                  if(user != null) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Successful SignUp'),
                            content:  Text('Signed In As ${user.displayName}'),
                          );
                        },
                    );
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
