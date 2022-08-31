
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter_chat_ui/src/conditional/conditional.dart';

class ImageEnlarger extends StatefulWidget {
  ImageEnlarger({required this.imageUrl});

  final List<String> imageUrl;

  @override
  ImageEnlargerState createState() => ImageEnlargerState();
}

class ImageEnlargerState extends State<ImageEnlarger> {
  PageController? pageController;

  @override
  Widget build(BuildContext context) => Dismissible(
    key: UniqueKey(),
    direction: DismissDirection.down,
    onDismissed: (direction) => Get.back<void>(),
    child: Material(
      child: Stack(
        children: [
          PhotoViewGallery.builder(
            builder: (BuildContext context, int index) =>
                PhotoViewGalleryPageOptions(
                  imageProvider: Conditional().getProvider(widget.imageUrl[0]),
                ),
            itemCount: widget.imageUrl.length,
            loadingBuilder: _imageGalleryLoadingBuilder,
            onPageChanged: (value) {},
            pageController: PageController(initialPage: 0),
            scrollPhysics: const ClampingScrollPhysics(),
          ),
          Positioned(
            right: 16,
            top: 56,
            child: CloseButton(
              color: Colors.white,
              onPressed: Get.back,
            ),
          ),
        ],
      ),
    ),
  );

  Widget _imageGalleryLoadingBuilder(
      BuildContext context,
      ImageChunkEvent? event,
      ) =>
      Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            value: event == null || event.expectedTotalBytes == null
                ? 0
                : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
          ),
        ),
      );
}
