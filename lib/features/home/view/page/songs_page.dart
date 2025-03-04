import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widget/loader.dart';
import 'package:client/features/home/repositories/home_repository.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SongsPage extends ConsumerWidget {
  const SongsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentlyPlayedSongs =
        ref.watch(homeViewModelProvider.notifier).getRecentlyPlayedSongs();
    final currentSong = ref.watch(currentSongNotifierProvider);
    return SafeArea(
      top: false,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration:
            currentSong == null
                ? null
                : BoxDecoration(
                  gradient: LinearGradient(
                    stops: const [0.0, 0.3],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,

                    colors: [
                      hexToRgb(currentSong.hexColor),
                      Pallete.transparentColor,
                    ],
                  ),
                ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: 36,
              ),
              child: SizedBox(
                height: 280,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: recentlyPlayedSongs.length,
                  itemBuilder: (context, index) {
                    final song = recentlyPlayedSongs.elementAt(index);
                    return GestureDetector(
                      onTap: () {
                        ref
                            .read(currentSongNotifierProvider.notifier)
                            .updateSong(song);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Pallete.borderColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.only(right: 20),
                        child: Row(
                          children: [
                            Container(
                              width: 56,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  bottomLeft: Radius.circular(4),
                                ),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(song.thumbnailUrl),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                song.songName,
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Latest Today",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
              ),
            ),
            ref
                .watch(getAllSongsProvider)
                .when(
                  data: (songs) {
                    return SizedBox(
                      height: 260,
                      child: ListView.separated(
                        itemCount: songs.length,
                        scrollDirection: Axis.horizontal,
                        separatorBuilder:
                            (context, index) => const SizedBox(width: 20),
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          final song = songs.elementAt(index);
                          return GestureDetector(
                            onTap: () {
                              ref
                                  .read(currentSongNotifierProvider.notifier)
                                  .updateSong(song);
                            },
                            child: Column(
                              children: [
                                Container(
                                  width: 180,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(song.thumbnailUrl),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                SizedBox(
                                  width: 180,
                                  child: Text(
                                    song.songName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                                SizedBox(
                                  width: 180,
                                  child: Text(
                                    song.artist,
                                    style: const TextStyle(
                                      color: Pallete.subtitleText,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                  error: (error, stackTrace) {
                    return Center(child: Text(error.toString()));
                  },
                  loading: () {
                    return LoaderWidget();
                  },
                ),
          ],
        ),
      ),
    );
  }
}
