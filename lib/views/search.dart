import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:regwalls/data/data.dart';
import 'package:regwalls/model/wallpaper_mode.dart';
import 'package:regwalls/widget/widget.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class Search extends StatefulWidget {
  final String searchQuery;

  const Search({
    super.key,
    required this.searchQuery,
  });

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<WallpaperModel> wallpapers = [];
  final ScrollController _scrollController = ScrollController();

  TextEditingController searchController = TextEditingController();

  getSearchWallpapers(String query) async {
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

  void fetchMoreSearchWallpapers(String query) async {
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
      fetchMoreSearchWallpapers(widget.searchQuery);
    }
  }

  @override
  void initState() {
    getSearchWallpapers(widget.searchQuery);
    _scrollController.addListener(_scrollListener);
    super.initState();
    searchController.text = widget.searchQuery;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          title: brandName(),
          elevation: 0.0),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search',
                          suffixIcon: GestureDetector(
                            onTap: () {
                              if (kDebugMode) {
                                print("Search ${searchController.text}");
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Search(
                                    searchQuery: searchController.text,
                                  ),
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
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
