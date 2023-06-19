class WallpaperModel {
  SrcModel? src;
  String? photographer;
  String? photographerUrl;
  String? avgColor;
  String? imageHeight;
  String? imageWidth;

  WallpaperModel(
      {this.src, this.photographer, this.photographerUrl, this.avgColor, this.imageHeight, this.imageWidth});

  factory WallpaperModel.fromMap(Map<String, dynamic> jsonData) {
    return WallpaperModel(
      src: SrcModel.fromMap(jsonData["src"]),
      photographerUrl: jsonData["photographer_url"],
      photographer: jsonData["photographer"],
      avgColor: jsonData["avg_color"],
      imageHeight: jsonData["height"].toString(),
      imageWidth: jsonData["width"].toString()
    );
  }
}

class SrcModel {
  String original;
  String portrait;

  SrcModel({required this.portrait, required this.original});

  factory SrcModel.fromMap(Map<String, dynamic> jsonData) {
    return SrcModel(
        original: jsonData["original"],
        portrait:
            jsonData["original"] + '?auto=compress&cs=tinysrgb&h=1920&w=1080');
  }
}
