import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserSession {
  static String username = 'User';
  static String email = 'aabbcc@gmail.com';
}

class DatabaseService {
  // Mengambil URL dari .env, default mengarah ke localhost jika tidak ada
  // Jika menggunakan Android Emulator, ganti nilai di .env menjadi http://10.0.2.2:8000
  String get baseUrl {
    return dotenv.env['MODEL_API'] ?? dotenv.env['API_URL'] ?? 'http://127.0.0.1:8000';
  }

  // Fungsi connect() dikosongkan agar tidak perlu mengubah kode di login/register page
  Future<void> connect() async {}

  // Mengembalikan null jika berhasil, atau String berisi pesan error jika gagal
  Future<String?> registerUser(String username, String email, String password) async {
    try {
      final url = Uri.parse('$baseUrl/register');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Registrasi via API berhasil!");
        return null;
      } else {
        return "Status ${response.statusCode} - ${response.body}";
      }
    } catch (e) {
      return "Network Error: $e";
    }
  }

  // Mengembalikan null jika berhasil, atau String berisi pesan error jika gagal
  Future<String?> loginUser(String email, String password) async {
    try {
      final url = Uri.parse('$baseUrl/login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': email,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        print("Login via API berhasil!");
        try {
          final data = jsonDecode(response.body);
          if (data is Map<String, dynamic>) {
            UserSession.username = data['username'] ?? data['user']?['username'] ?? email.split('@')[0];
            UserSession.email = data['email'] ?? data['user']?['email'] ?? email;
          } else {
            UserSession.username = email.split('@')[0];
            UserSession.email = email;
          }
        } catch (_) {
          UserSession.username = email.split('@')[0];
          UserSession.email = email;
        }
        return null;
      } else {
        return "Status ${response.statusCode} - ${response.body}";
      }
    } catch (e) {
      return "Network Error: $e";
    }
  }

  // Fungsi closeConnection() dikosongkan
  Future<void> closeConnection() async {}
}