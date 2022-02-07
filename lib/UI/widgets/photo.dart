import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class Photo extends StatelessWidget {
  final String photoLink;

  const Photo(this.photoLink);

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      photoLink,
      fit: BoxFit.cover,
      cache: true,
      enableSlideOutPage: true,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return Center(
              child: CircularProgressIndicator(),
            );
          case LoadState.completed:
            return null;
          case LoadState.failed:
            return GestureDetector(
              child: Center(
                child: Text("Reload"),
              ),
              onTap: () {
                state.reLoadImage();
              },
            );
        }
      },
    );
  }
}
