import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class AddEvent extends ConsumerStatefulWidget {
  final String email;
  const AddEvent({required this.email, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddEventState();
}

class _AddEventState extends ConsumerState<AddEvent> {
  final TextEditingController _eventName = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _volunteersCount = TextEditingController();
  int? volunteersCount = 0;
  String eventName = "";
  String description = "";
  String date = "";
  String time = "";
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _selectedFiles = [];
  final List<String> _urls = [];

  int uploadItem = 0;
  bool _isUploading = false;

  @override
  void initState() {
    _eventName.addListener(() {
      eventName = _eventName.text;
    });
    _description.addListener(() {
      description = _description.text;
    });
    _volunteersCount.addListener(() {
      volunteersCount = int.tryParse(_volunteersCount.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    _description.dispose();
    _eventName.dispose();
    _volunteersCount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Add Event",
          style: GoogleFonts.aldrich(letterSpacing: 5),
        ),
      ),
      body: SingleChildScrollView(
        child: _isUploading
            ? showLoading()
            : SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    buildFieldName("Enter Event name"),
                    const SizedBox(
                      height: 20,
                    ),
                    buildTextFiled(_eventName, "Event name"),
                    const SizedBox(
                      height: 20,
                    ),
                    buildFieldName("Enter Description"),
                    const SizedBox(
                      height: 20,
                    ),
                    buildTextFiled(_description, "Description"),
                    const SizedBox(
                      height: 20,
                    ),
                    buildFieldName("Enter Vounteers count"),
                    const SizedBox(
                      height: 20,
                    ),
                    buildTextFiled(_volunteersCount, "Volunteers Count"),
                    const SizedBox(
                      height: 20,
                    ),
                    buildFieldName("Select Event Date"),
                    const SizedBox(
                      height: 20,
                    ),
                    date.isNotEmpty && time.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              "Date: $date Time: $time",
                              style: GoogleFonts.aldrich(
                                fontSize: 18,
                              ),
                            ),
                          )
                        : const Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text("Select Date and Time"),
                          ),
                    buildTimePicker(),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple),
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
                        ElevatedButton(
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
                            } else if (date.isEmpty || time.isEmpty) {
                              cont.showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Time and date cannot be empty',
                                  ),
                                ),
                              );
                            } else if (await addEvent(cont) == true) {
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
                          child: const Text("Add event"),
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
                        ? const Expanded(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
                              child: Text("No images selected"),
                            ),
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
                ),
              ),
      ),
    );
  }

  Widget buildTextFiled(TextEditingController tXController, String hintText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: TextField(
            keyboardType: hintText == "Volunteers Count"
                ? const TextInputType.numberWithOptions(
                    decimal: false,
                  )
                : TextInputType.text,
            controller: tXController,
            maxLength: hintText == "Volunteers Count"
                ? 2
                : hintText == "Event name"
                    ? 20
                    : 60,
            decoration:
                InputDecoration(border: InputBorder.none, hintText: hintText),
          ),
        ),
      ),
    );
  }

  Future<bool> addEvent(ScaffoldMessengerState context) async {
    // var coordinates = await getCoOrdinates();
    // var b = jsonEncode();

    var url = "http://localhost:8080/api/ngo/event/add";
    var client = http.Client();
    try {
      var response = await client.post(Uri.parse(url),
          body: jsonEncode({
            "event": {
              "eventId": DateTime.now().microsecondsSinceEpoch.toString(),
              "description": description,
              "eventName": eventName,
              "date": date,
              "time": time,
              "coordinates": [12.34, 76.678],
              "images": _urls,
              "status": false,
              "volunteersRequiredCount": volunteersCount,
              "volunteers": []
            },
            "ngoEmail": widget.email
          }),
          headers: {'Content-type': 'application/json'});
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

  Widget buildFieldName(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Row(
        children: [
          Text(text, style: GoogleFonts.aldrich(fontSize: 20)),
        ],
      ),
    );
  }

  Widget buildTimePicker() {
    return TextButton(
      onPressed: () {
        DatePicker.showDateTimePicker(
          context,
          showTitleActions: true,
          minTime: DateTime.now(),
          maxTime: DateTime(2023, 6, 7),
          onChanged: (dateTime) {},
          onConfirm: (dateTime) {
            date = "${dateTime.day}-${dateTime.month}-${dateTime.year}";
            time = "${dateTime.hour}:${dateTime.minute}";

            setState(() {});
            log(date.toString());
          },
          currentTime: DateTime.now(),
          locale: LocaleType.en,
        );
      },
      child: const Text(
        'Select Date ',
        style: TextStyle(color: Colors.deepPurple),
      ),
    );
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
  // Widget datePicker() {
  //   return TextButton(
  //     onPressed: () {
  //       DatePicker.showDatePicker(context,
  //           showTitleActions: true,
  //           minTime: DateTime(2018, 3, 5),
  //           maxTime: DateTime(2019, 6, 7),
  //           onChanged: (date) {},
  //           onConfirm: (date) {},
  //           currentTime: DateTime.now(),
  //           locale: LocaleType.en);
  //     },
  //     child: const Text(
  //       'show date time picker (Chinese)',
  //       style: TextStyle(color: Colors.blue),
  //     ),
  //   );
  // }

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
