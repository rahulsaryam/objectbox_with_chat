import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/src/models/date_header.dart';
import 'package:flutter_chat_ui/src/models/message_spacer.dart';
import 'package:flutter_chat_ui/src/models/preview_image.dart';
import 'package:intl/intl.dart';

/// Returns text representation of a provided bytes value (e.g. 1kB, 1GB)
String formatBytes(int size, [int fractionDigits = 2]) {
  if (size <= 0) return '0 B';
  final multiple = (log(size) / log(1024)).floor();
  return '${(size / pow(1024, multiple)).toStringAsFixed(fractionDigits)} ${[
    'B',
    'kB',
    'MB',
    'GB',
    'TB',
    'PB',
    'EB',
    'ZB',
    'YB'
  ][multiple]}';
}

/// Returns user avatar and name color based on the ID
// Color getUserAvatarNameColor(types.User user, List<Color> colors) =>
//     colors[user.receiverId.hashCode % colors.length];

/// Returns user name as joined firstName and lastName
// String getUserName(types.User user) => '${user.userName ?? ''}';

/// Returns formatted date used as a divider between different days in the
/// chat history
String getVerboseDateTimeRepresentation(
  DateTime dateTime, {
  DateFormat? dateFormat,
  String? dateLocale,
  DateFormat? timeFormat,
}) {
  final formattedDate = dateFormat != null
      ? dateFormat.format(dateTime)
      : DateFormat.yMMMMd(dateLocale).format(dateTime);
  final formattedTime = timeFormat != null
      ? timeFormat.format(dateTime)
      : DateFormat.jm().format(dateTime);     /// DateFormat.Hms(dateLocale).format(dateTime);
  final localDateTime = dateTime.toLocal();
  final now = DateTime.now();

  if (localDateTime.day == now.day &&
      localDateTime.month == now.month &&
      localDateTime.year == now.year) {
    return '$formattedDate at $formattedTime';
  }

  return '$formattedDate, $formattedTime';
}

/// Parses provided messages to chat messages (with headers and spacers) and
/// returns them with a gallery
List<Object> calculateChatMessages(
  List<types.MessageData> messages,
  // types.User user,
  {
  String Function(DateTime)? customDateHeaderText,
  DateFormat? dateFormat,
  String? dateLocale,
  required bool showUserNames,
  DateFormat? timeFormat,
}) {

  final chatMessages = <Object>[];
  final gallery = <PreviewImage>[];

  var shouldShowName = false;

  for (var i = messages.length - 1; i >= 0; i--) {
    final isFirst = i == messages.length - 1;
    final isLast = i == 0;
    final message = messages[i];
    final messageHasCreatedAt = message.createdAt != null;
    final nextMessage = isLast ? null : messages[i - 1];
    final nextMessageHasCreatedAt = nextMessage?.createdAt != null;
    final nextMessageSameAuthor = message.receiverId == nextMessage?.senderId;
    // final notMyMessage = message.receiverId != user.receiverId;

    var nextMessageDateThreshold = false;
    var nextMessageDifferentDay = false;
    var nextMessageInGroup = false;
    var showName = false;

    if (showUserNames) {
      final previousMessage = isFirst ? null : messages[i + 1];

      final isFirstInGroup =
          // notMyMessage
          //     &&
          (message.receiverId != previousMessage?.receiverId) ||
              (messageHasCreatedAt &&
                  previousMessage?.createdAt != null &&
                  message.createdAt! - previousMessage!.createdAt! > 60000);

      if (isFirstInGroup) {
        shouldShowName = false;
        if (message.messageType == 1) {
          showName = true;
        } else {
          shouldShowName = true;
        }
      }

      if (message.messageType == 1 && shouldShowName) {
        showName = true;
        shouldShowName = false;
      }
    }

    if (messageHasCreatedAt && nextMessageHasCreatedAt) {
      nextMessageDateThreshold =
          nextMessage!.createdAt! - message.createdAt! >= 900000;

      nextMessageDifferentDay =
          DateTime.fromMillisecondsSinceEpoch(message.createdAt!).day !=
              DateTime.fromMillisecondsSinceEpoch(nextMessage.createdAt!).day;

      nextMessageInGroup = nextMessageSameAuthor &&
          nextMessage.createdAt! - message.createdAt! <= 60000;
    }

    if (isFirst && messageHasCreatedAt) {
      chatMessages.insert(
        0,
        DateHeader(
          text: customDateHeaderText != null
              ? customDateHeaderText(
                  DateTime.fromMillisecondsSinceEpoch(message.createdAt!),
                )
              : getVerboseDateTimeRepresentation(
                  DateTime.fromMillisecondsSinceEpoch(message.createdAt!),
                  dateFormat: dateFormat,
                  dateLocale: dateLocale,
                  timeFormat: timeFormat,
                ),
        ),
      );
    }

    chatMessages.insert(0, {
      'message': message,
      'nextMessageInGroup': nextMessageInGroup,
      'showName':
          // notMyMessage &&
          showUserNames && showName,
      // && getUserName(user).isNotEmpty,
      'showStatus': true,
    });

    if (!nextMessageInGroup) {
      chatMessages.insert(
        0,
        MessageSpacer(
          height: 12,
          id: message.senderId.toString(),
        ),
      );
    }

    if (nextMessageDifferentDay || nextMessageDateThreshold) {
      chatMessages.insert(
        0,
        DateHeader(
          text: customDateHeaderText != null
              ? customDateHeaderText(
                  DateTime.fromMillisecondsSinceEpoch(nextMessage!.createdAt!),
                )
              : getVerboseDateTimeRepresentation(
                  DateTime.fromMillisecondsSinceEpoch(nextMessage!.createdAt!),
                  dateFormat: dateFormat,
                  dateLocale: dateLocale,
                  timeFormat: timeFormat,
                ),
        ),
      );
    }

    if (message is types.ImageMessage) {
      if (kIsWeb) {
        if (message.fileName != null) {
          if (message.fileName!.startsWith('http')) {
            gallery.add(PreviewImage(
                messageId: message.messageId ?? 0,
                payload: utf8.fuse(base64).decode(message.payload.toString())));
          }
        } else {
          gallery.add(PreviewImage(
              messageId: message.messageId ?? 0,
              payload: utf8.fuse(base64).decode(message.payload.toString())));
        }
      }
    }
  }

  return [chatMessages, gallery];
}
