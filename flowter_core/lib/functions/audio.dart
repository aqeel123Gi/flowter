import 'dart:io';
import 'package:just_audio/just_audio.dart';
import "package:windows_audio/windows_audio.dart";

final AudioPlayer _audioPlayer = AudioPlayer();

Future<void> playAudioFromAssets(String path, {int? seconds}) async {

  if (Platform.isWindows) {
    final Player = WindowsAudio();
    Player.load("assets/audio/filename");
    await Player.play();
    return;
  }

  // `setAsset` can return null if the duration is unknown (e.g. some formats,
  // or if the asset could not be loaded). We must *not* force-unwrap it.
  final Duration? duration = await _audioPlayer.setAsset('assets/$path');

  if (seconds != null) {
    // Explicit duration: loop for the requested number of seconds.
    await _audioPlayer.setLoopMode(LoopMode.one);
    await _audioPlayer.play();
    await Future.delayed(Duration(seconds: seconds));
    await _audioPlayer.stop();
    return;
  }

  // No explicit duration: play once, and stop when the audio completes.
  await _audioPlayer.play();

  if (duration != null) {
    // Known duration – wait a little longer than the track length.
    await Future.delayed(duration + const Duration(milliseconds: 200));
  } else {
    // Unknown duration – wait until the player reports completion or idle.
    await _audioPlayer.processingStateStream.firstWhere(
      (state) =>
          state == ProcessingState.completed ||
          state == ProcessingState.idle ||
          state == ProcessingState.ready,
    );
  }

  await _audioPlayer.stop();
}
