import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/profile_data.dart';
import 'package:flutter_application_1/data/user_data.dart';
import 'package:flutter_application_1/screens/edit_profile.dart';
import 'package:flutter_application_1/screens/pickup_history.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _controller = TextEditingController();
  double donationAmount = 0;
  // late UserData obj;
  final XFile? _ximageFile = dp;

  completeDonationPaymemt() {
    Razorpay razorpay = Razorpay();
    var options = {
      'key': 'rzp_test_ToSi2ssJEeoxol',
      'amount': donationAmount * 100,
      'name': 'Greenage Waste Management',
      'description': 'Donation to Greenage Waste Management',
      'currency': 'INR',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {
        'contact': mobile,
        'email': emailID,
      },
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      razorpay.open(options);
    } catch (e) {
      debugPrint("Error ${e.toString()}");
    }
    //razorpay.clear();
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
    Fluttertoast.showToast(
        msg:
            'Thank you so much for your generous contribution of ₹$donationAmount');
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {}

  void showAlertDialogForDonation(BuildContext context) {
    // print("In function");
    // set up the buttons
    Widget continueButton = ElevatedButton(
        child: const Text("Continue"),
        onPressed: () {
          setState(() {
            String val = _controller.text;
            donationAmount = double.parse(val);
          });
          Navigator.of(context).pop();
          completeDonationPaymemt();
        });
    Widget cancelButton = TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Cancel'));
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text('Donation Amount (₹)'),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(hintText: '0.00'),
      ),
      actions: [
        cancelButton,
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
  void dispose() {
    _controller.dispose();
    //razorpay.clear();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey.shade50,
        title: const Center(
          child: Text('My Profile',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            //color: Colors.lightBlue,
            height: MediaQuery.of(context).size.width * 0.4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 8, top: 8, bottom: 8),
                  child: CircleAvatar(
                    radius: 60.0,
                    backgroundImage: dp == null
                        // ? (_imageFile == null
                        ? const AssetImage("assets/images/profile.jpeg")
                            as ImageProvider<Object>
                        //     : FileImage(File(_imageFile!.path)))
                        : FileImage(File(dp!.path)),
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      Text(emailID, style: const TextStyle(fontSize: 12)),
                      Text('+91 $mobile', style: const TextStyle(fontSize: 12)),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            await Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const EditProfile()));
                            // print(_ximageFile);
                            setState(() {
                              dp = _ximageFile;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          child: const Text('Edit Profile'))
                    ],
                  ),
                ))
              ],
            ),
          ),
          ListTile(
            title: const Text('Reward Points'),
            trailing: Text(
              '$points',
              style: TextStyle(color: Colors.green.shade800),
            ),
            leading: const Icon(Icons.score_outlined),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Your Vouchers'),
            trailing: Text(
              '$vouchers',
              style: TextStyle(color: Colors.green.shade800),
            ),
            leading: const Icon(Icons.card_giftcard_outlined),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Donate'),
            // trailing: Text('$vouchers'),
            leading: const Icon(Icons.currency_rupee_sharp),
            onTap: () {
              showAlertDialogForDonation(context);
            },
          ),
          ListTile(
            title: const Text('Pickup History'),
            // trailing: Text('$vouchers'),
            leading: const Icon(Icons.history),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PickupHistory()));
            },
          ),
          ListTile(
            title: const Text('Sign Out'),
            // trailing: Text('$vouchers'),
            leading: const Icon(
              Icons.logout_outlined,
              color: Colors.red,
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
