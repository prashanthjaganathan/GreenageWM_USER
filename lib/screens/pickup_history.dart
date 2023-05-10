import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_1/data/pickup_history_data.dart';

class PickupHistory extends StatefulWidget {
  const PickupHistory({super.key});

  @override
  State<PickupHistory> createState() => _PickupHistoryState();
}

class _PickupHistoryState extends State<PickupHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Pickups')),
      body: Container(
        child: pickupHistory.isEmpty
            ? const Center(
                child: Text('No pickups'),
              )
            : ListView.separated(
                itemCount: pickupHistory.length,
                separatorBuilder: ((context, index) {
                  return const Divider(
                    thickness: 2,
                  );
                }),
                itemBuilder: ((context, index) {
                  String str = (pickupHistory[index]['address']);

                  str = str.trim();
                  print(str);
                  List<String> words = str.split(" ");
                  // words.remove(words.length - 1);
                  print(words.length);
                  String add = words[words.length - 1];
                  print(add);
                  return ListTile(
                    horizontalTitleGap: 20,
                    leading: Text('#PU${pickupHistory[index]['pickup_id']}'),
                    title: Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Text(
                        'Disposal Size: ${pickupHistory[index]['disposal_size']}',
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(add),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Text(
                                'PE: ${pickupHistory[index]['points_earned']}'),
                          ),
                        ]),
                    trailing: Text(
                      '₹${pickupHistory[index]['total_bill']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                })),
      ),
    );
  }
}
