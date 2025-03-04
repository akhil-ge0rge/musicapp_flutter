import 'dart:convert';

import 'package:client/core/constants/server_constant.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/features/home/model/song_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(Ref ref) {
  return HomeRepository();
}

class HomeRepository {
  Future<Either<AppFailure, String>> uploadSong({
    required String songFilePath,
    required String thumbnailFilePath,
    required String artist,
    required String songName,
    required String colorCode,
    required String token,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ServerConstant.serverUrl}/song/upload'),
      );
      request
        ..files.addAll([
          await http.MultipartFile.fromPath('song', songFilePath),
          await http.MultipartFile.fromPath('thumbnail', thumbnailFilePath),
        ])
        ..fields.addAll({
          'artist': artist,
          'song_name': songName,
          'hex_color': colorCode,
        })
        ..headers.addAll({'x-auth-token': token});
      final res = await request.send();
      if (res.statusCode != 201) {
        return Left(AppFailure(await res.stream.bytesToString()));
      }

      return Right(await res.stream.bytesToString());
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<SongModel>>> getAllSongs({
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('${ServerConstant.serverUrl}/song/list'),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );
      var resBody = jsonDecode(response.body);
      if (response.statusCode != 200) {
        resBody = resBody as Map<String, dynamic>;
        return Left(AppFailure(resBody["detail"]));
      }
      resBody = resBody as List;
      List<SongModel> songList = [];
      for (var song in resBody) {
        songList.add(SongModel.fromMap(song));
      }
      return Right(songList);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, bool>> favorite({
    required String token,
    required String songId,
  }) async {
    try {
      Map<String, dynamic> body = {"song_id": songId};

      final response = await http.post(
        Uri.parse('${ServerConstant.serverUrl}/song/fav'),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );
      var resBody = jsonDecode(response.body);
      if (response.statusCode != 200) {
        resBody = resBody as Map<String, dynamic>;
        return Left(AppFailure(resBody["detail"]));
      }

      return Right(resBody['message']);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<SongModel>>> getFavoriteSongs({
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('${ServerConstant.serverUrl}/song/list/favs'),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );
      var resBody = jsonDecode(response.body);
      if (response.statusCode != 200) {
        resBody = resBody as Map<String, dynamic>;
        return Left(AppFailure(resBody["detail"]));
      }
      resBody = resBody as List;
      List<SongModel> songList = [];
      for (var song in resBody) {
        songList.add(SongModel.fromMap(song['song']));
      }
      return Right(songList);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
