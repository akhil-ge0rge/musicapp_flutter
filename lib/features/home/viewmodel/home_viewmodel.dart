import 'dart:io';

import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/model/favorite_song_model.dart';
import 'package:client/features/home/model/song_model.dart';
import 'package:client/features/home/repositories/home_local_repository.dart';
import 'package:client/features/home/repositories/home_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_viewmodel.g.dart';

@riverpod
Future<List<SongModel>> getAllSongs(Ref ref) async {
  final token = ref.watch(
    currentUserNotifierProvider.select((value) => value!.token),
  );
  final res = await ref.watch(homeRepositoryProvider).getAllSongs(token: token);

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
Future<List<SongModel>> getAllFavSongs(Ref ref) async {
  final token = ref.watch(
    currentUserNotifierProvider.select((value) => value!.token),
  );
  final res = await ref
      .watch(homeRepositoryProvider)
      .getFavoriteSongs(token: token);

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
class HomeViewModel extends _$HomeViewModel {
  late HomeRepository _homeRepositoies;
  late HomeLocalRepository _homeLocalRepository;
  @override
  AsyncValue? build() {
    _homeRepositoies = ref.watch(homeRepositoryProvider);
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return null;
  }

  Future<void> uploadSong({
    required File songFile,
    required File thumbnailFile,
    required String artist,
    required String songName,
    required Color color,
  }) async {
    state = const AsyncValue.loading();

    final res = await _homeRepositoies.uploadSong(
      songFilePath: songFile.path,
      thumbnailFilePath: thumbnailFile.path,
      artist: artist,
      colorCode: rgbToHex(color),
      songName: songName,
      token: ref.read(currentUserNotifierProvider)!.token,
    );
    final val = switch (res) {
      Left(value: final l) =>
        state = AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    print(val);
  }

  List<SongModel> getRecentlyPlayedSongs() {
    return _homeLocalRepository.loadLocalSong();
  }

  Future<void> favoriteSong({required String songId}) async {
    state = const AsyncValue.loading();
    final res = await _homeRepositoies.favorite(
      songId: songId,
      token: ref.read(currentUserNotifierProvider)!.token,
    );
    final val = switch (res) {
      Left(value: final l) =>
        state = AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => _favoriteSongSucess(r, songId),
    };

    print(val);
  }

  AsyncValue _favoriteSongSucess(bool isFaved, String songId) {
    final userNotifier = ref.read(currentUserNotifierProvider.notifier);
    if (isFaved) {
      userNotifier.addUser(
        ref
            .read(currentUserNotifierProvider)!
            .copyWith(
              favorites: [
                ...ref.read(currentUserNotifierProvider)!.favorites,
                FavoriteSongModel(id: '', songId: songId, userId: ''),
              ],
            ),
      );
    } else {
      userNotifier.addUser(
        ref
            .read(currentUserNotifierProvider)!
            .copyWith(
              favorites:
                  ref
                      .read(currentUserNotifierProvider)!
                      .favorites
                      .where((element) => element.songId != songId)
                      .toList(),
            ),
      );
    }
    ref.invalidate(getAllFavSongsProvider);
    return state = AsyncValue.data(isFaved);
  }
}
