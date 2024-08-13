import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'SignUp page.dart';
import 'User_Controller/Auth_Controller.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Consumer<Authentication>(
          builder: (context, auth, child) {
            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 35),
                  child: Text('Log-IN', style: TextStyle(color: Colors.white)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25, left: 90),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 35),
                        child: Image.asset('assets/images/vai.png', width: 180, height: 180),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Container(
                    width: 600,
                    height: 80,
                    child: TextField(
                      controller: auth.emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        suffixIcon: Icon(Icons.email, color: Colors.amber[800]),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 600,
                    height: 80,
                    child: TextField(
                      controller: auth.passwordController,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        suffixIcon: Icon(Icons.lock, color: Colors.amber[800]),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => auth.Login(context),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.amber[800],
                    minimumSize: const Size(400, 60),
                  ),
                  child: const Text(
                    "Log in",
                    style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 220),
                Row(
                  children: [
                    const Expanded(child: Divider(color: Colors.white)),
                    const Text('OR', style: TextStyle(color: Colors.amber)),
                    const Expanded(child: Divider(color: Colors.white)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 100),
                  child: Row(
                    children: [
                      const Text('Don\'t have an account?', style: TextStyle(color: Colors.white)),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignUP()));
                        },
                        child: Text('Sign Up', style: TextStyle(color: Colors.red[900])),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
