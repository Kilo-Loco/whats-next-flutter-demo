import 'package:flutter/material.dart';

class GalleryView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  List<dynamic> _photos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
      ),
      body: Builder(builder: (context) {
        if (_photos.isEmpty) {
          return Center(
            child: Text('No photos uploaded'),
          );
        } else {
          return GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Icon(Icons.photo),
                );
              });
        }
      }),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.photo_album),
          onPressed: () {
            showModalBottomSheet(context: context, builder: (context) {});
          }),
    );
  }
}
