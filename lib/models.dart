// import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:objectbox/objectbox.dart';



@Entity()
class UserMessage{
  UserMessage({this.id = 0, this.mainMessageData,this.senderId,this.receiverId});
  int id;
  List<String>? mainMessageData;
  String? senderId;
  String? receiverId;

}

// @Entity()
// class MessageModel {
//   MessageModel(
//       {this.id = 0,
//       this.createdAt,
//       this.status,
//       this.delivered,
//       this.deliveredAt,
//       this.fileName,
//       this.thumbnail,
//       this.messageType,
//       this.initiated,
//       this.offerReplyStatus,
//       this.messageId,
//       this.payload,
//       this.read,
//       this.receiverId,
//       this.senderId,
//       this.dataSize});
//   int id;
//   bool? initiated;
//   int? messageId;
//   String? senderId;
//   String? receiverId;
//   String? payload;
//   int? messageType;
//   int? createdAt;
//   int? status;
//   int? delivered;
//   int? read;
//   int? deliveredAt;
//   dynamic offerReplyStatus;
//   String? thumbnail;
//   String? fileName;
//   int? dataSize;
// }
