import 'package:flutter/material.dart';
import '../services/mahasiswa_service.dart'; // ← ubah ini!


class AddMahasiswaPage extends StatefulWidget {
@override
_AddMahasiswaPageState createState() => _AddMahasiswaPageState();
}
class _AddMahasiswaPageState extends State<AddMahasiswaPage> {
TextEditingController nimController = TextEditingController();
TextEditingController namaController = TextEditingController();
TextEditingController jurusanController = TextEditingController();
MahasiswaService mahasiswaService = MahasiswaService();
void addMahasiswa() async {
var result = await mahasiswaService.addMahasiswa(
nimController.text,
namaController.text,
jurusanController.text,
);
if (result) {

Navigator.pop(context);
} else {
ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
Text("Gagal menambahkan mahasiswa")));
}
}
@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: Text("Tambah Mahasiswa")),
body: Padding(
padding: EdgeInsets.all(20),
child: Column(
children: [
TextField(controller: nimController, decoration:
InputDecoration(labelText: "NIM")),
TextField(controller: namaController, decoration:
InputDecoration(labelText: "Nama")),
TextField(controller: jurusanController, decoration:
InputDecoration(labelText: "Jurusan")),
SizedBox(height: 20),
ElevatedButton(onPressed: addMahasiswa, child: Text("Tambah")),
],
),
),
);
}
}