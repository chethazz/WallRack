import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:regwalls/model/wallpaper_model.dart';
import 'package:regwalls/views/image_view.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

Widget brandName(BuildContext context) {
  return Center(
    child: RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          fontFamily: GoogleFonts.ubuntu().fontFamily,
        ),
        children: <TextSpan>[
          TextSpan(
            text: 'Wall',
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          const TextSpan(
            text: 'Rack',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget wallpapersList({
  required List<WallpaperModel> wallpapers,
  context,
  required ScrollController scrollController,
}) {
  return Expanded(
    child: Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: ScrollConfiguration(
        behavior: const ScrollBehavior(
            androidOverscrollIndicator: AndroidOverscrollIndicator.stretch),
        child: GridView.builder(
          shrinkWrap: true,
          controller: scrollController,
          itemCount: wallpapers.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            if (index == wallpapers.length - 1) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              WallpaperModel wallpaper = wallpapers[index];
              return GridTile(
                child: Stack(
                  children: [
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(int.parse(
                            '0xFF${wallpaper.avgColor?.substring(1)}')),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: CachedNetworkImage(
                          imageUrl: wallpaper.src!.portrait,
                          fit: BoxFit.cover,
                          fadeInDuration: const Duration(milliseconds: 300),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          )),
                      child: Container(),
                      onPressed: () {
                        HapticFeedback.vibrate();
                        Future.delayed(const Duration(milliseconds: 100), () {
                          Navigator.push(
                            context,
                            SwipeablePageRoute(
                              builder: (context) => ImageView(
                                imgUrl: wallpaper.src!.portrait,
                                originalUrl: wallpaper.src!.original,
                                photographer: wallpaper.photographer!,
                                photographerUrl: wallpaper.photographerUrl!,
                                imageHeight: wallpaper.imageHeight!,
                                imageWidth: wallpaper.imageWidth!,
                              ),
                            ),
                          );
                        });
                      },
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    ),
  );
}
