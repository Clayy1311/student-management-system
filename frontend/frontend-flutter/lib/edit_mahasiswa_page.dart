import 'package:flutter/material.dart';
import '../services/mahasiswa_service.dart'; // ← ubah ini juga!


class EditMahasiswaPage extends StatefulWidget {
  final int id; // ID mahasiswa dari database
  final String nim;
  final String nama;
  final String jurusan;

  EditMahasiswaPage({
    required this.id,
    required this.nim,
    required this.nama,
    required this.jurusan,
  });

  @override
  _EditMahasiswaPageState createState() => _EditMahasiswaPageState();
}

class _EditMahasiswaPageState extends State<EditMahasiswaPage> {
  TextEditingController nimController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController jurusanController = TextEditingController();
  MahasiswaService mahasiswaService = MahasiswaService();

  @override
  void initState() {
    super.initState();
    nimController.text = widget.nim;
    namaController.text = widget.nama;
    jurusanController.text = widget.jurusan;
  }

  void updateMahasiswa() async {
    if (namaController.text.isEmpty || jurusanController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Nama dan Jurusan tidak boleh kosong")),
      );
      return;
    }

    bool result = await mahasiswaService.updateMahasiswa(
    widget.id.toString(), /// Menggunakan ID untuk update
      nimController.text,
      namaController.text,
      jurusanController.text,
    );

    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Mahasiswa berhasil diperbarui")),
      );
      Navigator.pop(context, true); // Kembali ke halaman sebelumnya dengan refresh
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mengupdate mahasiswa")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Mahasiswa")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: nimController, decoration: InputDecoration(labelText: "NIM")),
            TextField(controller: namaController, decoration: InputDecoration(labelText: "Nama")),
            TextField(controller: jurusanController, decoration: InputDecoration(labelText: "Jurusan")),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateMahasiswa,
              child: Text("Update"),
            ),
          ],
        ),
      ),
    );
  }
}
