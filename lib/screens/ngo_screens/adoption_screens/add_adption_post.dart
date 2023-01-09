import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:stray_animals_ui/models/ngo_model.dart';

class AddAdoptionPost extends ConsumerStatefulWidget {
  final NGO ngo;
  const AddAdoptionPost({required this.ngo, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddAdoptionPostState();
}

class _AddAdoptionPostState extends ConsumerState<AddAdoptionPost> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _selectedFiles = [];
  List<String> _urls = [];
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  String title = "";
  String description = "";
  @override
  void initState() {
    _descriptionController.addListener(() {
      description = _descriptionController.text;
    });
    _titleController.addListener(() {
      title = _titleController.text;
    });

    super.initState();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  int uploadItem = 0;
  bool _isUploading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Add Adoption Post'),
      ),
      body: SafeArea(
          child: _isUploading
              ? showLoading()
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 20),
                      child: Row(
                        children: [
                          Text("Enter Title",
                              style: GoogleFonts.aldrich(
                                fontSize: 20,
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    buildTextFiled(_titleController, 'Title'),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 20),
                      child: Row(
                        children: [
                          Text("Enter Desciprtion",
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

                            if (title.isEmpty) {
                              cont.showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Title cannot be empty',
                                  ),
                                ),
                              );
                            } else if (description.isEmpty) {
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
                                  content: Text(
                                    'Upload images',
                                  ),
                                ),
                              );
                            } else if (_selectedFiles.isNotEmpty) {
                              await uploadFunction(_selectedFiles);

                              if (await addPost(cont) == true) {
                                cont.showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Adoption posted sucessfully',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ),
                                );
                                navCont.pop();
                              }
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
                                return Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: Image.file(
                                              File(_selectedFiles[index].path),
                                              fit: BoxFit.cover,
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Image.file(
                                      File(_selectedFiles[index].path),
                                      fit: BoxFit.cover,
                                    ),
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
            maxLength: hintText == "Title" ? 20 : 100,
            controller: tXController,
            decoration:
                InputDecoration(border: InputBorder.none, hintText: hintText),
          ),
        ),
      ),
    );
  }

  Widget showLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Uploading : $uploadItem/${_selectedFiles.length}"),
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

  Future<bool> addPost(ScaffoldMessengerState context) async {
    try {
      var response = await http.post(
        Uri.parse("http://localhost:8080/api/ngo/add/adoption"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "id": null,
          "ngoID": widget.ngo.email,
          "title": title,
          "description": description,
          "imageUrls": _urls,
          "status": false,
          "adoptedBy": "",
          "requestList": {},
        }),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        context.showSnackBar(
          const SnackBar(
            content: Text(
              'Something went wrong',
              style: TextStyle(color: Colors.red),
            ),
          ),
        );
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
