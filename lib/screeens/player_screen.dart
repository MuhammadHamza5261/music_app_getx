import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_music_app/const/colors.dart';
import 'package:getx_music_app/const/text_style.dart';
import 'package:getx_music_app/controller/play_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';


class PlayerScreen extends StatelessWidget {
  final List<SongModel> data;

  PlayerScreen({Key? key, required this.data}) : super(key: key);

  // initialize the playController
  final PlayController playController = Get.put(PlayController());

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;


    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Player Screen',
          style: CustomTextTheme.textOne,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            Expanded(
              child: Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                height: 280,
                width: 280,
                decoration: const BoxDecoration(
                  color: AppColors.redColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Obx(() {
                  return QueryArtworkWidget(
                    id: data[playController.playIndex.value].id,
                    type: ArtworkType.AUDIO,
                    artworkHeight: double.infinity,
                    artworkWidth: double.infinity,
                    nullArtworkWidget: const Icon(
                      Icons.music_note,
                      size: 48,
                      color: AppColors.whiteColor,
                    ),
                  );
                }),
              ),
            ),
            Obx(() {
              return Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text(
                        data[playController.playIndex.value].displayNameWOExt,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: CustomTextTheme.textOne.copyWith(
                          color: AppColors.bgDarkColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        data[playController.playIndex.value].artist ?? "Unknown Artist",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: CustomTextTheme.textOne.copyWith(
                          color: AppColors.bgDarkColor,
                          fontWeight: FontWeight.w100,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Obx(() {
                        return Row(
                          children: [
                            Text(
                              playController.position.value,
                              style: CustomTextTheme.textOne.copyWith(
                                color: AppColors.bgColor,
                                fontSize: 10,
                              ),
                            ),
                            Expanded(
                              child: Slider(
                                thumbColor: AppColors.sliderColor,
                                activeColor: AppColors.sliderColor,
                                inactiveColor: AppColors.bgColor,
                                min: 0,
                                max: playController.max.value,
                                value: playController.value.value,
                                onChanged: (newValue) {
                                  playController.changeDurationToSeconds(newValue.toInt());
                                },
                              ),
                            ),
                            Text(
                              playController.duration.value,
                              style: CustomTextTheme.textOne.copyWith(
                                color: AppColors.bgColor,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        );
                      }),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed: () {
                              int newIndex = playController.playIndex.value - 1;
                              if (newIndex >= 0) {
                                playController.playSong(data[newIndex].uri, newIndex);
                              }
                            },
                            icon: const Icon(
                              Icons.skip_previous_rounded,
                              size: 40,
                              color: AppColors.bgColor,
                            ),
                          ),
                          Obx(() {
                            return CircleAvatar(
                              radius: 35,
                              backgroundColor: AppColors.bgColor,
                              child: Transform.scale(
                                scale: 0.9,
                                child: IconButton(
                                  onPressed: () {
                                    if (playController.isPlaying.value) {
                                      playController.audioPlayer.pause();
                                      playController.isPlaying(false);
                                    } else {
                                      playController.audioPlayer.play();
                                      playController.isPlaying(true);
                                    }
                                  },
                                  icon: playController.isPlaying.value
                                      ? const Icon(
                                    Icons.pause,
                                    size: 54,
                                    color: AppColors.whiteColor,
                                  )
                                      : const Icon(
                                    Icons.play_arrow_rounded,
                                    size: 54,
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                              ),
                            );
                          }),
                          IconButton(
                            onPressed: () {
                              int newIndex = playController.playIndex.value + 1;
                              if (newIndex < data.length) {
                                playController.playSong(data[newIndex].uri, newIndex);
                              }
                            },
                            icon: const Icon(
                              Icons.skip_next_rounded,
                              size: 40,
                              color: AppColors.bgColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
