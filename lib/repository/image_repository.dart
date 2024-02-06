import 'package:dio/dio.dart';

class ImageRepository {
  final Dio _dio = Dio();

  Future<List<String>> fetchImageUrls(
      String category, int currentPage, int count) async {
    final response = await _dio.get(
      'https://api.unsplash.com/search/photos?client_id=3CZ5RGVJf20le2qZ-D2-1bzQscsne_xiCFH8A6jRT2g&query=$category&per_page=$count&page=$currentPage',
    );

    if (response.statusCode == 200) {
      return response.data['results']
          .map((item) => item['urls']['regular'])
          .toList()
          .cast<String>();
    } else {
      throw Exception('Failed to load images');
    }
  }
}
