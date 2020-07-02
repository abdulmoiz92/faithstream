import 'package:cached_video_player/cached_video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
  String url;

  VideoPlayerScreen({Key key, this.url}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  ChewieController chewieController;
  Chewie playerWidget;
  VideoPlayerController controller;
  Future<void> initializeVideoPlayer;
  int hidebutton = 0;
  double videoWidth = 5;
  double videoHeight = 3;

  @override
  void initState() {
    controller = VideoPlayerController.network(
      widget.url,
      formatHint: VideoFormat.other
    )..initialize().then((_) {
      setState(() {
        videoWidth = controller.value.size.width;
        videoHeight = controller.value.size.height;
      });
    });

    chewieController = ChewieController(
      videoPlayerController: controller,
      aspectRatio: videoWidth/videoHeight ,
      autoPlay: false,
      looping: true,
    );

     playerWidget = Chewie(
      controller: chewieController,
    );

    controller.setLooping(true);
    initializeVideoPlayer = controller.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeVideoPlayer,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the VideoPlayerController has finished initialization, use
          // the data it provides to limit the aspect ratio of the video.
          return playerWidget != null ? playerWidget : Container(); /*Stack(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    if(hidebutton == 0) {
                      hidebutton = 1;
                    } else {
                      hidebutton = 0;
                    }
                  });
                },
                child: SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: SizedBox(
                        width: controller.value.size?.width ?? 0,
                        height: controller.value.size?.height ?? 0,
                        child: VideoPlayer(controller),
                  ),
                ),
                ),
              ),
             if(hidebutton == 0) GestureDetector(
                onTap: () {
                  setState(() {
                    if (controller.value.isPlaying) {
                      controller.pause();
                    } else {
                      // If the video is paused, play it.
                      controller.play();
                    }
                  });
                },
                child: Center(
                      child: Icon(controller.value.isPlaying ? Icons.pause : Icons.play_arrow,color: Colors.white,size: 50,),
                ),
              ),
            ],
          );*/
        } else {
          // If the VideoPlayerController is still initializing, show a
          // loading spinner.
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void dispose() {
    setState(() {
      controller = null;
    });
    controller.dispose();
    chewieController.dispose();
    super.dispose();
  }

}

/* FutureBuilder(
        future: initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the VideoPlayerController has finished initialization, use
            // the data it provides to limit the aspect ratio of the video.
            return Container(
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                // Use the VideoPlayer widget to display the video.
                child: VideoPlayer(controller),
              ),
            );
          } else {
            // If the VideoPlayerController is still initializing, show a
            // loading spinner.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),*/

