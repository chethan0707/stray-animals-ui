import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'common_buttons.dart';
import 'constants.dart';
import 'select_photo_options_screen.dart';

class SetPhotoScreen extends StatefulWidget {
  const SetPhotoScreen({super.key, required this.email});
  final String email;
  @override
  State<SetPhotoScreen> createState() => _SetPhotoScreenState();
}

//
class _SetPhotoScreenState extends State<SetPhotoScreen> {
  File? _image;
  String imageURL = "";
  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? img = File(image.path);
      img = await _cropImage(imageFile: img);
      setState(() {
        _image = img;
        Navigator.of(context).pop();
      });
    } on PlatformException catch (e) {
      print(e);
      Navigator.of(context).pop();
    }
  }

  Future<String> uploadImage() async {
    var url = "http://localhost:8080/file/upload";

    // var request = http.MultipartRequest('POST', Uri.parse(url));

    // request.files.add(
    //   http.MultipartFile.fromBytes(
    //     "file",
    //     File(_image!.path).readAsBytesSync(),
    //     contentType: MediaType('image', 'jpeg'),
    //     filename: "widget.email",
    //   ),
    // );

    // return "response.body.toString()";

    String fileName = widget.email;
    Dio dio = Dio();
    if (_image != null) {
      log("file available");

      FormData data = FormData.fromMap(
        {
          "file": await MultipartFile.fromFile(
            _image!.path,
            filename: fileName,
          ),
        },
      );
      try {
        var res = await dio.post(url, data: data);
        if (res.statusCode == 200) {
          return fileName;
        }
      } catch (e) {
        return "";
      }
    } else {
      var im = await dio.get(
          "https://upload.wikimedia.org/wikipedia/en/0/0b/Darth_Vader_in_The_Empire_Strikes_Back.jpg",
          options: Options(responseType: ResponseType.bytes));
      FormData data = FormData.fromMap({
        "file": MultipartFile.fromBytes(
          im.data,
          filename: fileName,
        ),
      });
      try {
        var res = await dio.post(url, data: data);
        log(res.data.toString());
      } catch (e) {
        log(e.toString());
      }
    }
    return "";
  }

  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage =
        await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  void _showSelectPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.28,
          maxChildSize: 0.4,
          minChildSize: 0.28,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: SelectPhotoOptionsScreen(
                onTap: _pickImage,
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, bottom: 30, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Set a photo of yourself',
                        style: kHeadTextStyle,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: Center(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      _showSelectPhotoOptions(context);
                    },
                    child: Center(
                      child: Container(
                          height: 200.0,
                          width: 200.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade200,
                          ),
                          child: Center(
                            child: _image == null
                                ? const Text(
                                    'No image selected',
                                    style: TextStyle(fontSize: 20),
                                  )
                                : CircleAvatar(
                                    backgroundImage: FileImage(_image!),
                                    radius: 200.0,
                                  ),
                          )),
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InkWell(
                    onTap: () async {
                      var navCon = Navigator.pop(context, true);
                      var scaf = ScaffoldMessenger.of(context);
                      var str = await uploadImage();
                      if (str.isEmpty) {
                        scaf.showSnackBar(const SnackBar(
                            content: Text("Something went wrong!!!")));
                      } else {
                        scaf.showSnackBar(const SnackBar(
                            content:
                                Text("Profile photo updated successfully!!!")));
                        Future.delayed(const Duration(seconds: 1));
                        navCon;
                      }
                    },
                    child: const Text(
                      'Save',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CommonButtons(
                    onTap: () => _showSelectPhotoOptions(context),
                    backgroundColor: Colors.deepPurple,
                    textColor: Colors.white,
                    textLabel: 'Add a Photo',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
