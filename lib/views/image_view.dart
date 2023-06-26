import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:open_file_plus/open_file_plus.dart';

class ImageView extends StatefulWidget {
  final String imgUrl;
  final String originalUrl;
  final String photographer;
  final String photographerUrl;
  final String imageHeight;
  final String imageWidth;

  const ImageView({
    super.key,
    required this.imgUrl,
    required this.originalUrl,
    required this.photographer,
    required this.photographerUrl,
    required this.imageHeight,
    required this.imageWidth,
  });

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  bool _downloading = false;
  bool isPressed = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            GestureDetector(
              onTapDown: (details) {
                setState(() {
                  isPressed = true;
                  HapticFeedback.vibrate();
                });
              },
              onTapUp: (details) {
                setState(() {
                  isPressed = false;
                  HapticFeedback.vibrate();
                });
              },
              child: SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: FutureBuilder(
                  future: Future.delayed(const Duration(milliseconds: 500)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return CachedNetworkImage(
                        imageUrl: widget.originalUrl,
                        fit: BoxFit.cover,
                        fadeInDuration: const Duration(seconds: 0),
                        placeholder: (context, url) =>
                            CachedNetworkImage(
                              imageUrl: widget.imgUrl,
                              fit: BoxFit.cover,
                              fadeInDuration: const Duration(seconds: 0),
                            ),
                      );
                    } else {
                      return CachedNetworkImage(
                        imageUrl: widget.imgUrl,
                        fit: BoxFit.cover,
                        fadeInDuration: const Duration(seconds: 0),
                      );
                    }
                  },
                ),
              ),
            ),
            AnimatedPositioned(
              bottom: isPressed ? -200 : 0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(children: [
                  Container(
                    padding: const EdgeInsets.only(top: 15, bottom: 10),
                    decoration: BoxDecoration(
                      color: Theme
                          .of(context)
                          .brightness == Brightness.dark
                          ? Colors.black
                          : Colors.white,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      ),
                    ),
                    height: MediaQuery
                        .of(context)
                        .size
                        .height / 5,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    alignment: Alignment.bottomCenter,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 18, right: 21),
                            alignment: Alignment.centerLeft,
                            child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 5, top: 5),
                                      alignment: Alignment.centerLeft,
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width /
                                          1.45,
                                      child: Text(
                                        widget.photographer,
                                        style: TextStyle(
                                          color: Theme
                                              .of(context)
                                              .brightness ==
                                              Brightness.dark
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                  ]),
                                  Container(
                                    margin: const EdgeInsets.only(top: 5),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor:
                                        Theme
                                            .of(context)
                                            .brightness ==
                                            Brightness.dark
                                            ? Colors.black
                                            : Colors.white,
                                        backgroundColor:
                                        Theme
                                            .of(context)
                                            .brightness ==
                                            Brightness.dark
                                            ? Colors.white
                                            : Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(15),
                                        ),
                                      ),
                                      onPressed: () async {
                                        final Uri url =
                                        Uri.parse(widget.photographerUrl);
                                        await launchUrl(
                                          url,
                                          mode: LaunchMode.externalApplication,
                                        );
                                      },
                                      child: const Text('Visit'),
                                    ),
                                  ),
                                ]),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 23, bottom: 10),
                            alignment: Alignment.centerLeft,
                            width: double.infinity,
                            child: Text(
                              'Resolution: ${widget.imageWidth}x${widget
                                  .imageHeight}',
                              style: TextStyle(
                                  color: Theme
                                      .of(context)
                                      .brightness ==
                                      Brightness.dark
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .width / 2.3,
                                  height: 42,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        foregroundColor:
                                        Theme
                                            .of(context)
                                            .brightness ==
                                            Brightness.dark
                                            ? Colors.black
                                            : Colors.white,
                                        backgroundColor:
                                        Theme
                                            .of(context)
                                            .brightness ==
                                            Brightness.dark
                                            ? Colors.white24
                                            : Colors.black38,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(15))),
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              const BorderRadius.only(
                                                  topLeft:
                                                  Radius.circular(28),
                                                  topRight:
                                                  Radius.circular(28)),
                                              color: Theme
                                                  .of(context)
                                                  .brightness ==
                                                  Brightness.dark
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                            height: MediaQuery
                                                .of(context)
                                                .size
                                                .height /
                                                2.4,
                                            padding: const EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                top: 30,
                                                bottom: 15),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  height: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .height /
                                                      18,
                                                  child: Text(
                                                      'Apply wallpaper to',
                                                      style: TextStyle(
                                                          color: Theme
                                                              .of(context)
                                                              .brightness ==
                                                              Brightness
                                                                  .dark
                                                              ? Colors.white
                                                              : Colors.black)),
                                                ),
                                                SizedBox(
                                                  height: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .height /
                                                      14,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                        foregroundColor: Theme
                                                            .of(context)
                                                            .brightness ==
                                                            Brightness.dark
                                                            ? Colors.black
                                                            : Colors.white,
                                                        backgroundColor: Theme
                                                            .of(
                                                            context)
                                                            .brightness ==
                                                            Brightness.dark
                                                            ? Colors.white24
                                                            : Colors.black38,
                                                        shape: const RoundedRectangleBorder(
                                                            borderRadius: BorderRadius
                                                                .only(
                                                                topRight:
                                                                Radius.circular(
                                                                    25),
                                                                topLeft:
                                                                Radius.circular(
                                                                    25),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                    10),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                    10)))),
                                                    onPressed: () {
                                                      Future.delayed(
                                                          const Duration(
                                                              milliseconds:
                                                              150), () {
                                                        _setLockScreen();
                                                        Navigator.of(context)
                                                            .pop();
                                                      });
                                                    },
                                                    child: const Align(
                                                      alignment:
                                                      Alignment.center,
                                                      child: Text(
                                                        'Lock screen',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .height /
                                                      14,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                        foregroundColor: Theme
                                                            .of(
                                                            context)
                                                            .brightness ==
                                                            Brightness.dark
                                                            ? Colors.black
                                                            : Colors.white,
                                                        backgroundColor: Theme
                                                            .of(
                                                            context)
                                                            .brightness ==
                                                            Brightness.dark
                                                            ? Colors.white24
                                                            : Colors.black38,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                10))),
                                                    onPressed: () {
                                                      Future.delayed(
                                                          const Duration(
                                                              milliseconds:
                                                              150), () {
                                                        _setHomeScreen();
                                                        Navigator.of(context)
                                                            .pop();
                                                      });
                                                    },
                                                    child: const Align(
                                                      alignment:
                                                      Alignment.center,
                                                      child: Text(
                                                        'Home screen',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .height /
                                                      14,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                        foregroundColor: Theme
                                                            .of(
                                                            context)
                                                            .brightness ==
                                                            Brightness.dark
                                                            ? Colors.black
                                                            : Colors.white,
                                                        backgroundColor: Theme
                                                            .of(
                                                            context)
                                                            .brightness ==
                                                            Brightness.dark
                                                            ? Colors.white24
                                                            : Colors.black38,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                10))),
                                                    onPressed: () {
                                                      Future.delayed(
                                                          const Duration(
                                                              milliseconds:
                                                              150), () {
                                                        _setBoth();
                                                        Navigator.of(context)
                                                            .pop();
                                                      });
                                                    },
                                                    child: const Align(
                                                      alignment:
                                                      Alignment.center,
                                                      child: Text(
                                                        'Both',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .height /
                                                      14,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                        foregroundColor: Theme
                                                            .of(
                                                            context)
                                                            .brightness ==
                                                            Brightness.dark
                                                            ? Colors.black
                                                            : Colors.white,
                                                        backgroundColor:
                                                        Theme
                                                            .of(context)
                                                            .brightness ==
                                                            Brightness
                                                                .dark
                                                            ? Colors.white
                                                            : Colors.black,
                                                        shape: const RoundedRectangleBorder(
                                                            borderRadius: BorderRadius
                                                                .only(
                                                                bottomLeft:
                                                                Radius.circular(
                                                                    24),
                                                                bottomRight:
                                                                Radius.circular(
                                                                    24),
                                                                topLeft: Radius
                                                                    .circular(
                                                                    10),
                                                                topRight: Radius
                                                                    .circular(
                                                                    10)))),
                                                    onPressed: () {
                                                      Future.delayed(
                                                          const Duration(
                                                              milliseconds:
                                                              150), () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        _openWith();
                                                      });
                                                    },
                                                    child: Align(
                                                      alignment:
                                                      Alignment.center,
                                                      child: Text(
                                                        'Open with',
                                                        style: TextStyle(
                                                            color: Theme
                                                                .of(context)
                                                                .brightness ==
                                                                Brightness
                                                                    .light
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: const Text(
                                      'Set as wallpaper',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .width / 2.3,
                                  height: 42,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        foregroundColor:
                                        Theme
                                            .of(context)
                                            .brightness ==
                                            Brightness.dark
                                            ? Colors.black
                                            : Colors.white,
                                        backgroundColor:
                                        Theme
                                            .of(context)
                                            .brightness ==
                                            Brightness.dark
                                            ? Colors.white24
                                            : Colors.black38,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(15))),
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              const BorderRadius.only(
                                                  topLeft:
                                                  Radius.circular(28),
                                                  topRight:
                                                  Radius.circular(28)),
                                              color: Theme
                                                  .of(context)
                                                  .brightness ==
                                                  Brightness.dark
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                            height: MediaQuery
                                                .of(context)
                                                .size
                                                .height /
                                                2.95,
                                            padding: const EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                top: 30,
                                                bottom: 15),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  height: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .height /
                                                      18,
                                                  child: Text(
                                                    'Choose quality',
                                                    style: TextStyle(
                                                        color: Theme
                                                            .of(context)
                                                            .brightness ==
                                                            Brightness.dark
                                                            ? Colors.white
                                                            : Colors.black),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .height /
                                                      14,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                        foregroundColor: Theme
                                                            .of(context)
                                                            .brightness ==
                                                            Brightness.dark
                                                            ? Colors.black
                                                            : Colors.white,
                                                        backgroundColor: Theme
                                                            .of(
                                                            context)
                                                            .brightness ==
                                                            Brightness.dark
                                                            ? Colors.white24
                                                            : Colors.black38,
                                                        shape: const RoundedRectangleBorder(
                                                            borderRadius: BorderRadius
                                                                .only(
                                                                topRight:
                                                                Radius.circular(
                                                                    25),
                                                                topLeft:
                                                                Radius.circular(
                                                                    25),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                    10),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                    10)))),
                                                    onPressed: () {
                                                      Future.delayed(
                                                          const Duration(
                                                              milliseconds:
                                                              150), () {
                                                        _save();
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                    child: const Align(
                                                      alignment:
                                                      Alignment.center,
                                                      child: Text(
                                                        'High Quality',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .height /
                                                      14,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                        foregroundColor: Theme
                                                            .of(context)
                                                            .brightness ==
                                                            Brightness.dark
                                                            ? Colors.black
                                                            : Colors.white,
                                                        backgroundColor: Theme
                                                            .of(
                                                            context)
                                                            .brightness ==
                                                            Brightness.dark
                                                            ? Colors.white24
                                                            : Colors.black38,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius
                                                                .circular(
                                                                10))),
                                                    onPressed: () {
                                                      Future.delayed(
                                                          const Duration(
                                                              milliseconds:
                                                              150), () {
                                                        Navigator.pop(context);
                                                        _saveOriginal();
                                                      });
                                                    },
                                                    child: const Align(
                                                      alignment:
                                                      Alignment.center,
                                                      child: Text(
                                                        'Original Quality',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .height /
                                                      14,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                        foregroundColor: Theme
                                                            .of(context)
                                                            .brightness ==
                                                            Brightness.dark
                                                            ? Colors.black
                                                            : Colors.white,
                                                        backgroundColor: Theme
                                                            .of(
                                                            context)
                                                            .brightness ==
                                                            Brightness.dark
                                                            ? Colors.white
                                                            : Colors.black,
                                                        shape: const RoundedRectangleBorder(
                                                            borderRadius: BorderRadius
                                                                .only(
                                                                topRight:
                                                                Radius.circular(
                                                                    10),
                                                                topLeft:
                                                                Radius.circular(
                                                                    10),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                    25),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                    25)))),
                                                    onPressed: () {
                                                      Future.delayed(
                                                          const Duration(
                                                              milliseconds:
                                                              150), () {
                                                        Navigator.pop(context);
                                                        _shareWall();
                                                      });
                                                    },
                                                    child: Align(
                                                      alignment:
                                                      Alignment.center,
                                                      child: Text(
                                                        'Share',
                                                        style: TextStyle(
                                                            color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: const Text(
                                      'Download',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ),
                ]),
              ),
            ),
            _downloading
                ? Container(
              alignment: Alignment.bottomCenter,
              child: const LinearProgressIndicator(
                backgroundColor: Colors.black,
                color: Colors.white,
              ),
            )
                : Container(),
          ],
        ),
      ),
    );
  }

  void _openWith() async {
    setState(() {
      _downloading = true;
    });

    String imageUrl = widget.originalUrl;
    var status = await Permission.photos.request();
    if (status.isGranted) {
      var file = await DefaultCacheManager().getSingleFile(imageUrl);

      String path = file.path;

      OpenFile.open(path);

      HapticFeedback.vibrate();

      setState(() {
        _downloading = false;
      });
    } else {
      throw Exception('Permission denied');
    }
  }

  void _shareWall() async {
    setState(() {
      _downloading = true;
    });

    String imageUrl = widget.originalUrl;
    var status = await Permission.photos.request();
    if (status.isGranted) {
      var file = await DefaultCacheManager().getSingleFile(imageUrl);

      String path = file.path;

      await Share.shareFiles([path]);

      HapticFeedback.vibrate();

      setState(() {
        _downloading = false;
      });
    } else {
      throw Exception('Permission denied');
    }
  }

  Future<void> _setLockScreen() async {
    setState(() {
      _downloading = true;
    });

    String imageUrl = widget.imgUrl;
    var status = await Permission.photos.request();
    if (status.isGranted) {
      var file = await DefaultCacheManager().getSingleFile(imageUrl);
      String path = file.path;
      int location = WallpaperManager.LOCK_SCREEN;
      bool result = await WallpaperManager.setWallpaperFromFile(path, location);

      if (result) {
        SnackBar snackBar = const SnackBar(
          content: Text(
            "Set Successfully",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      setState(() {
        _downloading = false;
      });
    } else {
      throw Exception('Permission denied');
    }
  }

  Future<void> _setHomeScreen() async {
    setState(() {
      _downloading = true;
    });

    String imageUrl = widget.imgUrl;
    var status = await Permission.photos.request();
    if (status.isGranted) {
      var file = await DefaultCacheManager().getSingleFile(imageUrl);
      String path = file.path;
      int location = WallpaperManager.HOME_SCREEN;
      bool result = await WallpaperManager.setWallpaperFromFile(path, location);
      if (result) {
        SnackBar snackBar = const SnackBar(
          content: Text(
            "Set Successfully",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      setState(() {
        _downloading = false;
      });
    } else {
      throw Exception('Permission denied');
    }
  }

  Future<void> _setBoth() async {
    setState(() {
      _downloading = true;
    });

    String imageUrl = widget.imgUrl;
    var status = await Permission.photos.request();
    if (status.isGranted) {
      var file = await DefaultCacheManager().getSingleFile(imageUrl);
      String path = file.path;
      int location = WallpaperManager.BOTH_SCREEN;
      bool result = await WallpaperManager.setWallpaperFromFile(path, location);
      if (result) {
        SnackBar snackBar = const SnackBar(
          content: Text(
            "Set Successfully",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      setState(() {
        _downloading = false;
      });
    } else {
      throw Exception('Permission denied');
    }
  }

  _save() async {
    setState(() {
      _downloading = true;
    });
    var permissionStatus = await _askPermission();

    if (permissionStatus) {
      var downloadUrl = widget.imgUrl;
      var response = await Dio()
          .get(downloadUrl, options: Options(responseType: ResponseType.bytes));
      final result =
      await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));

      setState(() {
        _downloading = false;
      });

      if (result['isSuccess'] == true) {
        SnackBar snackBar = const SnackBar(
          content: Text(
            "Image Saved",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        );
        if (!mounted) return;
        HapticFeedback.vibrate();
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  _saveOriginal() async {
    setState(() {
      _downloading = true;
    });
    var permissionStatus = await _askPermission();

    if (permissionStatus) {
      var downloadUrl = widget.originalUrl;
      var response = await Dio().get(
        downloadUrl,
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );
      final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
      );

      setState(() {
        _downloading = false;
      });

      if (result['isSuccess'] == true) {
        SnackBar snackBar = const SnackBar(
          content: Text(
            "Image Saved",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        );

        if (!mounted) return;
        HapticFeedback.vibrate();
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  _askPermission() async {
    if (await Permission.photos
        .request()
        .isGranted ||
        await Permission.storage
            .request()
            .isGranted) {
      return true;
    } else {
      openAppSettings();
    }
  }
}
