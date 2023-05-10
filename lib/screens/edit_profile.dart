import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/profile_data.dart';
import 'package:flutter_application_1/widgets/home.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool _passwordVisible = true;
  bool _confirmPasswordVisible = true;
  var _name, _email, _phone;
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();
  XFile? _ximageFile = dp;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    super.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            )),
        //automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.grey.shade50,
        title: const Center(
          child: Text('Edit Profile', style: TextStyle(color: Colors.black)),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                // Updating DP

                if (_name == "" || _email == "" || _phone == "") {
                  Fluttertoast.showToast(
                      msg: "Please fill in the necessary fields",
                      toastLength: Toast.LENGTH_LONG);
                  return;
                }

                {
                  Uint8List _imageAsBytes = await _ximageFile!.readAsBytes();
                  String _base64 = base64.encode(_imageAsBytes);
                  final updateDb = await conn.query(
                      'UPDATE USERS SET `DP` = "$_base64" WHERE `id` = ${obj.getID};');
                  print('Updated ${updateDb.affectedRows} rows');
                  obj.setDp = _base64;
                  // dp = _ximageFile;
                }

                if (_name != name) {
                  name = _name;
                  final updateDb = await conn.query(
                      'UPDATE USERS SET `Full_Name` = "$name" WHERE `id` = ${obj.getID};');
                  print('Updated ${updateDb.affectedRows} rows');
                  obj.setName = name;
                }

                if (_email != emailID) {
                  emailID = _email;
                  final updateDb = await conn.query(
                      'UPDATE USERS SET `Email` = "$emailID" WHERE `id` = ${obj.getID};');
                  print('Updated ${updateDb.affectedRows} rows');
                  obj.setEmail = emailID;
                }

                if (mobile != _phone) {
                  mobile = _phone;
                  final updateDb = await conn.query(
                      'UPDATE USERS SET `Phone` = "$mobile" WHERE `id` = ${obj.getID};');
                  print('Updated ${updateDb.affectedRows} rows');
                  obj.setPhone = mobile;
                }

                if (_newPasswordController.text !=
                    _confirmNewPasswordController.text) {
                  Fluttertoast.showToast(
                      msg: "Passwords don't match",
                      toastLength: Toast.LENGTH_LONG);
                  setState(() {
                    _newPasswordController.clear();
                    _confirmNewPasswordController.clear();
                  });
                  return;
                } else {
                  // print('Updating...');

                  final updateDb = await conn.query(
                      'UPDATE USERS SET `Password` = "${_newPasswordController.text}" WHERE `id` = ${obj.getID};');
                  print('Updated ${updateDb.affectedRows} rows');
                  obj.setPassword = _newPasswordController.text;
                }
                print('Updation done');
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.check,
                color: Colors.green,
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              imageProfile(),

              // SizedBox(
              //   // color: Colors.amberAccent,
              //   height: MediaQuery.of(context).size.height * 0.2,
              //   //width: MediaQuery.of(context).size.width,
              //   child: Padding(
              //     padding: const EdgeInsets.all(20),
              //     child: Center(
              //       child: Container(
              //         height: 120,
              //         width: 120,
              //         decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(120),
              //             color: Colors.black),
              //       ),
              //     ),
              //   ),
              // ),
              const Padding(
                padding: EdgeInsets.only(left: 10, top: 5, bottom: 15),
                child: Text(
                  'Your Information',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  initialValue: name,
                  //controller: _nameController,
                  decoration: const InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: '* Full name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _name = value;
                    print('$_name');
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  initialValue: mobile,
                  keyboardType: TextInputType.number,
                  //controller: _phoneController,
                  decoration: const InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: '* Phone',
                    prefixText: '+91 ',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _phone = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  initialValue: emailID,
                  //controller: _emailController,
                  decoration: const InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: '* Email Id',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _email = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  obscureText: _passwordVisible,
                  controller: _newPasswordController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _passwordVisible
                                ? _passwordVisible = false
                                : _passwordVisible = true;
                          });
                        },
                        icon: _passwordVisible
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility)),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'New password',
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    newPassword = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  //initialValue: ,
                  obscureText: _confirmPasswordVisible,
                  controller: _confirmNewPasswordController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _confirmPasswordVisible
                                ? _confirmPasswordVisible = false
                                : _confirmPasswordVisible = true;
                          });
                        },
                        icon: _confirmPasswordVisible
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility)),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Confirm new password',
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    confirmNewPassword = value;
                  },
                ),
              ),

              // ADD GENDER TOOOO!
            ],
          ),
        ),
      ),
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
          radius: 60.0,
          backgroundImage: _ximageFile == null
              // ? (_imageFile == null
              ? const AssetImage("assets/images/profile.jpeg")
                  as ImageProvider<Object>
              //     : FileImage(File(_imageFile!.path)))
              : FileImage(File(_ximageFile!.path)),
        ),
        Positioned(
          bottom: 40.0,
          right: 45.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet()),
              );
            },
            child: Container(
              //width: 110,
              //color: Colors.black.withOpacity(0.3),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.teal,
                size: 30.0,
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ElevatedButton.icon(
                  icon: const Icon(Icons.camera),
                  onPressed: () {
                    takePhoto(ImageSource.camera);
                  },
                  label: const Text("Camera"),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.image),
                  onPressed: () {
                    takePhoto(ImageSource.gallery);
                  },
                  label: const Text("Gallery"),
                ),
              ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    XFile? pickedFile = await _picker.pickImage(
      source: source,
    );
    Navigator.of(context).pop();

    setState(() {
      _ximageFile = pickedFile!;
      dp = _ximageFile;
    });
  }
}
