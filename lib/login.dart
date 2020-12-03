import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Enter password',
            ),
          ),
          FlatButton(
            onPressed: () {
              // do something
            },
            child: Text('Reset Password'),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  // do something
                },
                child: Text('Button 1'),
              ),
              ElevatedButton(
                onPressed: () {
                  // do something
                },
                child: Text('Button 2'),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              // do something
            },
            child: Text('Button 3'),
          ),
        ],
      ),
    );
  }
}
