import 'package:flutter/material.dart';
import 'model/image_item.dart';
import 'repository/image_repository.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key});

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
  String? currentImageUrl;

  @override
  void initState() {
    super.initState();
    _fetchImage();
  }

  Future<void> _fetchImage() async {
    final imageUrl = await ImageRepository().fetchImageUrl(currentCategory);
    setState(() {
      currentImageUrl = imageUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Switch Image Category'),
        actions: <Widget>[
          Switch(
            value: currentCategory == 'Tesla Model 3',
            onChanged: (value) {
              setState(() {
                currentCategory = value ? 'Tesla Model 3' : 'Tesla Model Y';
                _fetchImage(); // Fetch new image based on the switch
              });
            },
          ),
        ],
      ),
      body: Center(
        child: currentImageUrl == null
            ? const CircularProgressIndicator() // Show loading indicator while the image is null
            : Image.network(currentImageUrl!),
      ),
    );
  }
}
