import 'dart:developer';

import 'package:client/features/home/model/song_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'current_song_notifier.g.dart';

@Riverpod(keepAlive: true)
class CurrentSongNotifier extends _$CurrentSongNotifier {
  AudioPlayer? _audioPlayer;
  @override
  SongModel? build() {
    return null;
  }

  void updateSong(SongModel song) async {
    try {
      log("HIIII startinggg");
      _audioPlayer = AudioPlayer();
      final audioSource = AudioSource.uri(Uri.parse(song.songUrl));
      await _audioPlayer!.setAudioSource(audioSource);
      _audioPlayer!.play();
      state = song;
      log("HIIII Endinggg");
    } catch (e) {
      log(e.toString());
    }
  }
}
