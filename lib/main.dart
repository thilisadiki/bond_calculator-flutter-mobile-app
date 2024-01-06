import 'package:flutter/material.dart';
import 'dart:math';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mortgage Calculator Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class ShareButtons extends StatelessWidget {
  final String url;
  final String title;
  final String description;

  const ShareButtons({super.key, required this.url, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () => Share.share('$title\n$url\n$description'),
          child: const Text('Share'),
        ),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  TextEditingController principalController = TextEditingController();
  TextEditingController interestController = TextEditingController();
  TextEditingController yearsController = TextEditingController();
  double monthlyPayment = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mortgage / Bond Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(FontAwesomeIcons.house, size: 50),
            const SizedBox(height: 20),
            const Text(
              'Mortgage / Bond Calculator',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: principalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Loan Amount'),
            ),
            TextFormField(
              controller: interestController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Interest Rate (%)'),
            ),
            TextFormField(
              controller: yearsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Loan Term (Years)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                calculateMortgage();
              },
              child: const Text('Calculate'),
            ),
            const SizedBox(height: 20),
            Text(
              'Monthly Payment: \R${monthlyPayment.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            const ShareButtons(
              url: 'https://example.com',
              title: 'Check out this awesome mortgage calculator!',
              description: 'Calculate your mortgage or bond with this simple and effective calculator.',
            ),
          ],
        ),
      ),
    );
  }

  void calculateMortgage() {
    double principal = double.tryParse(principalController.text) ?? 0.0;
    double interest = double.tryParse(interestController.text) ?? 0.0;
    double years = double.tryParse(yearsController.text) ?? 0.0;

    if (principal > 0 && interest > 0 && years > 0) {
      double monthlyInterest = interest / 100 / 12;
      double numberOfPayments = years * 12;

      double numerator = monthlyInterest * pow(1 + monthlyInterest, numberOfPayments);
      double denominator = pow(1 + monthlyInterest, numberOfPayments) - 1;

      monthlyPayment = principal * (numerator / denominator);
    } else {
      // Reset monthly payment if any input is invalid
      monthlyPayment = 0.0;
    }

    setState(() {});
  }
}
