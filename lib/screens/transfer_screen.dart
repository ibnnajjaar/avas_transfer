import 'package:avas_transfer/components/transfer_card.dart';
import 'package:flutter/material.dart';

class TransferScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Opacity(
            opacity: 0.012,
            child: SizedBox(
              width: 500,
              child: Image.asset('assets/logo.png'),
            ),
          ),
          TransferCard(),
        ],
      ),
    );
  }
}
