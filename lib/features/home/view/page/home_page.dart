import 'package:client/core/constants/image_constant.dart';
import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/features/home/view/page/songs_page.dart';
import 'package:client/features/home/view/page/upload_song_page.dart';
import 'package:client/features/home/view/widget/song_slab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int selectedIndex = 0;

  final pages = const [SongsPage(), UploadSongPage()];
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserNotifierProvider);
    debugPrint("USER --> $user");
    return Scaffold(
      body: Stack(
        children: [
          pages.elementAt(selectedIndex),
          const Positioned(bottom: 0, child: SongSlab()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },

        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              selectedIndex == 0
                  ? ImageConstant.homeFilled
                  : ImageConstant.homeUnfilled,

              color:
                  selectedIndex == 0
                      ? Pallete.whiteColor
                      : Pallete.inactiveBottomBarItemColor,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              ImageConstant.library,
              color:
                  selectedIndex == 1
                      ? Pallete.whiteColor
                      : Pallete.inactiveBottomBarItemColor,
            ),
            label: 'Library',
          ),
        ],
      ),
    );
  }
}
