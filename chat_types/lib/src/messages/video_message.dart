import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'video_message.g.dart';

/// A class that represents image message.
@JsonSerializable(explicitToJson: true)
@immutable
class VideoMessage extends MessageData {
  /// Creates an image message.
  const VideoMessage({
    bool? initiated,
    int? messageId,
    String? senderId,
    String? receiverId,
    String? payload,
    int? status,
    int? messageType,
    int? createdAt,
    int? delivered,
    int? read,
    int? deliveredAt,
    dynamic offerReplyStatus,
    String? thumbnail,
    String? fileName,
    dynamic dataSize,
    bool? finalRes,
    this.width,
    this.height,
  }) : super(
      initiated,
      messageId,
      senderId,
      receiverId,
      payload,
      status,
      messageType,
      createdAt,
      delivered,
      read,
      deliveredAt,
      offerReplyStatus,
      thumbnail,
      fileName,
      dataSize,
      finalRes);

  /// Creates a full image message from a partial one.
  const VideoMessage.fromPartial({
    bool? initiated,
    int? messageId,
    String? senderId,
    String? receiverId,
    String? payload,
    int? status,
    int? messageType,
    int? createdAt,
    int? delivered,
    int? read,
    int? deliveredAt,
    dynamic offerReplyStatus,
    String? thumbnail,
    String? fileName,
    String? dataSize,
    bool? finalRes,
    this.width,
    this.height,
  }) :super(
      initiated,
      messageId,
      senderId,
      receiverId,
      payload,
      status,
      messageType,
      createdAt,
      delivered,
      read,
      deliveredAt,
      offerReplyStatus,
      thumbnail,
      fileName,
      dataSize,
      finalRes);

  /// Creates an image message from a map (decoded JSON).
  factory VideoMessage.fromJson(Map<String, dynamic> json) =>
      _$VideoMessageFromJson(json);

  /// Converts an image message to the map representation, encodable to JSON.
  @override
  Map<String, dynamic> toJson() => _$VideoMessageToJson(this);

  MessageData copyWith({
    bool? initiated,
    int? messageId,
    String? senderId,
    String? receiverId,
    String? payload,
    int? status,
    int? messageType,
    int? createdAt,
    int? delivered,
    int? read,
    int? deliveredAt,
    dynamic offerReplyStatus,
    String? thumbnail,
    String? fileName,
    dynamic dataSize,
    bool? finalRes,
  }) => VideoMessage(
      initiated: initiated,
      messageId: messageId,
      senderId: senderId,
      receiverId: receiverId,
      payload: payload,
      status: status,
      messageType: messageType,
      createdAt: createdAt,
      delivered: delivered,
      read: read,
      offerReplyStatus: offerReplyStatus,
      thumbnail: thumbnail,
      fileName: fileName,
      dataSize: dataSize,
      finalRes: finalRes,
    );

  /// Equatable props
  @override
  List<Object?> get props => [
    initiated,
    messageId,
    senderId,
    receiverId,
    payload,
    status,
    messageType,
    createdAt,
    delivered,
    read,
    deliveredAt,
    offerReplyStatus,
    thumbnail,
    fileName,
    dataSize,
    finalRes
  ];
  /// Image width in pixels
  final double? width;

  /// Image height in pixels
  final double? height;
}
