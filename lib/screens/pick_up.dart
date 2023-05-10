import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/pickup_order.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:intl/intl.dart';

import '../widgets/home.dart';

class PickUp extends StatefulWidget {
  const PickUp({super.key});

  @override
  State<PickUp> createState() => _PickUpState();
}

class _PickUpState extends State<PickUp> {
  TextEditingController timeinput = TextEditingController();
  TextEditingController tipTextFieldController = TextEditingController();
  bool _small = false, _medium = false, _large = false;
  late GoogleMapController googleMapController;
  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(13.0159044, 77.63786189999996));

  showAlertDialogForTip(BuildContext context) async {
    Widget okButton = TextButton(
      child: Text(
        "OK",
        style: TextStyle(color: Colors.green.shade700),
      ),
      onPressed: () {
        //print(tipTextFieldController.text);
        Navigator.of(context).pop(tipTextFieldController.text);
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text(
        "Enter Tip Amount",
        style: TextStyle(fontSize: 15),
      ),
      content: TextField(
        decoration: const InputDecoration(
          hintText: "0.00",
        ),
        keyboardType: TextInputType.number,
        controller: tipTextFieldController,
      ),
      actions: [
        okButton,
      ],
    );

    String tips = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

    double tipd = double.parse(tips);

    setState(() {
      tipAmount = tipd;
      taxAmount = (pickupFee + tipAmount) * gstRate;
      totalBillAmount = tipAmount + pickupFee + taxAmount;
    });
  }

  void getData() async {
    // var _conn = await MySqlConnection.connect(
    //   ConnectionSettings(
    //     host: '34.93.37.194',
    //     port: 3306,
    //     user: 'root',
    //     password: 'root',
    //     db: 'greenage',
    //   )),
  }

  @override
  void initState() {
    super.initState();
    timeinput.text = "";
    Future.delayed(Duration.zero, () async {
      Position position = await _determinePosition();
      // print(position.latitude.toString());
      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 15)));
    });

    getData();
  }

  @override
  void dispose() {
    tipTextFieldController.dispose();
    //razorpay.clear();
    super.dispose();
  }

  completePaymemt() async {
    Razorpay razorpay = Razorpay();
    var options = {
      'key': 'rzp_test_ToSi2ssJEeoxol',
      'amount': (totalBillAmount * 100).toStringAsFixed(2),
      'name': 'Greenage Waste Management',
      'description': 'Waste Pickup - $disposalSize',
      'currency': 'INR',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {
        'contact': '9606206566',
        'email': 'prashanth.is19@bmsce.ac.in'
      },
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      final updateDb = await conn.query(
          'INSERT INTO PICKUPS(`user_id`, `disposal_size`, `tip`, `address_name`, `address`, `total_bill`, `points_earned`) VALUES (${obj.getID}, "$disposalSize",  $tipAmount, "$pickupAddressName", "$pickupAddress", $totalBillAmount, $pointsEarned)');
      //  print('Updated ${updateDb.affectedRows} rows');
      razorpay.open(options);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error with pay');
      debugPrint("Error ${e.toString()}");
    }

    // razorpay.clear();
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */

    //  print('SUccess');
    Fluttertoast.showToast(
        msg: "Payment Successfull Func", toastLength: Toast.LENGTH_LONG);
    showAlertDialog(
        context, "Payment Successful", "Payment ID: ${response.paymentId}");
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    print('Wallet');
    showAlertDialog(
        context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    // print("In function");
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        width: MediaQuery.of(context).size.width,
        height: (MediaQuery.of(context).size.height) * (0.30),
        child: GoogleMap(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.28),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          initialCameraPosition: initialCameraPosition,
          // markers: markers,
          zoomControlsEnabled: false,
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) async {
            googleMapController = controller;
          },
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Text(
          "Disposal Size",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.17,
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: InkWell(
                      onTap: () {
                        setState(() {
                          _small = true;
                          _medium = false;
                          _large = false;
                          disposalSize = "Small";
                          //tipAmount = 0;
                          pickupFee = disposalSizeRates[disposalSize]!;
                          taxAmount = (pickupFee + tipAmount) * gstRate;
                          totalBillAmount = pickupFee + taxAmount + tipAmount;
                        });
                      },
                      child: Card(
                        color: _small ? Colors.lightGreen.shade200 : null,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Icon(
                                  Icons.shopping_bag_rounded,
                                  size: 30,
                                  //color: Colors.g,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      "SMALL",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Weight: 0 - 4kg",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ]),
                        ),
                      )),
                ),
                Expanded(
                  child: InkWell(
                      onTap: () {
                        setState(() {
                          _small = false;
                          _medium = true;
                          _large = false;
                          disposalSize = "Medium";
                          //tipAmount = 0;
                          pickupFee = disposalSizeRates[disposalSize]!;
                          taxAmount = (pickupFee + tipAmount) * gstRate;
                          totalBillAmount = pickupFee + taxAmount + tipAmount;
                        });
                      },
                      child: Card(
                        color: _medium ? Colors.lightGreen.shade200 : null,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Icon(
                                  Icons.shopping_bag_rounded,
                                  size: 30,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      "MEDIUM",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Weight: 4 - 8kg",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ]),
                        ),
                      )),
                ),
              ],
            ),
            Expanded(
              child: InkWell(
                  onTap: () {
                    setState(() {
                      _small = false;
                      _medium = false;
                      _large = true;
                      disposalSize = "Large";
                      // tipAmount = 0;
                      pickupFee = disposalSizeRates[disposalSize]!;
                      taxAmount = (pickupFee + tipAmount) * gstRate;
                      totalBillAmount = pickupFee + taxAmount + tipAmount;
                    });
                  },
                  child: Card(
                    color: _large ? Colors.lightGreen.shade200 : null,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Icon(
                              Icons.table_restaurant,
                              size: 30,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                Text(
                                  "LARGE",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Weight: 20kg + (sofas, chairs, tables, etc)",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ]),
                    ),
                  )),
            ),
          ]),
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Text(
          "Pickup Summary",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
      Expanded(
          child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Pickup Fee",
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                    Text(
                      "₹${pickupFee.toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 13, letterSpacing: 1.5),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Pickup Tip",
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                    Text(
                      "₹${tipAmount.toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 13, letterSpacing: 1.5),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8, top: 2, bottom: 1, right: 8),
                child: InkWell(
                  child: const Text("Add Tip",
                      style: TextStyle(color: Colors.blue, fontSize: 9)),
                  onTap: () {
                    showAlertDialogForTip(context);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Govt. Taxes",
                      style:
                          TextStyle(color: Colors.grey.shade800, fontSize: 12),
                    ),
                    Text(
                      "₹${taxAmount.toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 13, letterSpacing: 1.5),
                    ),
                  ],
                ),
              ),
              Expanded(child: Container()),
              const Divider(
                indent: 8,
                endIndent: 8,
                color: Colors.blueGrey,
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "To Pay",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    Text(
                      "₹${totalBillAmount.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 13,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
      Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Row(
          children: [
            const Icon(
              Icons.home,
              size: 35,
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pickup at $pickupAddressName",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  Text(pickupAddressBrief,
                      style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  InkWell(
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        initialTime: TimeOfDay.now(),
                        context: context,
                      );

                      if (pickedTime != null) {
                        DateTime now = DateTime.now();
                        DateTime parsedTime = DateTime(now.year, now.month,
                            now.day, pickedTime.hour, pickedTime.minute);
                        print(parsedTime); //output 2023-04-27 22:53:00.000
                        String formattedTime =
                            DateFormat('HH:mm:ss').format(parsedTime);
                        print(formattedTime);

                        //  print(pickedTime.format(context)); //output 10:51 PM
                        // DateTime? parsedTime =
                        //     DateFormat.jm().parse(pickedTime.format(context));
                        // //converting to DateTime so that we can further format on different pattern.
                        // print(parsedTime); //output 1970-01-01 22:53:00.000
                        // String formattedTime =
                        //     DateFormat('HH:mm:ss').format(parsedTime);
                        // print(formattedTime); //output 14:59:00
                        // //DateFormat() is from intl package, you can format the time on any pattern you need.

                        setState(() {
                          timeinput.text =
                              formattedTime; //set the value of text field.
                        });
                      } else {
                        print("Time is not selected");
                      }
                    },
                    child: timeinput.text == ""
                        ? const Text(
                            "Schedule for later",
                            style: TextStyle(
                                fontSize: 10,
                                // fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          )
                        : Text(
                            'Scheduled for ${timeinput.text}',
                            style: const TextStyle(
                                fontSize: 10,
                                // fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                  )
                ],
              ),
            )),
            TextButton(
                onPressed: () {
                  TextEditingController controller1 = TextEditingController(),
                      controller2 = TextEditingController(),
                      addressName = TextEditingController();
                  showModalBottomSheet(
                      context: context,
                      elevation: 10,
                      // gives rounded corner to modal bottom screen
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        // UDE : SizedBox instead of Container for whitespaces
                        return Padding(
                          padding: MediaQuery.of(context).viewInsets,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.45,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 30, right: 30, top: 10),
                              //padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Enter Address Details",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextField(
                                    controller: controller1,
                                    decoration: const InputDecoration(
                                      labelText: "House / Flat / Block no.",
                                    ),
                                  ),
                                  TextField(
                                    controller: controller2,
                                    decoration: const InputDecoration(
                                        labelText: "Apartment / Road / Area"),
                                  ),
                                  TextField(
                                    controller: addressName,
                                    decoration: const InputDecoration(
                                        labelText: "Save As"),
                                  ),
                                  // Delivery Instructions
                                  // TextField()
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        // backgroundColor: ,
                                        minimumSize: const Size.fromHeight(40),
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          pickupAddressName = addressName.text;
                                          pickupAddress =
                                              "${controller1.text} ${controller2.text}";
                                          pickupAddressBrief = controller2.text;
                                        });

                                        if (pickupAddress == "" ||
                                            pickupAddressName == "" ||
                                            pickupAddressBrief == "") {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Please fill in all the details",
                                              toastLength: Toast.LENGTH_LONG);
                                          return;
                                        }

                                        final updateDb = await conn.query(
                                            'UPDATE USERS SET `Address_Name` = "${addressName.text}", `Address` = "$pickupAddress" WHERE `id` = ${obj.getID};');
                                        print(
                                            'Updated ${updateDb.affectedRows} rows');
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('SAVE ADDRESS')),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                },
                child: const Text(
                  "CHANGE",
                  style: TextStyle(color: Colors.green),
                ))
          ],
        ),
      ),
      SizedBox(
        height: 60,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  "₹${totalBillAmount.toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: InkWell(
                onTap: () {
                  if (!_small && !_medium && !_large) {
                    Fluttertoast.showToast(
                        msg: "Select Disposal Size",
                        toastLength: Toast.LENGTH_LONG);
                    return;
                  }
                  pointsEarned = (totalBillAmount.toInt() * 0.25).toInt();

                  completePaymemt();
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.green),
                  height: 45,
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: const Center(
                    child: Text(
                      'Proceed to Pay',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ]);
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
