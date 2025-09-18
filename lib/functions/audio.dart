import 'dart:io';
import 'package:audioplayers/audioplayers.dart' as p2;
import 'package:just_audio/just_audio.dart' as p1;

Future<void> playAudioFromAssets(String path,{int? seconds})async{

  if(!Platform.isWindows){
    p1.AudioPlayer audioPlayer = p1.AudioPlayer();
    Duration? duration = await audioPlayer.setAsset('assets/$path');
    if(seconds!=null){
      audioPlayer.setLoopMode(p1.LoopMode.one);
      audioPlayer.play();
      await Future.delayed(Duration(seconds: seconds));
      await audioPlayer.stop();
    }else{
      audioPlayer.play();
      await Future.delayed(duration!+const Duration(milliseconds: 200));
      await audioPlayer.stop();
    }
    await audioPlayer.dispose();
  }
  else{

    p2.AudioPlayer audioPlayer = p2.AudioPlayer();
    await audioPlayer.setSource(p2.AssetSource(path));
    Duration? duration = await audioPlayer.getDuration();

    if(seconds!=null){
      audioPlayer.play(p2.AssetSource(path));
      await Future.delayed(Duration(seconds: seconds));
      await audioPlayer.stop();
    }else {
      audioPlayer.play(p2.AssetSource(path));
      await Future.delayed(duration! + const Duration(milliseconds: 200));
      await audioPlayer.stop();
    }
    await audioPlayer.dispose();

  }

}


