import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/src/widgets/inherited_chat_theme.dart';
import 'package:intl/intl.dart';

// import 'package:flutter_link_previewer/flutter_link_previewer.dart'
//     show LinkPreview;
const regexLink =
    r'((http|ftp|https):\/\/)?([\w_-]+(?:(?:\.[\w_-]+)+))([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?';

/// A class that represents text message widget with optional link preview
class TextMessage extends StatelessWidget {
  /// Creates a text message widget from a [types.TextMessage] class
  const TextMessage({
    Key? key,
    required this.message,
    this.onPreviewDataFetched,
    required this.usePreviewData,
    required this.showName,
  }) : super(key: key);

  /// [types.TextMessage]
  final types.TextMessage message;

  final void Function(types.TextMessage, types.PreviewData)?
      onPreviewDataFetched;

  /// Show user name for the received message. Useful for a group chat.
  final bool showName;

  /// Enables link (URL) preview
  final bool usePreviewData;

  // void _onPreviewDataFetched(types.PreviewData previewData) {
  //   if (message.previewData == null) {
  //     onPreviewDataFetched?.call(message, previewData);
  //   }
  // }
  // Widget _linkPreview(
  //   types.User user,
  //   double width,
  //   BuildContext context,
  // ) {
  //   final bodyTextStyle = user.id == message.author.id
  //       ? InheritedChatTheme.of(context).theme.sentMessageBodyTextStyle
  //       : InheritedChatTheme.of(context).theme.receivedMessageBodyTextStyle;
  //   final linkDescriptionTextStyle = user.id == message.author.id
  //       ? InheritedChatTheme.of(context)
  //           .theme
  //           .sentMessageLinkDescriptionTextStyle
  //       : InheritedChatTheme.of(context)
  //           .theme
  //           .receivedMessageLinkDescriptionTextStyle;
  //   final linkTitleTextStyle = user.id == message.author.id
  //       ? InheritedChatTheme.of(context).theme.sentMessageLinkTitleTextStyle
  //       : InheritedChatTheme.of(context)
  //           .theme
  //           .receivedMessageLinkTitleTextStyle;
  //
  //   final color = getUserAvatarNameColor(message.author,
  //       InheritedChatTheme.of(context).theme.userAvatarNameColors);
  //   final name = getUserName(message.author);
  //   return LinkPreview(
  //     enableAnimation: true,
  //     header: showName ? name : null,
  //     headerStyle: InheritedChatTheme.of(context)
  //         .theme
  //         .userNameTextStyle
  //         .copyWith(color: color),
  //     linkStyle: bodyTextStyle,
  //     metadataTextStyle: linkDescriptionTextStyle,
  //     metadataTitleStyle: linkTitleTextStyle,
  //     onPreviewDataFetched: _onPreviewDataFetched,
  //     padding: EdgeInsets.symmetric(
  //       horizontal:
  //           InheritedChatTheme.of(context).theme.messageInsetsHorizontal,
  //       vertical: InheritedChatTheme.of(context).theme.messageInsetsVertical,
  //     ),
  //     previewData: message.previewData,
  //     text: message.text,
  //     textStyle: bodyTextStyle,
  //     width: width,
  //   );
  // }

  Widget _textWidgetBuilder(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // if (showName)
          //   Padding(
          //     padding: const EdgeInsets.only(bottom: 6),
          //     child: Text(
          //       '02.40 AM',
          //       maxLines: 1,
          //       overflow: TextOverflow.ellipsis,
          //       style: InheritedChatTheme.of(context)
          //           .theme
          //           .userNameTextStyle,
          //     ),
          //   ),
          SelectableText(
            utf8.fuse(base64).decode(message.payload.toString()),
            style: message.initiated == true
                ? InheritedChatTheme.of(context).theme.sentMessageBodyTextStyle
                : InheritedChatTheme.of(context)
                    .theme
                    .receivedMessageBodyTextStyle,
            textWidthBasis: TextWidthBasis.longestLine,
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final _currentUserIsAuthor = message.initiated == true;
    final DateTime _date1 =
    DateTime.fromMillisecondsSinceEpoch(message.createdAt!);
    String _timeFormate = DateFormat.jm().format(_date1);
    return Column(
      crossAxisAlignment: _currentUserIsAuthor ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: _currentUserIsAuthor
                ? Border.all(color: Colors.grey,width: 1.5)
                : Border.all(color: Colors.red,width: 1.5),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft:
                  _currentUserIsAuthor ? Radius.circular(10) : Radius.circular(0),
              bottomRight:
                  _currentUserIsAuthor ? Radius.circular(0) : Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: _textWidgetBuilder(context)
                  ),
            ],
          ),
        ),
        SizedBox(height: 5,),
        Text(
          _timeFormate,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
