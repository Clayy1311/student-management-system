import 'package:flutter/material.dart';
import 'services/mahasiswa_service.dart';
import 'edit_mahasiswa_page.dart';
import 'add_mahasiswa_page.dart'; // Import the AddMahasiswaPage

class WebMahasiswaPage extends StatefulWidget {
  @override
  _WebMahasiswaPageState createState() => _WebMahasiswaPageState();
}

class _WebMahasiswaPageState extends State<WebMahasiswaPage> {
  MahasiswaService mahasiswaService = MahasiswaService();
  List mahasiswa = [];

  @override
  void initState() {
    super.initState();
    fetchMahasiswa();
  }

  void fetchMahasiswa() async {
    var data = await mahasiswaService.getMahasiswa();
    setState(() {
      mahasiswa = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Data Mahasiswa - Web")),
      body: mahasiswa.isEmpty
          ? Center(child: CircularProgressIndicator())
          : DataTable(
              columns: [
                DataColumn(label: Text("NIM")),
                DataColumn(label: Text("Nama")),
                DataColumn(label: Text("Jurusan")),
                DataColumn(label: Text("Aksi")),
              ],
              rows: mahasiswa.map((item) {
                return DataRow(cells: [
                  DataCell(Text(item["nim"])),
                  DataCell(Text(item["nama"])),
                  DataCell(Text(item["jurusan"])),
                  DataCell(
                    Row(
                      children: [
                        // Tombol Edit
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () async {
                            bool? isUpdated = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditMahasiswaPage(
                                  id: int.parse(item["id"].toString()),
                                  nim: item["nim"],
                                  nama: item["nama"],
                                  jurusan: item["jurusan"],
                                ),
                              ),
                            );

                            if (isUpdated == true) {
                              fetchMahasiswa(); // Refresh data setelah update
                            }
                          },
                        ),

                        // Tombol Hapus
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            bool confirmDelete = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Konfirmasi"),
                                  content: Text("Yakin ingin menghapus mahasiswa ini?"),
                                  actions: [
                                    TextButton(
                                      child: Text("Batal"),
                                      onPressed: () => Navigator.of(context).pop(false),
                                    ),
                                    TextButton(
                                      child: Text("Hapus"),
                                      onPressed: () => Navigator.of(context).pop(true),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirmDelete == true) {
                              bool result = await mahasiswaService
                                  .deleteMahasiswa(item["id"].toString());

                              if (result) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Mahasiswa berhasil dihapus")),
                                );
                                fetchMahasiswa(); // Refresh daftar mahasiswa setelah hapus
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Gagal menghapus mahasiswa")),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ]);
              }).toList(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? isAdded = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMahasiswaPage()), // Navigate to AddMahasiswaPage
          );

          if (isAdded == true) {
            fetchMahasiswa(); // Refresh data after adding
          }
        },
        child: Icon(Icons.add),
        tooltip: "Add Mahasiswa",
      ),
    );
  }
}
