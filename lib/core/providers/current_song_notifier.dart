import 'dart:developer';

import 'package:client/features/home/model/song_model.dart';
import 'package:client/features/home/repositories/home_local_repository.dart';
import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'current_song_notifier.g.dart';

@Riverpod(keepAlive: true)
class CurrentSongNotifier extends _$CurrentSongNotifier {
  late HomeLocalRepository _homeLocalRepository;
  AudioPlayer? audioPlayer;
  bool isPlaying = false;
  @override
  SongModel? build() {
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return null;
  }

  void updateSong(SongModel song) async {
    try {
      await audioPlayer?.stop();
      audioPlayer = AudioPlayer();
      final audioSource = AudioSource.uri(Uri.parse(song.songUrl));
      await audioPlayer!.setAudioSource(audioSource);
      audioPlayer!.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          audioPlayer!.seek(Duration.zero);
          audioPlayer!.pause();
          isPlaying = false;
          this.state = this.state?.copyWith(hexColor: this.state?.hexColor);
        }
      });
      _homeLocalRepository.uploadLocalSong(song);
      audioPlayer!.play();
      isPlaying = true;
      state = song;
      log("HIIII Endinggg");
    } catch (e) {
      log(e.toString());
    }
  }

  void playPause() {
    if (isPlaying) {
      audioPlayer!.pause();
    } else {
      audioPlayer!.play();
    }
    isPlaying = !isPlaying;

    //for updating ui
    state = state?.copyWith(hexColor: state?.hexColor);
  }

  void seek(double val) {
    audioPlayer!.seek(
      Duration(
        milliseconds: (val * audioPlayer!.duration!.inMilliseconds).toInt(),
      ),
    );
  }
}
