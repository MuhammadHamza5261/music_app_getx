import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_music_app/const/colors.dart';
import 'package:getx_music_app/const/text_style.dart';
import 'package:getx_music_app/controller/play_controller.dart';
import 'package:getx_music_app/screeens/player_screen.dart';
import 'package:getx_music_app/singleton.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../config/navigation.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  //  Initialize the controller

  PlayController playController = Get.put(PlayController());


  final userName =  Singleton.instance.userName ?? "";

  @override
  Widget build(BuildContext context) {

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.bgDarkColor,

      appBar: AppBar(
        title: Text("Audio Players"),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView( // Using ListView to ensure the drawer is scrollable if content overflows
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.black, // Set header background color
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const CircleAvatar(
                      radius: 30,
                      child: Icon(
                        Icons.person,
                        size: 30,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Hello $userName",
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white, // Text color for better contrast with background
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20,top: 20),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      NavigationHelper.navigateToScreen(context, HomeScreen());
                    },
                    child: Row(
                      children: [
                        Icon(Icons.home_outlined,size: 30,),
                        SizedBox(
                          width: 20,
                        ),
                        Text("Home",style: TextStyle(
                          fontSize: 18
                        ),),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Icon(Icons.logout,size: 30,),
                      SizedBox(
                        width: 20,
                      ),
                      Text("Logout",style: TextStyle(
                        fontSize: 18
                      ),),
                    ],
                  ),
                ],
              ),
            ),

          ],
        ),
      ),


      body: FutureBuilder<List<SongModel>>(

        future: playController.audioQuery.querySongs(
          ignoreCase: true,
          orderType: OrderType.ASC_OR_SMALLER,
          sortType: null,
          uriType: UriType.EXTERNAL,
        ),

        builder: (BuildContext context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          }
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No Songs found',
                style: CustomTextTheme.textOne,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: CustomTextTheme.textOne,
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Obx(() => ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      tileColor: AppColors.bgColor,
                      title: Text(
                        "${snapshot.data?[index].displayNameWOExt}",
                        style: CustomTextTheme.textOne.copyWith(fontSize: 15),
                      ),
                      subtitle: Text(
                        '${snapshot.data?[index].artist}',
                        style: CustomTextTheme.textOne.copyWith(fontSize: 12),
                      ),
                      leading: QueryArtworkWidget(
                        id: snapshot.data![index].id,
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget: const Icon(
                          Icons.music_note,
                          color: AppColors.whiteColor,
                          size: 32,
                        ),
                      ),
                      trailing: playController.playIndex.value == index && playController.isPlaying.value ?
                      const Icon(
                        Icons.play_arrow,
                        color: AppColors.whiteColor,
                        size: 16,
                      ): null,
                      onTap: (){
                        playController.playSong(snapshot.data![index].uri,index);
                        Get.to(
                            PlayerScreen(data: snapshot.data!,));

                      },
                    ),)
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
