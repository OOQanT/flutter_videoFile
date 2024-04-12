import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vid_player/component/custom_video_player.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  XFile? video;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: video == null ?  renderEmpty() : renderVideo(),
    );
  }

  Widget renderVideo(){
    return Center(
      child: CustomVideoPlayer(video: video!,),
    );
  }

  Widget renderEmpty(){
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: getBoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _Logo(onTap: onLogoTap,),
          SizedBox(height: 30.0,), // 패딩 대신 간격두기로 사용
          _AppName()
        ],
      ),
    );
  }

  void onLogoTap() async {
    final video = await ImagePicker().pickVideo(
        source: ImageSource.gallery
    );

    if(video != null){
      setState(() {
        this.video = video;
      });
    }
  }

  BoxDecoration getBoxDecoration(){
    return BoxDecoration(
      gradient: LinearGradient( // 그라데이션
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2A3A7C),
            Color(0xFF000118),
          ]
      ),
    );
  }
}

class _Logo extends StatelessWidget {

  final VoidCallback onTap;

  const _Logo({required this.onTap, Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Image.asset('asset/image/logo.png')
    );
  }
}

class _AppName extends StatelessWidget {

  const _AppName({super.key});

  @override
  Widget build(BuildContext context) {

    final textStyle = TextStyle(
        color: Colors.white,
        fontSize: 30.0,
        fontWeight: FontWeight.w300
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('VIDEO', style:textStyle),
        Text('PLAYER', style: textStyle.copyWith(fontWeight: FontWeight.w700)),
      ],
    );
  }
}


