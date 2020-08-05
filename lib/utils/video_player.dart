import 'package:faithstream/model/blog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  String url;
  Blog blog;

  VideoPlayerScreen({Key key, this.url,this.blog}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController controller;
  Future<void> initializeVideoPlayer;
  int hidebutton = 1;
  var currentPositionInSec = 0;

  @override
  void initState() {
    controller = VideoPlayerController.network(
      widget.url,
    );
    controller.setLooping(true);
    initializeVideoPlayer = controller.initialize();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery
        .of(context)
        .orientation;
    var isBufferingWidget = Align(
      alignment: Alignment.center,
      child: Container(
        width: 30,
        height: 30,
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
    return Scaffold(
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      body: FutureBuilder(
        future: initializeVideoPlayer,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the VideoPlayerController has finished initialization, use
            // the data it provides to limit the aspect ratio of the video.
            return SizedBox.expand(
              child: snapshot.hasError ? Center(child: Image.asset("assets/images/signalerror.png")) : Stack(children: <Widget>[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if(widget.blog.isPurchased == true || widget.blog.isPaidVideo == false)
                      if (hidebutton == 0) {
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
                 controller.value.isBuffering ? isBufferingWidget : Container(),

                if (hidebutton == 0)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: LayoutBuilder(
                      builder: (cntx, constraints) {
                        return Container(
                          margin: EdgeInsets.only(
                              bottom: constraints.maxHeight * 0.01),
                          width: double.infinity,
                          height: constraints.maxHeight * 0.14,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: constraints.maxWidth * 0.03),
                            child: ValueListenableBuilder(
                                valueListenable: controller,
                                builder:
                                    (context, VideoPlayerValue value, child) {
                                  var currentMinutes = value.position
                                      .inMinutes > 60 ? (value.position
                                      .inMinutes / 60).round() : (value.position
                                      .inMinutes);
                                  var currentSeconds = value.position
                                      .inSeconds > 60
                                      ? (value.position.inSeconds -
                                      (60 * value.position.inMinutes)).round()
                                      : (value.position.inSeconds);
                                  var totalMinutes = value.duration.inMinutes >
                                      60 ? (value.duration.inMinutes / 60)
                                      .round() : (value.duration.inMinutes);
                                  var totalSeconds = value.duration.inSeconds >
                                      60
                                      ? (value.duration.inSeconds -
                                      (60 * value.duration.inMinutes)).round()
                                      : (value.duration.inSeconds);
                                  if(widget.blog.isPaidVideo == true && widget.blog.isPurchased == false) {
                                    if(value.position == parseDuration(
                                        widget.blog.freeVideoLength.toString()))
                                      controller.pause();
                                  }
                                  //Do Something with the value
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    children: <Widget>[
                                      GestureDetector(
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
                                          child: Icon(
                                            controller.value.isPlaying
                                                ? Icons.pause
                                                : Icons.play_arrow,
                                            color: Colors.white,
                                            size: 25,
                                          )),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 4.0),
                                        child: Text(
                                          "$currentMinutes:${currentSeconds > 9
                                              ? currentSeconds
                                              : "0$currentSeconds"}",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(
                                            orientation == Orientation.landscape
                                                ? 10
                                                : 0.0),
                                        child: Container(
                                          width: orientation ==
                                              Orientation.landscape
                                              ? constraints.maxWidth * 0.72
                                              : constraints.maxWidth * 0.6,
                                          child: SliderTheme(
                                            data: Theme
                                                .of(context)
                                                .sliderTheme,
                                            child: Slider(
                                              value: (value.position.inSeconds)
                                                  .toDouble(),
                                              min: 0.0,
                                              max: (controller
                                                  .value.duration.inSeconds)
                                                  .toDouble(),
                                              onChanged: (double newValue) {
                                                if (controller.value
                                                    .isBuffering)
                                                  isBufferingWidget;
                                                setState(() {
                                                  controller.seekTo(
                                                      parseDuration(
                                                          newValue.toString()));
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 0.0),
                                        child: Text(
                                          "$totalMinutes:${totalSeconds > 9
                                              ? totalSeconds
                                              : "0$totalSeconds"}",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            orientation == Orientation.portrait
                                                ? SystemChrome
                                                .setPreferredOrientations([
                                              DeviceOrientation.landscapeLeft
                                            ]) : ({SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]), SystemChrome.setPreferredOrientations([]) });
                                          },
                                          child: Icon(
                                            Icons.fullscreen,
                                            color: Colors.white,
                                            size: 25,
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                }),
                          ),
                        );
                      },
                    ),
                  )
              ]),
            );
          } else {
            // If the VideoPlayerController is still initializing, show a
            // loading spinner.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Duration parseDuration(String s) {
    int hours = 0;
    int minutes = 0;
    int micros;
    List<String> parts = s.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
    return Duration(hours: hours, minutes: minutes, microseconds: micros);
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
