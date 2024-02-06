class ImageItem {
  final String url;

  ImageItem({required this.url});

  factory ImageItem.fromJson(Map<String, dynamic> json) {
    return ImageItem(
      url: json['url'],
    );
  }
}
