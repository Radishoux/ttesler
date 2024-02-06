import 'package:dio/dio.dart';

class ImageRepository {
  final Dio _dio = Dio();

  Future<String> fetchImageUrl(String category) async {
    final response = await _dio.get(
      'https://api.unsplash.com/photos/random/?client_id=3CZ5RGVJf20le2qZ-D2-1bzQscsne_xiCFH8A6jRT2g&query=$category',
    );

    if (response.statusCode == 200) {
      return response.data['urls']['regular'];
    } else {
      throw Exception('Failed to load image');
    }
  }
}
