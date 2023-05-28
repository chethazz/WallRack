import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:regwalls/data/data.dart';
import 'package:regwalls/model/wallpaper_mode.dart';
import 'package:regwalls/widget/widget.dart';

class CategoryImage extends StatefulWidget {
  final String categoryName;

  const CategoryImage({
    super.key,
    required this.categoryName,
  });

  @override
  State<CategoryImage> createState() => _CategoryImageState();
}

class _CategoryImageState extends State<CategoryImage> {
  final ScrollController _scrollController = ScrollController();
  List<WallpaperModel> wallpapers = [];

  getCategoryWallpapers(String query) async {
    var response = await http.get(
      Uri.parse(
          'https://api.pexels.com/v1/search?query=$query&per_page=20&page=1'),
      headers: {"Authorization": apiKey},
    );

    if (kDebugMode) {
      print(response.body.toString());
    }

    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData["photos"].forEach((element) {
      if (kDebugMode) {
        print(element);
      }
      WallpaperModel wallpaperModel = WallpaperModel();
      wallpaperModel = WallpaperModel.fromMap(element);
      wallpapers.add(wallpaperModel);
    });

    setState(() {});
  }

  void fetchMoreCategoryWallpapers(String query) async {
    var response = await http.get(
      Uri.parse(
          'https://api.pexels.com/v1/search?query=$query&per_page=20&page=${wallpapers.length ~/ 20 + 1}'),
      headers: {"Authorization": apiKey},
    );

    if (kDebugMode) {
      print(response.body.toString());
    }

    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData["photos"].forEach((element) {
      if (kDebugMode) {
        print(element);
      }
      WallpaperModel wallpaperModel = WallpaperModel();
      wallpaperModel = WallpaperModel.fromMap(element);
      wallpapers.add(wallpaperModel);
    });

    setState(() {});
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // User has scrolled to the end of the list, fetch more wallpapers
      fetchMoreCategoryWallpapers(widget.categoryName);
    }
  }

  @override
  void initState() {
    getCategoryWallpapers(widget.categoryName);
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          title: Container(
              height: 50,
              alignment: Alignment.bottomCenter,
              child: Text(
                widget.categoryName.substring(0, 1).toUpperCase() + widget.categoryName.substring(1),
                style: const TextStyle(color: Colors.white, fontSize: 26),
              )),
          elevation: 0.0),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                    color: const Color(0xffE9E9E9),
                    borderRadius: BorderRadius.circular(15)),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                margin: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
            wallpapersList(
                wallpapers: wallpapers,
                context: context,
                scrollController: _scrollController),
          ],
        ),
      ),
    );
  }
}
