import 'package:dio/dio.dart';

class ImageRepository {
  final Dio _dio = Dio();

  Future<List<String>> fetchImageUrls(String category, int count) async {
    final response = await _dio.get(
      'https://api.unsplash.com/photos/random/?client_id=3CZ5RGVJf20le2qZ-D2-1bzQscsne_xiCFH8A6jRT2g&query=$category&count=$count',
    );
    if (response.statusCode == 200) {
      return response.data
          .map((item) => item['urls']['regular'])
          .toList()
          .cast<String>();
    } else {
      throw Exception('Failed to load images');
    }
  }
}
