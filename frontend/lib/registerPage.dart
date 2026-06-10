import 'package:flutter/material.dart';
import 'loginPage.dart'; // Diperlukan agar tombol login bisa kembali ke halaman login
import 'databaseAuth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() async {
    setState(() {
      _isLoading = true;
    });

    final db = DatabaseService();
    await db.connect();
    String? errorMsg = await db.registerUser(_usernameController.text, _emailController.text, _passwordController.text);
    await db.closeConnection();

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (errorMsg == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registrasi berhasil! Silakan login.')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: $errorMsg')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1014), // Latar belakang gelap utama
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Efek Glow dan Ikon Shield (Sama seperti halaman Login)
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3C82F6).withOpacity(0.15),
                        blurRadius: 50,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.shield_outlined,
                    color: Color(0xFF3C82F6),
                    size: 56,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 2. Teks Judul
              const Text(
                'CardGuard',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Transaction Security Guard',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 40),

              // 3. Form Inputs
              _buildInputField(label: 'Username', hint: 'user123', obscureText: false, controller: _usernameController),

              const SizedBox(height: 16),

              _buildInputField(label: 'Email', hint: 'aabbcc@gmail.com', obscureText: false, controller: _emailController),
              const SizedBox(height: 16),

              _buildInputField(label: 'Password', hint: '••••••••', obscureText: true, controller: _passwordController),
              const SizedBox(height: 40),

              // 4. Tombol REGISTER
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3C82F6), // Warna tombol biru
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                        )
                      : const Text(
                          'REGISTER',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // 5. Tombol LOGIN
              Center(
                child: TextButton(
                  onPressed: () {
                    // Kembali ke halaman Login ketika ditekan
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  child: const Text(
                    'LOGIN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi pembantu untuk membuat TextField
  Widget _buildInputField({required String label, required String hint, required bool obscureText, TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            filled: true,
            fillColor: const Color(0xFF161E29), // Kotak form gelap
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: const Color(0xFF3C82F6).withOpacity(0.5), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF3C82F6), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}