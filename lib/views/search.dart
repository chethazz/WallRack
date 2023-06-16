import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:regwalls/data/data.dart';
import 'package:regwalls/model/wallpaper_model.dart';
import 'package:regwalls/widget/widget.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

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
          'https://api.pexels.com/v1/search?query=$query&per_page=24&page=1'),
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
          'https://api.pexels.com/v1/search?query=$query&per_page=24&page=${wallpapers.length + 1}'),
      headers: {"Authorization": apiKey},
    );

    if (kDebugMode) {
      print(response.body.toString());
    }

    Map<String, dynamic> jsonData = jsonDecode(response.body);
    List<WallpaperModel> newWallpapers = [];
    jsonData["photos"].forEach((element) {
      WallpaperModel wallpaperModel = WallpaperModel();
      wallpaperModel = WallpaperModel.fromMap(element);
      newWallpapers.add(wallpaperModel);
    });

    setState(() {
      wallpapers.addAll(newWallpapers);
    });
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
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.white,
          title: brandName(context),
          elevation: 0.0,
          scrolledUnderElevation: 0,
      ),
      body: Container(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
        child: Column(
          children: [
            SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black12,
                    borderRadius: BorderRadius.circular(18)),
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
                        textInputAction: TextInputAction.search,
                        onSubmitted: (value) {
                          if (kDebugMode) {
                            print("Search $value");
                          }
                          Navigator.push(
                            context,
                            SwipeablePageRoute(
                              builder: (context) => Search(
                                searchQuery: searchController.text,
                              ),
                            ),
                          );
                        },
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
