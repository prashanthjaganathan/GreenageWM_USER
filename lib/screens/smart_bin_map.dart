import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:mysql1/mysql1.dart';
import '../data/smart_bins_loc.dart';
import '../widgets/home.dart';

class SmartBinMap extends StatefulWidget {
  const SmartBinMap({super.key});

  @override
  State<SmartBinMap> createState() => _SmartBinMapState();
}

class _SmartBinMapState extends State<SmartBinMap> {
  late GoogleMapController googleMapController;
  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(13.0159044, 77.63786189999996), zoom: 12.0);

  getCurrentLocationAndData() async {
    {
      var _conn = await MySqlConnection.connect(
        ConnectionSettings(
          host: '34.93.37.194',
          port: 3306,
          user: 'root',
          password: 'root',
          db: 'greenage',
        ),
      );

      // Setting up Smart Bin data
      final results = await _conn.query('SELECT * FROM SMART_BINS');

      for (var row in results) {
        print(row.toString());
        binID.add(row['Bin_No']);
        latitudes.add(row['latitude']);
        longtitudes.add(row['longitude']);

        markers.add(Marker(
          markerId: MarkerId("Smart Bin #${row['Bin_No']}"),
          position: LatLng(row['latitude'], row['longitude']),
        ));
      }
    }

    Position position = await _determinePosition();
    // print(position.latitude.toString());
    await googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 17)));

    setState(() {
      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 17)));
    });
  }

  void callFunc() async {
    await getCurrentLocationAndData();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    //sleep(Duration(seconds: 5));
    Future.delayed(Duration.zero, () async {
      {
        var _conn = await MySqlConnection.connect(
          ConnectionSettings(
            host: '34.93.37.194',
            port: 3306,
            user: 'root',
            password: 'root',
            db: 'greenage',
          ),
        );

        // Setting up Smart Bin data
        final results = await _conn.query('SELECT * FROM SMART_BINS');

        for (var row in results) {
          print(row.toString());
          binID.add(row['Bin_No']);
          latitudes.add(row['latitude']);
          longtitudes.add(row['longitude']);

          markers.add(Marker(
            markerId: MarkerId("Smart Bin #${row['Bin_No']}"),
            position: LatLng(row['latitude'], row['longitude']),
          ));
        }
      }

      Position position = await _determinePosition();
      // print(position.latitude.toString());
      await googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 17)));

      setState(() {
        googleMapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 17)));
      });
    });

    // callFunc();
  }

  @override
  Widget build(BuildContext context) {
    //sleep(Duration(seconds: 2));
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        width: MediaQuery.of(context).size.width,
        height: (MediaQuery.of(context).size.height) * (0.65),
        child: GoogleMap(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.57),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          initialCameraPosition: initialCameraPosition,
          markers: markers,
          zoomControlsEnabled: false,
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) async {
            googleMapController = controller;
          },
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 2),
        child: Text("Smart Bins Near You",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      const Padding(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 0),
        child: Divider(
          thickness: 2,
          color: Colors.black38,
        ),
      ),
      Expanded(
          child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: ListView.builder(
          itemCount: binID.length,
          itemBuilder: (context, index) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: Image.asset(
                        "assets/images/bin_marker.png",
                        //fit: BoxFit.contain,
                      ),
                    ),
                    Expanded(
                        child: Center(
                      child: Text(
                        "\t\tSmart Bin # ${binID[index]}".toUpperCase(),
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    )),
                    IconButton(
                        onPressed: () => MapsLauncher.launchCoordinates(
                            latitudes[index],
                            longtitudes[index],
                            'Greenage Waste Management - Smart Bin # ${binID[index]} '),
                        icon: const Icon(
                          Icons.directions_sharp,
                          color: Colors.blue,
                          size: 35,
                        ))
                  ],
                ),
              ),
            );
          },
        ),
      )),
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
