import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/education_data.dart';

class Education extends StatefulWidget {
  const Education({super.key});

  @override
  State<Education> createState() => _EducationState();
}

class _EducationState extends State<Education> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('What we do')),
      ),
      body: ListView.builder(
          itemCount: educationalVideos.length,
          itemBuilder: ((context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        decoration: const BoxDecoration(color: Colors.grey),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 5, top: 10, bottom: 10),
                        child: Text(educationalVideos[index].toString(),
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ]),
              ),
            );
          })),
    );
  }
}
