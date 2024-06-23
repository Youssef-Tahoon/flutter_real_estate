import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../components/otpverify.dart';
import '../theme/color.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    String email = emailController.text.trim();
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text('Password reset link sent to $email'),
          ),
        );
      } on FirebaseAuthException catch (e) {
        print('Error: ${e.code}');
        String errorMessage;
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'No user found with this email.';
            break;
          default:
            errorMessage = 'An unexpected error occurred. ${e.message}';
            break;
        }
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message ?? "An Unknown error Occurred. ${e.message}"),
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Password TextField
    Widget _buildPasswordTextField() {
      return Container(
        margin: const EdgeInsets.only(right: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8.0),
              child: const Icon(
                Icons.alternate_email_sharp,
                color: Color.fromRGBO(59, 107, 175, 1),
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: TextFormField(
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  hintText: "Email ID / Mobile number",
                  hintStyle: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(59, 107, 175, 1),
                    ),
                  ),
                ),
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  // Check for valid email format
                  const emailRegex = r'^[^@]+@[^@]+\.[^@]+';
                  if (!RegExp(emailRegex).hasMatch(value)) {
                    return 'Email address is badly formatted';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      );
    }

    // Submit Button
    Widget _buildSubmitBtn() {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: MaterialButton(
          elevation: 0.0,
          highlightElevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          color: Color.fromRGBO(1, 100, 255, 1),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              passwordReset();
            }
          },
          child: const Text(
            "Submit",
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          margin: const EdgeInsets.only(top: 30, left: 25.0, right: 25.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Color.fromRGBO(98, 108, 130, 1),
                    ),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Image.asset(
                    "../assets/images/forgot-password.png",
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Forgot\nPassword?",
                            style: TextStyle(
                              color: kTextHeadingColor,
                              fontSize: 36.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Text(
                            "Please Enter Your Email.",
                            style: TextStyle(
                              fontSize: 16.5,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 40.0),
                        ],
                      ),
                      _buildPasswordTextField(),
                      const SizedBox(height: 50.0),
                      _buildSubmitBtn()
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
