import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'partial_custom.g.dart';

/// A class that represents partial custom message.
@JsonSerializable(explicitToJson: true)
@immutable
class PartialCustom {
  /// Creates a partial custom message with metadata variable.
  /// Use [CustomMessage] to create a full message.
  /// You can use [CustomMessage.fromPartial] constructor to create a full
  /// message from a partial one.
  const PartialCustom({
    this.metadata,
  });

  /// Creates a partial custom message from a map (decoded JSON).
  factory PartialCustom.fromJson(Map<String, dynamic> json) =>
      _$PartialCustomFromJson(json);

  /// Converts a partial custom message to the map representation, encodable to JSON.
  Map<String, dynamic> toJson() => _$PartialCustomToJson(this);

  /// Additional custom metadata or attributes related to the message
  final Map<String, dynamic>? metadata;
}
