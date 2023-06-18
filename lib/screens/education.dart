import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/education_data.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Education extends StatefulWidget {
  const Education({super.key});

  @override
  State<Education> createState() => _EducationState();
}

class _EducationState extends State<Education> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('What we do')),
      ),
      body: ListView.builder(
          itemCount: educationalVideosData.length,
          itemBuilder: ((context, index) {
            final YoutubePlayerController _controller = YoutubePlayerController(
                initialVideoId: educationalVideosData[index].videoID,
                flags: const YoutubePlayerFlags(
                  autoPlay: false,
                  mute: false,
                ));

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.35,
                        decoration: const BoxDecoration(color: Colors.grey),
                        child: YoutubePlayer(
                          controller: _controller,
                          liveUIColor: Colors.amber,
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 5, top: 10, bottom: 10),
                        child: Text(
                            educationalVideosData[index].title.toString(),
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
