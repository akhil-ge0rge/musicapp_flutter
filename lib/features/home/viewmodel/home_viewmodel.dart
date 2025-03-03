import 'dart:io';

import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/repositories/home_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_viewmodel.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  late HomeRepository _homeRepositoies;
  @override
  AsyncValue? build() {
    _homeRepositoies = ref.watch(homeRepositoryProvider);
    return null;
  }

  Future<void> uploadSong({
    required File songFile,
    required File thumbnailFile,
    required String artist,
    required String songName,
    required Color color,
  }) async {
    state = AsyncValue.loading();

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
}
