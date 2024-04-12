
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {

  final XFile video;

  const CustomVideoPlayer({required this.video, Key? key}) : super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {

  VideoPlayerController? videoPlayerController;
  Duration currentPosition = Duration();

  @override
  void initState() {
    super.initState();

    initializeController();
  }

  initializeController() async{
    videoPlayerController = VideoPlayerController.file(
      File(widget.video.path),
    );

    await videoPlayerController!.initialize();

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {

    if(videoPlayerController == null){
      return CircularProgressIndicator();
    }

    return AspectRatio(
      aspectRatio: videoPlayerController!.value.aspectRatio,
      child: Stack(
        children: [
          VideoPlayer(
            videoPlayerController!,
          ),
          _Controls(
            isPlaying: videoPlayerController!.value.isPlaying,
            onReversePressed: onReversePressed,
            onPlayPressed: onPlayPressed,
            onForwardPressed: onForwardPressed,
          ),
          _NewVideo(onPressed: onNewVideoPressed ,),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(
                    '${currentPosition.inMinutes}:${(currentPosition.inSeconds % 60).toString().padLeft(2,'0')}',
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                ),
                Expanded(
                  child: Slider(
                      max: videoPlayerController!.value.duration.inSeconds.toDouble(),
                      min: 0,
                      value: currentPosition.inSeconds.toDouble(),
                      onChanged: (double val){
                        setState(() {
                          currentPosition = Duration(seconds: val.toInt());
                        });
                      }
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );

  }

  void onNewVideoPressed(){

  }

  void onReversePressed(){
    final currentPosition = videoPlayerController!.value.position;

    Duration position = Duration();

    if(currentPosition.inSeconds > 3){
      position = currentPosition - Duration(seconds: 3);
    }

    videoPlayerController!.seekTo(position);
  }

  void onForwardPressed(){
    final maxPosition = videoPlayerController!.value.duration;
    final currentPosition = videoPlayerController!.value.position;

    Duration position = maxPosition;

    if((maxPosition - Duration(seconds: 3)).inSeconds > currentPosition.inSeconds){
      position = currentPosition + Duration(seconds: 3);
    }

    videoPlayerController!.seekTo(position);
  }

  void onPlayPressed(){
    //이미 실행중이면 중지 아니면 실행

    setState(() {
      if(videoPlayerController!.value.isPlaying){
        videoPlayerController!.pause();

      }else{
        videoPlayerController!.play();
      }
    });

  }

}

class _Controls extends StatelessWidget {

  final bool isPlaying;
  final VoidCallback onPlayPressed;
  final VoidCallback onReversePressed;
  final VoidCallback onForwardPressed;

  const _Controls({
    required this.isPlaying,
    required this.onPlayPressed,
    required this.onReversePressed,
    required this.onForwardPressed,
    Key? key
}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          renderIconButton(
              onPressed: onReversePressed
              ,iconData: Icons.rotate_left
          ),
          renderIconButton(
              onPressed: onPlayPressed
              ,iconData: isPlaying ? Icons.pause : Icons.play_arrow
          ),
          renderIconButton(
              onPressed: onForwardPressed
              ,iconData: Icons.rotate_right
          ),
        ],
      ),
    );
  }

  Widget renderIconButton({
    required onPressed,
    required IconData iconData,
  }){
    return  IconButton(
        onPressed: onPressed,
        color: Colors.white,
        iconSize: 30.0,
        icon: Icon(
            iconData
        ));
  }
}

class _NewVideo extends StatelessWidget {

  final VoidCallback onPressed;

  const _NewVideo({required this.onPressed, Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      child: IconButton(onPressed: onPressed, icon: Icon(
        color: Colors.white,
        size: 30.0,
        Icons.photo_camera_back,
      )),
    );
  }
}


