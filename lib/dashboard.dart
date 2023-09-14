import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart';
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final TextEditingController _linkController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
  appBar: AppBar(
          title: const Text('YouTube Downloader',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1,
            fontStyle: FontStyle.italic,
          ),
          ),
          backgroundColor: const Color.fromARGB(255, 139, 20, 20),
        ),
         body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _linkController,
                decoration: InputDecoration(
                  labelText: 'Enter YouTube Video Link',
                ),
              ),
               SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  String videoLink = _linkController.text.trim();
                  if (videoLink.isNotEmpty) {
                    _startDownload(videoLink);
                  }
                },
                child: Text('Download Video'),
              ),
            ],
          ),
        ),
    );
  }
}
    
 Future<void> _startDownload(String videoLink) async {
  // Extract the video ID from the YouTube link
  String? videoId = _extractVideoId(videoLink);

  if (videoId != null) {
    // Now you can use the videoId safely
    final downloadDirectory = await _getDownloadDirectory();
    final taskId = await FlutterDownloader.enqueue(
      url: 'https://www.youtube.com/watch?v=$videoId',
      savedDir: downloadDirectory,
      fileName: 'video.mp4',
      showNotification: true,
      openFileFromNotification: true,
    );

    
     FlutterDownloader.registerCallback((id, status, progress) {
        // Handle download status and progress here
        print('Download Task $id: Status $status, Progress $progress');
      });
    } else {
      print('Invalid YouTube Video Link');
    }
  }


String? _extractVideoId(String videoLink) {
  // Define a regular expression pattern to extract the video ID from the YouTube link
  // This pattern matches a variety of common YouTube URL formats
  RegExp regExp = RegExp(r"(?:youtu\.be/|youtube\.com(?:/embed/|/v/|/watch\?v=|/watch\?feature=player_embedded&v=))([^/?]{11})");
  Match? urlMatch = regExp.firstMatch(videoLink);
  if (urlMatch != null && urlMatch.groupCount >= 1) {
    return urlMatch.group(1);
  } else {
    return null;
  }
}


Future<String> _getDownloadDirectory() async {
  // Get the external storage directory (usually /storage/emulated/0)
  final directory = await getExternalStorageDirectory();

  // Create a subdirectory for your downloaded videos
  final downloadDirectory = Directory('${directory?.path}/YouTubeDownloads');

  // Create the directory if it doesn't exist
  if (!(await downloadDirectory.exists())) {
    await downloadDirectory.create(recursive: true);
  }

  return downloadDirectory.path;
}







 
