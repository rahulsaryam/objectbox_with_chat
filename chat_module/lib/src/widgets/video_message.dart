import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

/// A class that represents image message widget. Supports different
/// aspect ratios, renders blurred image as a background which is visible
/// if the image is narrow, renders image in form of a file if aspect
/// ratio is very small or very big.
class VideoMessage extends StatefulWidget {
  /// Creates an image message widget based on [types.VideoMessage]
  const VideoMessage({
    Key? key,
    required this.message,
    required this.messageWidth,
  }) : super(key: key);

  /// [types.VideoMessage]
  final types.VideoMessage message;

  /// Maximum message width
  final int messageWidth;

  @override
  _VideoMessageState createState() => _VideoMessageState();
}

/// [VideoMessage] widget state
class _VideoMessageState extends State<VideoMessage> {
  @override
  // ignore: prefer_expression_function_bodies
  Widget build(BuildContext context) {
    // final _user = InheritedUser.of(context).user;

    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Image.memory(
              base64Decode('${widget.message.thumbnail!}'),
              fit: BoxFit.cover,
              width: 170,
              height: 120,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.black45,
              border: Border.all(
                color: Colors.black45,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(50))),
          child: const Icon(
            Icons.play_arrow_rounded,
            color: Colors.white,
            size: 50,
          ),
        )
      ],
    );
  }
}
