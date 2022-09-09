import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:intl/intl.dart';
import 'package:objectbox_with_chat/app/pages/chat_user/mqtt_controller.dart';
import 'package:objectbox_with_chat/main.dart';

class ChatUserController extends GetxController {
  String userName = '';

  String checkId = '';

  bool checkData = true;

  bool pendingMessage = false;

  int numberOfMessage = 0;

  String lastMessage = '';

  String messageSender = '';

  String lastTime = '';

  List<types.MessageData> messages = [];

  // List<types.MessageData> pendingMessagesList = [];

  List<CheckMessage> userMessageList = [];

  @override
  void onInit() {
    // print('myUserName $userName');
    loadLastMessage();
    super.onInit();
  }

  List<UserData> data = [
    UserData(
        name: 'Rahul',
        image:
            'https://media-exp1.licdn.com/dms/image/C4E03AQHrwP5CtFo_pg/profile-displayphoto-shrink_200_200/0/1628675384915?e=2147483647&v=beta&t=Pk5FrDBxm2Ryxv3YAZ99nb08jSKKz-ngUdkuLlZsduE',
        message: [],
        online: true),
    // UserData(
    //     name: 'Riyaz',
    //     image:
    //         'https://media-exp1.licdn.com/dms/image/C4D03AQHiznmKuo5jsw/profile-displayphoto-shrink_200_200/0/1516314605932?e=2147483647&v=beta&t=bg2MAprt3fPziGUfzvSWkPqIWr9m9jVdAdlsxCluJsA',
    //     message: [],
    //     online: true),
    // UserData(
    //     name: 'Rajkumar',
    //     image:
    //         'https://media-exp1.licdn.com/dms/image/C4D03AQGqCechvJ3VXA/profile-displayphoto-shrink_800_800/0/1615043633236?e=2147483647&v=beta&t=FBXEm0K4vHsg0bpojs4wCiHBhsQb_1aZUhj1WfI8ysQ',
    //     message: [],
    //     online: true),
  ];

  void checkMessageData() async {
    final responses = objectbox.noteBox.getAll();
    if (responses.isEmpty) {
      await objectbox
          .addNote(types.TextMessage(senderId: 'Rajkumar', receiverId: userName));
    } else {
      print('Second Time');
      for (var x = 0; x < responses.length; x++) {
        if (userName == responses[x].receiverId) {
          print('DB is Available');
          checkData = false;
          update();
          break;
        }
      }
      if (checkData) {
        print('DB is Created');
        await objectbox
            .addNote(types.TextMessage(senderId: 'Rajkumar', receiverId: userName));
      }
    }
  }

  void loadMessages() async {
    final responses = objectbox.noteBox.getAll();
    for (var x = 0; x < responses.length; x++) {
      Iterable<types.MessageData>? message = [];
      if (userName == responses[x].receiverId) {
        message = responses[x]
            .mainMessageData!
            .map((e) => types.MessageData.fromJson(
                json.decode(e) as Map<String, dynamic>))
            .toList()
            .reversed;
        messages = message.toList();
        update();
      }
    }
  }

  void deleteChat() async {
    final responses = objectbox.noteBox.getAll();
    for (var x = 0; x < responses.length; x++) {
      if (userName == responses[x].receiverId) {
        responses[x].mainMessageData!.clear();
        var boxStore = objectbox.noteBox;
        var index = boxStore.get(responses[x].id);
        index?.mainMessageData?.clear();
        boxStore.put(index!);
        loadMessages();
      }
    }
  }

  void addMessage(types.MessageData message) async {
    if (pendingMessage) {
      await objectbox.addNote(message);
      messages.insert(0, message);
      update();
    } else {
      pendingMessageCheck(message);
    }
  }

  void updateStatus(String senderId, int deliveredAt, int status) async {
    var boxStore = objectbox.noteBox;
    final responses = objectbox.noteBox.getAll();
    if (status == 3) {
      for (var x = 0; x < responses.length; x++) {
        if (senderId == responses[x].receiverId) {
          print('${senderId} =To= ${responses[x].receiverId}');
          var index = boxStore.get(responses[x].id);
          for (var x = 0; x < index!.mainMessageData!.length; x++) {
            var data =
                jsonDecode(index.mainMessageData![x]) as Map<String, dynamic>;
            if (data['status'] == 2) {
              data['status'] = status;
              data['deliveredAt'] = deliveredAt;
              final messageInString = json.encode(data);
              index.mainMessageData![x] = messageInString;
              boxStore.put(index);
            }
          }
          loadMessages();
        }
      }
    } else {
      for (var x = 0; x < responses.length; x++) {
        if (senderId == responses[x].receiverId) {
          var index = boxStore.get(responses[x].id);
          var data =
              jsonDecode(index!.mainMessageData!.last) as Map<String, dynamic>;
          data['status'] = status;
          data['deliveredAt'] = deliveredAt;
          final messageInString = json.encode(data);
          var lengthOfList = index.mainMessageData!.length;
          index.mainMessageData![lengthOfList - 1] = messageInString;
          boxStore.put(index);
          loadMessages();
        }
      }
    }
  }

  void loadLastMessage() {
    final responses = objectbox.noteBox.getAll();
    String? message;
    Map<String, dynamic>? lastMessageMap;
    for (var x = 0; x < responses.length; x++) {
      for (var y = 0; y < data.length; y++) {
        if (responses[x].receiverId == data[y].name) {
          if (responses[x].mainMessageData!.isEmpty) {
            // message = utf8.fuse(base64).decode(data[y].message!.last.payload!)  ;
          } else {
            lastMessageMap = jsonDecode(responses[x].mainMessageData!.last);
            message = utf8.fuse(base64).decode(lastMessageMap!['payload']);
          }
          final timestamp1 =
              lastMessageMap!['createdAt']; // timestamp in seconds
          final DateTime date1 =
              DateTime.fromMillisecondsSinceEpoch(timestamp1);
          String timeFormate = DateFormat.jm().format(date1);
          messageSender = data[y].name!;
          lastMessage = message!;
          lastTime = timeFormate;
        }
      }
    }
    update();
  }

  void pendingMessageCheck(types.MessageData message) {
    for (var x = 0; x < data.length; x++) {
      if (message.senderId == data[x].name) {
        data[x].message!.add(message);
        messageSender = message.senderId!;
        final timestamp1 =
            data[x].message!.last.createdAt; // timestamp in seconds
        final DateTime date1 = DateTime.fromMillisecondsSinceEpoch(timestamp1!);
        lastTime = DateFormat.jm().format(date1);
        lastMessage = utf8.fuse(base64).decode(data[x].message!.last.payload!);
        numberOfMessage = data[x].message!.length;
      }
    }
    update();
  }

  void pendingMessageSettle() {
    if (pendingMessage) {
      for (var y = 0; y < data.length; y++) {
        if (userName == data[y].name) {
          for (var x in data[y].message!) {
            Get.find<MqttController>().sendAcknowledgement(
                x.receiverId!,
                DateTime.now().millisecondsSinceEpoch,
                3,
                x.senderId!,
                x.messageType!);
            addMessage(x);
          }
        }
      }
    }
  }
}

class CheckMessage {
  CheckMessage({this.receiverName, this.messageList});
  String? receiverName;
  List<types.MessageData>? messageList;
}

class UserData {
  UserData({this.name, this.image, this.message, this.online});
  String? name;
  String? image;
  List<types.MessageData>? message;
  bool? online;
}
