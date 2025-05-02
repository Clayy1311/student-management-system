import 'package:flutter/material.dart';
import '../services/mahasiswa_service.dart';

class MahasiswaPage extends StatefulWidget {
@override
_MahasiswaPageState createState() => _MahasiswaPageState();
}
class _MahasiswaPageState extends State<MahasiswaPage> {
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
appBar: AppBar(title: Text("Data Mahasiswa")),
body: mahasiswa.isEmpty
? Center(child: CircularProgressIndicator())
: ListView.builder(
itemCount: mahasiswa.length,
itemBuilder: (context, index) {
return ListTile(
title: Text(mahasiswa[index]["nama"]),
subtitle: Text(mahasiswa[index]["jurusan"]),

);
},
),
);
}

}