import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';

class ImageView extends StatefulWidget {
  final String imgUrl;
  final String originalUrl;
  final String photographer;
  final String photographerUrl;

  const ImageView({
    super.key,
    required this.imgUrl,
    required this.originalUrl,
    required this.photographer,
    required this.photographerUrl,
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
                });
              },
              onTapUp: (details) {
                setState(() {
                  isPressed = false;
                });
              },
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: FutureBuilder(
                  future: Future.delayed(const Duration(milliseconds: 500)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return CachedNetworkImage(
                        imageUrl: widget.originalUrl,
                        fit: BoxFit.cover,
                        fadeInDuration: const Duration(seconds: 0),
                        placeholder: (context, url) => CachedNetworkImage(
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
              bottom: isPressed ? -170 : 0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black
                        : Colors.white,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                  ),
                  height: MediaQuery.of(context).size.height / 5.4,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.bottomCenter,
                  child: Column(children: [
                    Container(
                      padding: const EdgeInsets.only(left: 18, right: 21),
                      alignment: Alignment.centerLeft,
                      height: 60,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(children: [
                              Container(
                                margin: const EdgeInsets.only(left: 5, top: 12),
                                alignment: Alignment.centerLeft,
                                width: MediaQuery.of(context).size.width / 1.45,
                                child: Text(
                                  'By ${widget.photographer}',
                                  style: TextStyle(
                                    color: Theme.of(context).brightness ==
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
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.black
                                    : Colors.white,
                                backgroundColor: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
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
                          ]),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      margin: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2.3,
                            height: 42,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  foregroundColor:
                                      Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.black
                                          : Colors.white,
                                  backgroundColor:
                                      Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white24
                                          : Colors.black38,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15))),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(28),
                                            topRight: Radius.circular(28)),
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                      height:
                                          MediaQuery.of(context).size.height /
                                              4,
                                      padding: const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 24,
                                          bottom: 15),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                16,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  foregroundColor:
                                                      Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? Colors.black
                                                          : Colors.white,
                                                  backgroundColor:
                                                      Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? Colors.white24
                                                          : Colors.black38,
                                                  shape: const RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  25),
                                                          topLeft:
                                                              Radius.circular(25),
                                                          bottomLeft: Radius.circular(5),
                                                          bottomRight: Radius.circular(5)))),
                                              onPressed: () {
                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 150), () {
                                                  _setLockScreen();
                                                  Navigator.of(context).pop();
                                                });
                                              },
                                              child: const Align(
                                                alignment: Alignment.center,
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
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                16,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  foregroundColor:
                                                      Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? Colors.black
                                                          : Colors.white,
                                                  backgroundColor:
                                                      Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? Colors.white24
                                                          : Colors.black38,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10))),
                                              onPressed: () {
                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 150), () {
                                                  _setHomeScreen();
                                                  Navigator.of(context).pop();
                                                });
                                              },
                                              child: const Align(
                                                alignment: Alignment.center,
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
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                16,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  foregroundColor:
                                                      Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? Colors.black
                                                          : Colors.white,
                                                  backgroundColor:
                                                      Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? Colors.white24
                                                          : Colors.black38,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10))),
                                              onPressed: () {
                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 150), () {
                                                  _setBoth();
                                                  Navigator.of(context).pop();
                                                });
                                              },
                                              child: const Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Both',
                                                  style: TextStyle(
                                                      color: Colors.white,
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
                            width: MediaQuery.of(context).size.width / 2.3,
                            height: 42,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  foregroundColor:
                                      Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.black
                                          : Colors.white,
                                  backgroundColor:
                                      Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white24
                                          : Colors.black38,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15))),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(28),
                                            topRight: Radius.circular(28)),
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                      height:
                                          MediaQuery.of(context).size.height /
                                              5,
                                      padding: const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 24,
                                          bottom: 15),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                14,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  foregroundColor:
                                                      Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? Colors.black
                                                          : Colors.white,
                                                  backgroundColor:
                                                      Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? Colors.white24
                                                          : Colors.black38,
                                                  shape: const RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  25),
                                                          topLeft:
                                                              Radius.circular(25),
                                                          bottomLeft: Radius.circular(5),
                                                          bottomRight: Radius.circular(5)))),
                                              onPressed: () {
                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 150), () {
                                                  _save();
                                                  Navigator.pop(context);
                                                });
                                              },
                                              child: const Align(
                                                alignment: Alignment.center,
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
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                14,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  foregroundColor:
                                                      Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? Colors.black
                                                          : Colors.white,
                                                  backgroundColor:
                                                      Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? Colors.white24
                                                          : Colors.black38,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10))),
                                              onPressed: () {
                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 150), () {
                                                  _saveOriginal();
                                                  Navigator.pop(context);
                                                });
                                              },
                                              child: const Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Original Quality',
                                                  style: TextStyle(
                                                      color: Colors.white,
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

  _setLockScreen() async {
    setState(() {
      _downloading = true;
    });

    String imageUrl = widget.originalUrl;
    var status = await Permission.photos.request();
    if (status.isGranted) {
      var file = await DefaultCacheManager().getSingleFile(imageUrl);
      await WallpaperManager.setWallpaperFromFile(
          file.path, WallpaperManager.LOCK_SCREEN);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Set successfully', style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    } else {
      throw Exception('Permission denied');
    }
    setState(() {
      _downloading = false;
    });
  }

  _setHomeScreen() async {
    setState(() {
      _downloading = true;
    });

    String imageUrl = widget.originalUrl;
    var status = await Permission.photos.request();
    if (status.isGranted) {
      var file = await DefaultCacheManager().getSingleFile(imageUrl);
      await WallpaperManager.setWallpaperFromFile(
          file.path, WallpaperManager.HOME_SCREEN);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Set successfully', style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    } else {
      throw Exception('Permission denied');
    }
    setState(() {
      _downloading = false;
    });
  }

  _setBoth() async {
    setState(() {
      _downloading = true;
    });

    String imageUrl = widget.originalUrl;
    var status = await Permission.photos.request();
    if (status.isGranted) {
      var file = await DefaultCacheManager().getSingleFile(imageUrl);
      await WallpaperManager.setWallpaperFromFile(
          file.path, WallpaperManager.BOTH_SCREEN);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Set successfully', style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    } else {
      throw Exception('Permission denied');
    }
    setState(() {
      _downloading = false;
    });
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
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  _askPermission() async {
    if (await Permission.photos.request().isGranted ||
        await Permission.storage.request().isGranted) {
      return true;
    } else {
      openAppSettings();
    }
  }
}
