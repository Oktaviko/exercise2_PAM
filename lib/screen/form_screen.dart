import 'dart:io';

import 'package:exercise2/controller/kuliner_controller.dart';
import 'package:exercise2/model/kuliner.dart';
import 'package:exercise2/screen/home_screen.dart';
import 'package:exercise2/screen/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FormKuliner extends StatefulWidget {
  const FormKuliner({super.key});

  @override
  State<FormKuliner> createState() => _FormKulinerState();
}

class _FormKulinerState extends State<FormKuliner> {
  File? _image;
  final _imagePicker = ImagePicker();
  String? _alamat;

  final _formkey = GlobalKey<FormState>();
  final _namatempatController = TextEditingController();
  final _hargaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _noTeleponController = TextEditingController();

  final KulinerController _kulinerController = KulinerController();
  Future<void> getImage() async {
    final XFile? pickerFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    setState(
      () {
        if (pickerFile != null) {
          _image = File(pickerFile.path);
        } else {
          print("No image selected");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Kuliner Recommended"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 200, 210, 214),
      ),
      body: Form(
        key: _formkey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Nama Tempat Kuliner",
                    hintText: "Masukkan Tempat Kuliner",
                    border: OutlineInputBorder(),
                  ),
                  controller: _namatempatController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Input tidak boleh kosong";
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Kisaran Harga",
                    hintText: "Masukkan Kisaran Harga",
                    border: OutlineInputBorder(),
                  ),
                  controller: _hargaController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Input tidak boleh kosong";
                    }
                    return null;
                  },
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Alamat"),
                    ),
                    _alamat == null
                        ? const SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Alamat kosong'),
                            ))
                        : Text('$_alamat'),
                    _alamat == null
                        ? TextButton(
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MapScreen(
                                      onLocationSelected: (selectedAddress) {
                                    setState(() {
                                      _alamat = selectedAddress;
                                    });
                                  }),
                                ),
                              );
                            },
                            child: const Text('Pilih Alamat'),
                          )
                        : TextButton(
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MapScreen(
                                      onLocationSelected: (selectedAddress) {
                                    setState(() {
                                      _alamat = selectedAddress;
                                    });
                                  }),
                                ),
                              );
                              setState(() {});
                            },
                            child: const Text('Ubah Alamat'),
                          )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "No Telepon Kuliner",
                    hintText: "Masukkan No Telepon Kuliner",
                    border: OutlineInputBorder(),
                  ),
                  controller: _noTeleponController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Masukkan nomor telepon dengan benar";
                    } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return "Hanya boleh memasukkan angka";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              _image == null
                  ? const Text("Tidak ada data yang dipilih")
                  : Image.file(_image!),
                  const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  getImage();
                },
                child: const Text("Pilih Gambar"),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      _formkey.currentState!.save();
                      //Proses simpan data
                      Kuliner _kuliner = Kuliner(
                        namatempatkuliner: _namatempatController.text,
                        kisaranharga: _hargaController.text,
                        alamat: _alamat ?? '',
                        telepon: _noTeleponController.text,
                        foto: _image!.path,
                      );
                      var result =
                          await _kulinerController.addKuliner(_kuliner, _image);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(result['message']),
                        ),
                      );
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                        (route) => false,
                      );
                    }
                  },
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
