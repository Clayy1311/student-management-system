import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'web_mahasiswa_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AuthService authService = AuthService();
  bool isLoading = false;

  // Fungsi login yang akan dipanggil saat tombol ditekan
  void login() async {
    setState(() {
      isLoading = true;
    });

    print("Login button pressed");

    try {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      print("Email: $email, Password: $password");

      // Panggil login service untuk mendapatkan token
      String? token = await authService.login(email, password);

      if (token != null) {
        print("Login sukses! Token: $token");
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomePage()),
          );
        }
      } else {
        print("Login gagal! Token null");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login gagal! Periksa email dan password.")),
        );
      }
    } catch (e) {
      print("Error terjadi: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: ${e.toString()}")),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
              SizedBox(height: 20),
              // Jika isLoading true, tampilkan CircularProgressIndicator, jika tidak tampilkan tombol login
              isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: login,
                      child: Text("Login"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Selamat datang di SIAKAD!"),
            SizedBox(height: 20), // Spasi antara teks dan tombol
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => WebMahasiswaPage()),
                );
              },
              child: Text("Lihat Mahasiswa"),
            ),
          ],
        ),
      ),
    );
  }
}
