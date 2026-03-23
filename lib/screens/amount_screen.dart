import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/transaction_provider.dart';

class AmountScreen extends StatefulWidget {
  final String name;

  const AmountScreen({super.key, required this.name});

  @override
  State<AmountScreen> createState() => _AmountScreenState();
}

class _AmountScreenState extends State<AmountScreen> {
  String amount = "0";

  void _addNumber(String n) {
    setState(() {
      if (amount == "0") {
        amount = n;
      } else {
        amount += n;
      }
    });
  }

  void _delete() {
    setState(() {
      if (amount.length > 1) {
        amount = amount.substring(0, amount.length - 1);
      } else {
        amount = "0";
      }
    });
  }

  void _handlePayment() {
    if (amount == "0") return; // prevent empty payment

    double enteredAmount = double.parse(amount);

    Provider.of<TransactionProvider>(context, listen: false)
        .addTransaction(widget.name, enteredAmount);

    // Success feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Paid ₹$amount to ${widget.name}")),
    );

    // Go back after payment
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.blue,
        title: Text(widget.name),
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),

          CircleAvatar(
            radius: 30,
            backgroundColor: AppTheme.blue.withValues(alpha: .2),
            child: Text(
              widget.name[0].toUpperCase(),
              style: const TextStyle(fontSize: 20),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            "₹ $amount",
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Spacer(),

          _keypad(),

          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _handlePayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.blue,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Pay"),
            ),
          )
        ],
      ),
    );
  }

  Widget _keypad() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      children: [
        ...["1","2","3","4","5","6","7","8","9","0"].map((e) {
          return _key(e);
        }),
        _key("00"),
        IconButton(
          onPressed: _delete,
          icon: const Icon(Icons.backspace),
        ),
      ],
    );
  }

  Widget _key(String n) {
    return InkWell(
      onTap: () => _addNumber(n),
      child: Center(
        child: Text(
          n,
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}