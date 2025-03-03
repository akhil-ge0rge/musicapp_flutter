// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:ui';

class SongModel {
  final String id;
  final String songName;
  final String artist;
  final String thumbnailUrl;
  final String songUrl;
  final String hexColor;
  SongModel({
    required this.id,
    required this.songName,
    required this.artist,
    required this.thumbnailUrl,
    required this.songUrl,
    required this.hexColor,
  });

  SongModel copyWith({
    String? id,
    String? songName,
    String? artist,
    String? thumbnailUrl,
    String? songUrl,
    String? hexColor,
  }) {
    return SongModel(
      id: id ?? this.id,
      songName: songName ?? this.songName,
      artist: artist ?? this.artist,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      songUrl: songUrl ?? this.songUrl,
      hexColor: hexColor ?? this.hexColor,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'song_name': songName,
      'artist': artist,
      'thumbnail_url': thumbnailUrl,
      'song_url': songUrl,
      'hex_color': hexColor,
    };
  }

  factory SongModel.fromMap(Map<String, dynamic> map) {
    return SongModel(
      id: map['id'] ?? '',
      songName: map['song_name'] ?? '',
      artist: map['artist'] ?? '',
      thumbnailUrl: map['thumbnail_url'] ?? '',
      songUrl: map['song_url'] ?? '',
      hexColor: map['hex_color'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SongModel.fromJson(String source) =>
      SongModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SongModel(id: $id, songName: $songName, artist: $artist, thumbnailUrl: $thumbnailUrl, songUrl: $songUrl, hexColor: $hexColor)';
  }

  @override
  bool operator ==(covariant SongModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.songName == songName &&
        other.artist == artist &&
        other.thumbnailUrl == thumbnailUrl &&
        other.songUrl == songUrl &&
        other.hexColor == hexColor;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        songName.hashCode ^
        artist.hashCode ^
        thumbnailUrl.hashCode ^
        songUrl.hashCode ^
        hexColor.hashCode;
  }
}
