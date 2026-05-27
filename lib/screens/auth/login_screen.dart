import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  bool _isLoading = false;

  Future<void>
  _handleGoogleLogin() async {

    setState(() {
      _isLoading = true;
    });

    try {
      final authService =
      Provider.of<AuthService>(
        context,
        listen: false,
      );

      final result =
      await authService
          .signInWithGoogle();

      debugPrint(
        "Google login result: $result",
      );

      if (result != null &&
          mounted) {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
            const HomeScreen(),
          ),
        );
      }
    } catch (e) {

      debugPrint(
        "Login error: $e",
      );

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            content: Text(
              "Google Sign-In failed: $e",
            ),
            backgroundColor:
            Colors.red,
          ),
        );
      }
    } finally {

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
      Colors.white,

      body: SafeArea(
        child: Padding(
          padding:
          const EdgeInsets.symmetric(
            horizontal: 24,
          ),

          child: Center(
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,

              children: [

                // Logo
                Container(
                  padding:
                  const EdgeInsets.all(
                    24,
                  ),

                  decoration:
                  BoxDecoration(
                    color: Colors.teal
                        .withOpacity(0.1),
                    shape:
                    BoxShape.circle,
                  ),

                  child: const Icon(
                    Icons.favorite,
                    size: 80,
                    color: Colors.teal,
                  ),
                ),

                const SizedBox(
                    height: 24),

                // App Title
                const Text(
                  'MeCare',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight:
                    FontWeight.bold,
                    color:
                    Colors.teal,
                  ),
                ),

                const SizedBox(
                    height: 8),

                const Text(
                  'Compassionate Mental Healthcare',
                  textAlign:
                  TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color:
                    Colors.grey,
                  ),
                ),

                const SizedBox(
                    height: 80),

                // Google Login Button
                SizedBox(
                  width:
                  double.infinity,
                  height: 58,

                  child:
                  ElevatedButton.icon(
                    onPressed:
                    _isLoading
                        ? null
                        : _handleGoogleLogin,

                    icon: _isLoading
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child:
                      CircularProgressIndicator(
                        strokeWidth:
                        2,
                        color:
                        Colors
                            .white,
                      ),
                    )
                        : const Icon(
                      Icons.login,
                      color:
                      Colors
                          .white,
                    ),

                    label: Text(
                      _isLoading
                          ? 'Signing In...'
                          : 'Continue with Google',
                      style:
                      const TextStyle(
                        color:
                        Colors
                            .white,
                        fontSize: 18,
                        fontWeight:
                        FontWeight
                            .w600,
                      ),
                    ),

                    style:
                    ElevatedButton
                        .styleFrom(
                      backgroundColor:
                      Colors.teal,
                      elevation: 2,

                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                            16),
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                    height: 20),

                Text(
                  "Secure login powered by Google",
                  style: TextStyle(
                    color: Colors
                        .grey.shade500,
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