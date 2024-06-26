import 'package:flutter/material.dart';
import '../pages/resetpassword.dart';
import '../theme/color.dart';

class OtpVerify extends StatefulWidget {
  const OtpVerify({super.key});

  @override
  State<OtpVerify> createState() => _OtpVerifyState();
}

class _OtpVerifyState extends State<OtpVerify> {
  @override
  Widget build(BuildContext context) {
    // OTP TextField
    Widget _buildOtpTextField() {
      return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(right: 20.0),
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: const Color.fromRGBO(235, 237, 237, 1),
        ),
        child: const TextField(
          keyboardType: TextInputType.number,
          maxLength: 1,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Color.fromRGBO(0, 10, 28, 1),
            fontWeight: FontWeight.w700,
            height: 1.40,
          ),
          decoration: InputDecoration(
            counter: Offstage(),
            border: InputBorder.none,
          ),
        ),
      );
    }

// Submit Button
    Widget _buildSubmitButton() {
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
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ResetPassword())),
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
                  "../assets/images/otp.png",
                ),
              ),
              Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Enter OTP",
                          style: TextStyle(
                            color: Color.fromRGBO(25, 43, 77, 1),
                            fontSize: 36.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          "An 4 digit code has been sent to\n+91 8209444644",
                          style: TextStyle(
                            fontSize: 16.5,
                            color: Color.fromRGBO(117, 117, 117, 1),
                            fontWeight: FontWeight.w500,
                            height: 1.40,
                          ),
                        ),
                        SizedBox(height: 40.0),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildOtpTextField(),
                          _buildOtpTextField(),
                          _buildOtpTextField(),
                          _buildOtpTextField(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50.0),
                    _buildSubmitButton()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}