import 'dart:io';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class GalleryView extends StatefulWidget {
  // Callback for notifying navigator of sign out
  final VoidCallback didSignOut;

  GalleryView({Key key, @required this.didSignOut});

  @override
  State<StatefulWidget> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  // Only interested in images for current user
  static const _accessLevel = StorageAccessLevel.private;

  // Keep reference to image urls from Storage
  List<String> _imageUrls = [];

  // Trigger query to Storage immediately
  @override
  void initState() {
    super.initState();
    _getImageUrls();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _navigationBar(),
      body: Builder(builder: (context) {
        if (_imageUrls.isEmpty) {
          return _loadingView();
        } else {
          return _imagesGridView();
        }
      }),
      floatingActionButton: _galleryPickerButton(),
    );
  }

  // Log out button
  Widget _logOutButton() {
    return IconButton(icon: Icon(Icons.logout), onPressed: _logOut);
  }

  // App navigation bar
  AppBar _navigationBar() {
    return AppBar(
      leading: _logOutButton(),
      title: Text('Gallery'),
    );
  }

  // Loading view
  Widget _loadingView() {
    return Center(
      child: Text('No photos uploaded'),
    );
  }

  // Image downloading widget
  Widget _networkImage(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }

  // Grid view of images
  Widget _imagesGridView() {
    return RefreshIndicator(
      onRefresh: () async => _getImageUrls(),
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 4, mainAxisSpacing: 4),
          itemCount: _imageUrls.length,
          itemBuilder: (context, index) => _networkImage(_imageUrls[index])),
    );
  }

  // Floating action button
  Widget _galleryPickerButton() {
    return FloatingActionButton(
        child: Icon(Icons.photo_album), onPressed: () => _pickAndUploadImage());
  }

  // Query Storage (S3 Bucket) for images
  void _getImageUrls() async {
    try {
      // Request a list of files from S3
      final listOptions = S3ListOptions(accessLevel: _accessLevel);
      final listResult = await Amplify.Storage.list(options: listOptions);

      // Make request for file urls
      final getUrlOptions = GetUrlOptions(accessLevel: _accessLevel);
      final imageUrls = await Future.wait(listResult.items.map((item) async {
        // Get the url for the image (download on demand)
        final urlResult =
            await Amplify.Storage.getUrl(key: item.key, options: getUrlOptions);
        return urlResult.url;
      }));

      // Update the state of the image urls
      setState(() => _imageUrls = imageUrls);
    } catch (e) {
      print(e);
    }
  }

  // Select photo from gallery and upload selection
  void _pickAndUploadImage() async {
    // Allow user to select a photo
    final selectedFileResult =
        await FilePicker.platform.pickFiles(allowCompression: true);

    if (selectedFileResult != null) {
      // Get the local url of the file
      final selectedImageFile = File(selectedFileResult.files.single.path);

      // Create a unique key to store image in bucket
      final key = '${DateTime.now()}.jpg';

      try {
        // Upload to user specific folder in bucket
        final uploadFileOptions = UploadFileOptions(accessLevel: _accessLevel);
        await Amplify.Storage.uploadFile(
            local: selectedImageFile, key: key, options: uploadFileOptions);

        // Get the latest list of image urls
        _getImageUrls();
      } catch (e) {
        print(e);
      }
    }
  }

  // Log out user
  void _logOut() async {
    try {
      // Sign user out with auth
      await Amplify.Auth.signOut();

      // Notify navigator of log out
      widget.didSignOut();
    } catch (e) {
      print(e);
    }
  }
}
