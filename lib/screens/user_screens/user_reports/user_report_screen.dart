import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class UserReportScreen extends ConsumerStatefulWidget {
  final String userEmail;
  final String ngoEmail;
  const UserReportScreen(
      {required this.userEmail, required this.ngoEmail, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserReportScreenState();
}

class _UserReportScreenState extends ConsumerState<UserReportScreen> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _selectedFiles = [];
  List<String> _urls = [];
  final TextEditingController _descriptionController = TextEditingController();
  String description = "";
  int uploadItem = 0;
  bool _isUploading = false;
  @override
  void initState() {
    _descriptionController.addListener(() {
      description = _descriptionController.text;
    });
    super.initState();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        title: Text(
          ' Report case',
          style: GoogleFonts.aldrich(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.grey[300],
      body: SafeArea(
          child: _isUploading
              ? showLoading()
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 20),
                    child: Row(
                      children: [
                        Text("Enter Description",
                            style: GoogleFonts.aldrich(
                              fontSize: 20,
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  buildTextFiled(_descriptionController, 'Description'),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple.shade400),
                    onPressed: () async {
                      await selectImage();
                      setState(() {});
                    },
                    icon: const Icon(Icons.image_outlined),
                    label: const Text("Select images"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple.shade400),
                        onPressed: () async {
                          var cont = ScaffoldMessenger.of(context);
                          var navCont = Navigator.of(context);
                          if (_selectedFiles.isNotEmpty) {
                            await uploadFunction(_selectedFiles);
                          }
                          if (description.isEmpty) {
                            cont.showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Description cannot be empty',
                                ),
                              ),
                            );
                          } else if (_selectedFiles.isEmpty) {
                            cont.showSnackBar(
                              const SnackBar(
                                content: Text('Upload images'),
                              ),
                            );
                          } else if (await registerCase(cont) == true) {
                            cont.showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Case reported sucessfully',
                                  style: TextStyle(color: Colors.green),
                                ),
                              ),
                            );
                            navCont.pop();
                          }
                        },
                        icon: const Icon(Icons.image_outlined),
                        label: const Text("Upload"),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade400),
                        onPressed: () {
                          _selectedFiles.clear();
                          setState(() {});
                        },
                        icon: const Icon(Icons.delete),
                        label: const Text("Clear"),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _selectedFiles.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
                          child: Text("No images selected"),
                        )
                      : Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                            itemCount: _selectedFiles.length,
                            itemBuilder: (BuildContext context, int index) {
                              log(_selectedFiles.length.toString());
                              return Padding(
                                padding: const EdgeInsets.all(5),
                                child: Image.file(
                                  File(_selectedFiles[index].path),
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        ),
                ],
              )),
    );
  }

  Widget buildTextFiled(TextEditingController tXController, String hintText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: TextField(
            maxLength: 100,
            controller: tXController,
            decoration:
                InputDecoration(border: InputBorder.none, hintText: hintText),
          ),
        ),
      ),
    );
  }

  Future<void> selectImage() async {
    if (_selectedFiles != null) {
      _selectedFiles.clear();
    }
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        _selectedFiles.addAll(images);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<double>> getCoOrdinates() async {
    LocationPermission permission = await Geolocator.checkPermission();
    List<double> coordinates = [];
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      await Geolocator.requestPermission();
    } else {
      Position currentPosition = await Geolocator.getCurrentPosition();
      coordinates.add(currentPosition.latitude);
      coordinates.add(currentPosition.longitude);
    }
    return coordinates;
  }

  Future<bool> registerCase(ScaffoldMessengerState context) async {
    var coordinates = await getCoOrdinates();
    var b = jsonEncode({
      "description": description,
      "caseId": DateTime.now().microsecondsSinceEpoch.toString(),
      "userId": widget.userEmail,
      "ngoId": widget.ngoEmail,
      "coordinates": coordinates,
      "status": false,
      "urls": _urls,
      "volunteer": "",
    });
    var url = "http://localhost:8080/api/user/report";
    var client = http.Client();
    try {
      var response = await client.post(Uri.parse(url),
          body: b, headers: {'Content-type': 'application/json'});
      if (response.statusCode == 200) {
        return true;
      } else {
        context.showSnackBar(
          SnackBar(
            content: Text(
              response.body.toString(),
            ),
          ),
        );
        return false;
      }
    } catch (e) {
      context.showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
      log(e.toString());
      return false;
    }
  }

  Widget showLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ignore: prefer_interpolation_to_compose_strings
          Text("Uploading : " +
              uploadItem.toString() +
              "/" +
              _selectedFiles.length.toString()),
          const SizedBox(
            height: 30,
          ),
          const CircularProgressIndicator(color: Colors.deepPurple),
        ],
      ),
    );
  }

  Future<void> uploadFunction(List<XFile> images) async {
    setState(() {
      _isUploading = true;
    });

    for (int i = 0; i < images.length; i++) {
      var url = await uploadFile(images[i]);
      if (url.isNotEmpty) {
        _urls.add(url);
      }
    }
  }

  Future<String> uploadFile(XFile image) async {
    var url = "http://localhost:8080/file/upload";
    Dio dio = Dio();
    FormData data = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        image.path,
        filename: DateTime.now().microsecondsSinceEpoch.toString(),
      ),
    });
    try {
      var res = await dio.post(url, data: data);
      if (res.statusCode == 200) {
        setState(() {
          uploadItem++;
          if (uploadItem == _selectedFiles.length) {
            _isUploading = false;
            uploadItem = 0;
          }
        });
      }
      return res.data.toString();
    } catch (e) {
      log(e.toString());
      return "";
    }
  }
}
