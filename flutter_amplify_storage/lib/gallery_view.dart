import 'dart:io';

import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class GalleryView extends StatefulWidget {
  final VoidCallback didSignOut;

  GalleryView({Key key, @required this.didSignOut});

  @override
  State<StatefulWidget> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  List<String> _imageUrls = [];

  @override
  void initState() {
    super.initState();
    _getImageUrls();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.logout), onPressed: _logOut),
        title: Text('Gallery'),
      ),
      body: Builder(builder: (context) {
        if (_imageUrls.isEmpty) {
          return Center(
            child: Text('No photos uploaded'),
          );
        } else {
          return RefreshIndicator(
            onRefresh: () async => _getImageUrls(),
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, crossAxisSpacing: 4, mainAxisSpacing: 4),
                itemCount: _imageUrls.length,
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                    imageUrl: _imageUrls[index],
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  );
                }),
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.photo_album),
          onPressed: () => _pickAndUploadImage()),
    );
  }

  void _getImageUrls() async {
    try {
      final listOptions =
          S3ListOptions(accessLevel: StorageAccessLevel.private);
      final listResult = await Amplify.Storage.list(options: listOptions);
      print(listResult.items);
      final getUrlOptions =
          GetUrlOptions(accessLevel: StorageAccessLevel.private);
      final imageUrls = await Future.wait(listResult.items.map((item) async {
        final urlResult =
            await Amplify.Storage.getUrl(key: item.key, options: getUrlOptions);
        return urlResult.url;
      }));

      setState(() {
        _imageUrls = imageUrls;
      });
    } catch (e) {
      print(e);
    }
  }

  void _pickAndUploadImage() async {
    final selectedFileResult =
        await FilePicker.platform.pickFiles(allowCompression: true);

    print(selectedFileResult.files);

    if (selectedFileResult != null) {
      final selectedImageFile = File(selectedFileResult.files.single.path);
      final key = '${DateTime.now()}.jpg';

      try {
        final uploadFileOptions =
            UploadFileOptions(accessLevel: StorageAccessLevel.private);
        await Amplify.Storage.uploadFile(
            local: selectedImageFile, key: key, options: uploadFileOptions);
        print('image uploaded');
        _getImageUrls();
      } catch (e) {
        print(e);
      }
    }
  }

  void _logOut() async {
    try {
      await Amplify.Auth.signOut();
      widget.didSignOut();
    } catch (e) {
      print(e);
    }
  }
}
