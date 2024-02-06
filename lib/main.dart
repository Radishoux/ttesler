import 'package:flutter/material.dart';
import 'repository/image_repository.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ImageFeedPage(),
      title: 'Infinite Scroll with Categories',
      debugShowCheckedModeBanner: false,
    );
  }
}

class ImageFeedPage extends StatefulWidget {
  const ImageFeedPage({super.key});

  @override
  _ImageFeedPageState createState() => _ImageFeedPageState();
}

class _ImageFeedPageState extends State<ImageFeedPage> {
  String currentCategory = 'Tesla Model Y';
  Map<String, List<String>> imageUrls = {};
  Map<String, int> currentPage = {
    'Tesla Model 3': 1,
    'Tesla Model Y': 1,
  };
  final ScrollController _scrollController = ScrollController();
  bool isGridView = false;

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
    final newImageUrls = await ImageRepository()
        .fetchImageUrls(category, currentPage[category]!, 9);
    setState(() {
      imageUrls[category]!.addAll(newImageUrls);
      currentPage[category] = currentPage[category]! + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                const Text('Tesla Model Y'),
                Switch(
                  value: currentCategory == 'Tesla Model 3',
                  onChanged: (value) {
                    setState(() {
                      currentCategory =
                          value ? 'Tesla Model 3' : 'Tesla Model Y';
                      if (currentPage[currentCategory] == 1) {
                        _fetchImages(currentCategory);
                      }
                      _scrollController
                          .jumpTo(_scrollController.position.minScrollExtent);
                    });
                  },
                ),
                const Text('Tesla Model 3'),
              ],
            ),
            Row(
              children: <Widget>[
                const Text('List'),
                Switch(
                  value: isGridView,
                  onChanged: (value) {
                    setState(() {
                      isGridView = value;
                    });
                  },
                ),
                const Text('Grid'),
              ],
            ),
          ],
        ),
      ),
      body: isGridView
          ? GridView.builder(
              controller: _scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio:
                    1.0, // Adjust this value to change the aspect ratio.
              ),
              itemCount: imageUrls[currentCategory]!.length,
              itemBuilder: (context, index) {
                return AspectRatio(
                  aspectRatio:
                      1.0, // Forces the children to have the same height.
                  child: Image.network(
                    imageUrls[currentCategory]![index],
                    fit: BoxFit
                        .cover, // Ensures the entire image is shown, possibly by clipping.
                  ),
                );
              },
            )
          : ListView.builder(
              controller: _scrollController,
              itemCount: imageUrls[currentCategory]!.length,
              itemBuilder: (context, index) {
                return Image.network(
                  imageUrls[currentCategory]![index],
                  fit: BoxFit.fitWidth,
                );
              },
            ),
      backgroundColor: Colors.grey[500],
    );
  }
}
