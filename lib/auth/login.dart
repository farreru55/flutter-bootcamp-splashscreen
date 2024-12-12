import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/buyer/buyer_screen.dart';
import 'package:flutter_application_1/model/auth.dart';
import 'package:flutter_application_1/model/config.dart';
import 'package:flutter_application_1/seller/seller_screen.dart';
import 'package:flutter_application_1/buyer/buyer_screen.dart';
import 'package:flutter_application_1/seller/product/index_screen.dart';
import 'package:flutter_application_1/seller/seller_screen.dart';
import 'register.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final FocusNode _focusNodePassword = FocusNode();
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  Future<void> _login() async {
    // Cek apakah semua field valid
    if (!_formKey.currentState!.validate()) {
      return; // Jika tidak valid, tidak melakukan apa-apa
    }

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('${Config().baseUrl}/login');
    final body = {
      "email": _controllerUsername.text,
      "password": _controllerPassword.text
    };

    try {
      final headers = await Auth.getHeaders();
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      print(response.body);
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final token = data['token'];
        final userId = data['data']['id'];

        await Auth.saveToken(token);
        await Auth.saveUserid(userId);

        // Login berhasil
        if (data['data']['is_seller'] == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SellerScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BuyerScreen()),
          );
        }
      } else {
        // Tampilkan error jika login gagal
        _showErrorDialog("Login failed.");
      }
    } catch (e) {
      _showErrorDialog("Login failed.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fungsi untuk menampilkan dialog error
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const SizedBox(height: 150),
              Text(
                "Welcome back",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 10),
              Text(
                "Login to your account",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 60),
              TextFormField(
                controller: _controllerUsername,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: "Username",
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onEditingComplete: () => _focusNodePassword.requestFocus(),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter username.";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _controllerPassword,
                focusNode: _focusNodePassword,
                obscureText: _obscurePassword,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.password_outlined),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: _obscurePassword
                          ? const Icon(Icons.visibility_outlined)
                          : const Icon(Icons.visibility_off_outlined)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter password.";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 60),
              Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: _login,
                    child: const Text("Login"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          _formKey.currentState?.reset();

                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Register();
                          }));
                        },
                        child: const Text("Register"),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNodePassword.dispose();
    _controllerUsername.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }
}

