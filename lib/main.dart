import 'package:flutter/material.dart';
import 'model/image_item.dart';
import 'repository/image_repository.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ImageFeedPage(),
      title: 'Infinite Scroll with Categories',
    );
  }
}

class ImageFeedPage extends StatefulWidget {
  const ImageFeedPage({Key? key}) : super(key: key);

  @override
  _ImageFeedPageState createState() => _ImageFeedPageState();
}

class _ImageFeedPageState extends State<ImageFeedPage> {
  String currentCategory = 'Tesla Model 3';
  Map<String, List<String>> imageUrls = {};
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchImages(currentCategory);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchImages(currentCategory);
      }
    });
  }

  Future<void> _fetchImages(String category) async {
    if (!imageUrls.containsKey(category)) {
      imageUrls[category] = [];
    }
    final newImageUrls = await ImageRepository().fetchImageUrls(category, 5);
    setState(() {
      imageUrls[category]!.addAll(newImageUrls);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Switch Image Category $currentCategory'),
        actions: <Widget>[
          Switch(
            value: currentCategory == 'Tesla Model 3',
            onChanged: (value) {
              setState(() {
                currentCategory = value ? 'Tesla Model 3' : 'Tesla Model Y';
                _fetchImages(currentCategory);
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: imageUrls[currentCategory]!.length,
        itemBuilder: (context, index) {
          return Image.network(imageUrls[currentCategory]![index]);
        },
      ),
    );
  }
}
