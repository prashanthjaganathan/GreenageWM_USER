import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/widgets/home.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/new_report_data.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class NewReport extends StatefulWidget {
  const NewReport({super.key});

  @override
  State<NewReport> createState() => _NewReportState();
}

class _NewReportState extends State<NewReport> {
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  bool _low = false, _normal = false, _high = false;
  final ImagePicker _picker = ImagePicker();
  late File photofile;
  bool clicked = false;
  XFile? _ximageFile;

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text(
          'Report a problem',
          style: TextStyle(color: Colors.black, fontSize: 17),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Report Title',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, top: 2, bottom: 2),
                        child: TextField(
                          controller: _titleController,
                          maxLines: 1,
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text(
                      'Select the priority level',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _low = true;
                                _high = false;
                                _normal = false;
                                priorityLevel = "Low";
                              });
                            },
                            child: Card(
                              color: _low ? Colors.lightGreen.shade200 : null,
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(child: Text('Low')),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _low = false;
                                _high = false;
                                _normal = true;
                                priorityLevel = "Normal";
                              });
                            },
                            child: Card(
                              color:
                                  _normal ? Colors.lightGreen.shade200 : null,
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(child: Text('Normal')),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _low = false;
                                _high = true;
                                _normal = false;
                                priorityLevel = "High";
                              });
                            },
                            child: Card(
                              color: _high ? Colors.lightGreen.shade200 : null,
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(child: Text('High')),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text(
                      'Tag your current location',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: latitude == ""
                            ? null
                            : const Text('Coordinates',
                                style: TextStyle(fontWeight: FontWeight.w500)),
                        subtitle: latitude != ""
                            ? Text('$latitude, $longitude')
                            : null,
                        tileColor: Colors.white,
                        trailing: TextButton(
                          onPressed: () async {
                            try {
                              Position position = await _determinePosition();
                              setState(() {
                                latitude = position.latitude.toString();
                                longitude = position.longitude.toString();
                              });

                              Fluttertoast.showToast(
                                  msg: "Current location tagged successfully",
                                  toastLength: Toast.LENGTH_SHORT,
                                  // gravity: ToastGravity.CEN,
                                  textColor: Colors.white,
                                  backgroundColor:
                                      Colors.black87.withOpacity(0.7),
                                  fontSize: 11.0);
                            } catch (e) {
                              Fluttertoast.showToast(
                                  msg: "Please enable location",
                                  toastLength: Toast.LENGTH_SHORT,
                                  // gravity: ToastGravity.CEN,
                                  textColor: Colors.white,
                                  backgroundColor:
                                      Colors.black87.withOpacity(0.7),
                                  fontSize: 11.0);
                            }
                          },
                          child: const Text('TAG',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    const Text('Take a picture (preferrably landscape)',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        // tileColor: Colors.white,
                        height: MediaQuery.of(context).size.height * 0.25,
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width * 1,
                        child: TextButton(
                          child: !clicked
                              ? const Center(
                                  child: Text(
                                  'OPEN CAMERA',
                                  style: TextStyle(color: Colors.black),
                                ))
                              : Image.file(
                                  File(photofile.path),
                                  width: double.infinity,
                                  // height: MediaQuery.of(context).size.height * 0.3,
                                ),
                          onPressed: () async {
                            _ximageFile = await _picker.pickImage(
                                source: ImageSource.camera);

                            setState(() {
                              clicked = true;
                              photofile = File(_ximageFile!.path);
                              // _ximageFile = photofile as XFile?;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text('Comments',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, top: 2, bottom: 2),
                        child: TextField(
                          controller: _commentController,
                          maxLines: 5,
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: const BorderSide(
                                    width: 1.5, color: Colors.green))),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Center(
                            child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.green),
                        ))),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () async {
                          comments = _commentController.text.toString();
                          if (priorityLevel != "" &&
                              _titleController.text.trim().isNotEmpty &&
                              latitude != "" &&
                              clicked) {
                            Uint8List _imageAsBytes =
                                await _ximageFile!.readAsBytes();
                            String _base64 = base64.encode(_imageAsBytes);

                            Uint8List imageAsBytes =
                                await photofile.readAsBytes();
                            String base64ImageFile =
                                base64.encode(imageAsBytes);
                            // dp = _ximageFile;
                            print(_base64);

                            DateTime today = DateTime.now();
                            String dateStr =
                                "${today.day}-${today.month}-${today.year}";

                            final _updateDb = await conn.query(
                                'INSERT INTO REPORTS(`user_id`, `priority`, `latitude`, `longitude`, `image`,`comment`, `status`, `title`, `date`) VALUES (${obj.getID}, "$priorityLevel", $latitude, $longitude, "$base64ImageFile", "$comments", "Submitted", "${_titleController.text}", CURDATE())');
                            print('Updated ${_updateDb.affectedRows} rows');
                            Fluttertoast.showToast(
                                msg: "Report Submitted Successfully",
                                toastLength: Toast.LENGTH_SHORT,
                                // gravity: ToastGravity.CEN,
                                textColor: Colors.white,
                                backgroundColor:
                                    Colors.black87.withOpacity(0.7),
                                fontSize: 11.0);
                            Navigator.of(context).pop();
                          } else {
                            Fluttertoast.showToast(
                                msg: "Please fill in all the details",
                                toastLength: Toast.LENGTH_SHORT,
                                // gravity: ToastGravity.CEN,
                                textColor: Colors.white,
                                backgroundColor:
                                    Colors.black87.withOpacity(0.7),
                                fontSize: 11.0);
                          }
                        },
                        child: const Center(child: Text('Submit'))),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error("Location services are disabled");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location permissions are permanently denied");
    }

    Position position = await Geolocator.getCurrentPosition();
    return position;
  }
}
