import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MahasiswaService {
  final String baseUrl = "http://localhost:8080/api";

  Future<List<dynamic>> getMahasiswa() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final response = await http.get(
      Uri.parse("$baseUrl/mahasiswa"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      // Pastikan JSON memiliki key "data" yang berisi list mahasiswa
      if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey("data")) {
        return jsonResponse["data"] as List<dynamic>;
      } else {
        throw Exception("Format data tidak sesuai");
      }
    } else {
      throw Exception("Gagal mengambil data mahasiswa");
    }
  }
  // 📌 Fungsi untuk menambahkan mahasiswa
  Future<bool> addMahasiswa(String nim, String nama, String jurusan) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final response = await http.post(
      Uri.parse("$baseUrl/mahasiswa"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "nim": nim,
        "nama": nama,
        "jurusan": jurusan,
      }),
    );

    if (response.statusCode == 201) { // Sesuaikan dengan response dari API
      return true;
    } else {
      print("Error: ${response.body}");
      return false;
    }
}
Future<bool> updateMahasiswa(String id, String nim, String nama, String jurusan) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString("token");

  final response = await http.put(
    Uri.parse("http://localhost:8080/api/mahasiswa/$id"), // Update berdasarkan ID
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    },
    body: jsonEncode({
      "nim": nim,
      "nama": nama,
      "jurusan": jurusan
    }),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}
Future<bool> deleteMahasiswa(String id) async {
SharedPreferences prefs = await SharedPreferences.getInstance();
String? token = prefs.getString("token");

final response = await http.delete(
Uri.parse("$baseUrl/mahasiswa/$id"),
headers: {"Authorization": "Bearer $token"},
);
return response.statusCode == 200;
}
}