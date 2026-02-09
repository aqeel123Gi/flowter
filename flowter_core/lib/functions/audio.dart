import 'package:just_audio/just_audio.dart';

AudioPlayer _audioPlayer = AudioPlayer();

Future<void> playAudioFromAssets(String path, {int? seconds}) async {

  Duration? duration = await _audioPlayer.setAsset('assets/$path');
  if (seconds != null) {
    await _audioPlayer.setLoopMode(LoopMode.one);
    await _audioPlayer.play();
    await Future.delayed(Duration(seconds: seconds));
    await _audioPlayer.stop();
  } else {
    await _audioPlayer.play();
    await Future.delayed(duration! + const Duration(milliseconds: 200));
    await _audioPlayer.stop();
  }
}
