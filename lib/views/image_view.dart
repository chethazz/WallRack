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

  const ImageView({
    super.key,
    required this.imgUrl,
    required this.originalUrl,
  });

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  bool _showContainer = false;
  bool _downloading = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _showContainer = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Hero(
              tag: widget.imgUrl,
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Image.network(
                  widget.imgUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Visibility(
                visible: _showContainer,
                child: Container(
                  padding: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                  ),
                  height: MediaQuery.of(context).size.height / 6,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        width: MediaQuery.of(context).size.width / 1.096,
                        height: 42,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white24,
                              onPrimary: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                final AnimationController controller =
                                    AnimationController(
                                  duration: const Duration(milliseconds: 300),
                                  vsync: Navigator.of(context),
                                );
                                final Animation<Offset> slideAnimation =
                                    Tween<Offset>(
                                  begin: const Offset(-0.1, 0),
                                  end: const Offset(0, 0),
                                ).animate(
                                  CurvedAnimation(
                                    parent: controller,
                                    curve: Curves.fastOutSlowIn,
                                  ),
                                );

                                controller.forward();

                                return SlideTransition(
                                  position: slideAnimation,
                                  child: AlertDialog(
                                    contentPadding: const EdgeInsets.all(16),
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width / 1.7,
                                          height: 40,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.white24,
                                                onPrimary: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10))),
                                            onPressed: () {
                                              Future.delayed(const Duration(milliseconds: 150), () {
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
                                        Container(
                                          margin: const EdgeInsets.symmetric(vertical: 10),
                                          width: MediaQuery.of(context).size.width / 1.7,
                                          height: 40,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.white24,
                                                onPrimary: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10))),
                                            onPressed: () {
                                              Future.delayed(const Duration(milliseconds: 150), () {
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
                                        Container(
                                          width: MediaQuery.of(context).size.width / 1.7,
                                          height: 40,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.white24,
                                                onPrimary: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10))),
                                            onPressed: () {
                                              Future.delayed(const Duration(milliseconds: 150), () {
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
                                  ),
                                );
                              },
                            );
                          },
                          child: const Align(
                            child: Text(
                              'Set as wallpaper',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            width: MediaQuery.of(context).size.width / 2.3,
                            height: 42,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white24,
                                  onPrimary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15))),
                              onPressed: () {
                                _save();
                              },
                              child: Align(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Align(
                                      child: Text(
                                        'High Quality',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            width: MediaQuery.of(context).size.width / 2.3,
                            height: 42,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white24,
                                  onPrimary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15))),
                              onPressed: () {
                                _saveOriginal();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Original',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _downloading
                ? Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Downloading...",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
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
    } else {
      throw Exception('Permission denied');
    }
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
    } else {
      throw Exception('Permission denied');
    }
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
        _downloading = true;
      });

      if (result['isSuccess'] == true) {
        SnackBar snackBar = const SnackBar(
          content: Text("Image Saved"),
          backgroundColor: Colors.green,
        );

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      if (mounted) {
        Navigator.pop(context);
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
          content: Text("Image Saved"),
          backgroundColor: Colors.green,
        );

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      if (mounted) {
        Navigator.pop(context);
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
