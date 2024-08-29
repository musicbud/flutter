import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(8),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(8),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(8),
                  ),
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Theme.of(context).primaryColor),
                ),
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}