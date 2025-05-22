import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stocks/utils/Routes/routes_path.dart';
import 'package:stocks/utils/styles.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _StocksState();
}

class _StocksState extends State<Loginpage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    if (username == 'riteshpandile' && password == 'Pass@123') {
      context.go(RoutePaths.home);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid username or password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
   //  final screen = MediaQuery.of(context).size;
    return Scaffold(

      appBar: AppBar(title: const Text('Stocks Login')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [



Row(
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
    Padding(padding: 
    EdgeInsets.all(10),
    child:  Text("Stocks", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500, fontSize: 20),),),
  ],
),

      //  const SizedBox(height: 12),

      
                TextField(
                  controller: _usernameController,
                  decoration: AppStyles.inputDecoration(
                    label: "Username",
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: AppStyles.inputDecoration(
                    label: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed:
                          () => setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          }),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

              
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: AppStyles.primaryButtonStyle,
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
