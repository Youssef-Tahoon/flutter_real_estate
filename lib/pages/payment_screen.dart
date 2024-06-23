import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 5) {
      return oldValue;
    }

    String newText = newValue.text;
    if (newText.length == 2 && !newText.contains('/')) {
      newText += '/';
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class PaymentScreen extends StatelessWidget {
  final String propertyType;
  final String propertyLocation;
  final int propertyPrice;
  final _formKey = GlobalKey<FormState>();

  PaymentScreen({
    required this.propertyType,
    required this.propertyLocation,
    required this.propertyPrice,
  });

  String? validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Card number is required';
    }
    if (value.length != 16) {
      return 'Card number must be 16 digits';
    }
    return null;
  }

  String? validateCardHolderName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Card holder name is required';
    }
    return null;
  }

  String? validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Expiry date is required';
    }
    final RegExp regExp = RegExp(r'^(0[1-9]|1[0-2])\/[0-9]{2}$');
    if (!regExp.hasMatch(value)) {
      return 'Enter a valid date (MM/YY)';
    }
    return null;
  }

  String? validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return 'CVV is required';
    }
    if (value.length != 3) {
      return 'CVV must be 3 digits';
    }
    return null;
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Payment Successful'),
          content: const Text('Your payment has been processed successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // To go back to the previous screen
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Property Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text('Type: $propertyType'),
              Text('Location: $propertyLocation'),
              Text('Price: \$${propertyPrice.toString()}'),
              const SizedBox(height: 20),
              const Text(
                'Payment Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Card Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                ],
                validator: validateCardNumber,
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Card Holder Name',
                  border: OutlineInputBorder(),
                ),
                validator: validateCardHolderName,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Expiry Date (MM/YY)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.datetime,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^[0-9/]*$')),
                        LengthLimitingTextInputFormatter(5),
                        ExpiryDateFormatter(),
                      ],
                      validator: validateExpiryDate,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'CVV',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      validator: validateCVV,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _showConfirmationDialog(context);
                    }
                  },
                  child: const Text('Pay Now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
