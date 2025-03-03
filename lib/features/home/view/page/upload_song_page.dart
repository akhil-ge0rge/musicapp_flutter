import 'dart:io';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widget/custom_field.dart';
import 'package:client/features/home/view/widget/audio_wave.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  const UploadSongPage({super.key});

  @override
  ConsumerState<UploadSongPage> createState() => _UploadSongPageState();
}

class _UploadSongPageState extends ConsumerState<UploadSongPage> {
  final songNameController = TextEditingController();
  final artisNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Color selectedColor = Pallete.cardColor;
  File? selectedImage;
  File? selectedSong;
  void selectAudio() async {
    final pickedSong = await pickAudio();
    if (pickedSong != null) {
      setState(() {
        selectedSong = pickedSong;
      });
    }
  }

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
      });
    }
  }

  @override
  void dispose() {
    songNameController.dispose();
    artisNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      homeViewModelProvider.select((value) => value?.isLoading == true),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Song"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              if (formKey.currentState!.validate() &&
                  selectedSong != null &&
                  selectedImage != null) {
                ref
                    .read(homeViewModelProvider.notifier)
                    .uploadSong(
                      songFile: selectedSong!,
                      thumbnailFile: selectedImage!,
                      artist: artisNameController.text.trim(),
                      songName: songNameController.text.trim(),
                      color: selectedColor,
                    );
              } else {
                showSnackBar(context, "All Fields Are Required");
              }
            },
            icon: Icon(Icons.done),
          ),
        ],
      ),
      body:
          isLoading
              ? SingleChildScrollView()
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: selectImage,
                          child:
                              selectedImage != null
                                  ? SizedBox(
                                    height: 159,
                                    width: double.infinity,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        selectedImage!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                  : DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: Radius.circular(10),
                                    color: Pallete.borderColor,
                                    strokeCap: StrokeCap.round,
                                    dashPattern: [10, 4],
                                    child: const SizedBox(
                                      height: 159,
                                      width: double.infinity,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.folder_open, size: 40),
                                          SizedBox(height: 15),
                                          Text(
                                            "Select Song's thumbnail",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                        ),
                        const SizedBox(height: 40),
                        selectedSong != null
                            ? AudioWave(path: selectedSong!.path)
                            : CustomField(
                              hintText: 'Pick Song',
                              controller: null,
                              isReadOnly: true,
                              onTap: selectAudio,
                            ),
                        const SizedBox(height: 20),
                        CustomField(
                          hintText: 'Song Name',
                          controller: songNameController,
                        ),
                        const SizedBox(height: 20),
                        CustomField(
                          hintText: 'Artist Name',
                          controller: artisNameController,
                        ),
                        const SizedBox(height: 20),
                        ColorPicker(
                          pickersEnabled: const {ColorPickerType.wheel: true},
                          onColorChanged: (value) {
                            setState(() {
                              selectedColor = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
