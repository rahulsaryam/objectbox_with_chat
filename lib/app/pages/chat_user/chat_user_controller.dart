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

  // bool checkStatus = false;

  List<types.MessageData> messages = [];

  List<types.MessageData> pendingMessagesList = [];

  List<CheckMessage> userMessageList = [];

  @override
  void onInit() {
    // print('myUserName $userName');
    loadLastMessage();
    super.onInit();
  }

  List<Map> data = [
    // {
    //    'name': 'c',
    //    'image':
    //    'https://media-exp1.licdn.com/dms/image/C4D03AQGqCechvJ3VXA/profile-displayphoto-shrink_800_800/0/1615043633236?e=2147483647&v=beta&t=FBXEm0K4vHsg0bpojs4wCiHBhsQb_1aZUhj1WfI8ysQ',
    //    'time': '12:00 AM',
    //    'message': 'Bol bhai',
    //    'online': true
    //  },
    {
      'name': 'a',
      'image':
          'https://media-exp1.licdn.com/dms/image/C4E03AQHrwP5CtFo_pg/profile-displayphoto-shrink_200_200/0/1628675384915?e=2147483647&v=beta&t=Pk5FrDBxm2Ryxv3YAZ99nb08jSKKz-ngUdkuLlZsduE',
      'time': '01:00 AM',
      'message': 'Hiii',
      'online': false,
      'noOfMessage' : 0
    },
    {
      'name': 'b',
      'image':
          'https://media-exp1.licdn.com/dms/image/C4D03AQHiznmKuo5jsw/profile-displayphoto-shrink_200_200/0/1516314605932?e=2147483647&v=beta&t=bg2MAprt3fPziGUfzvSWkPqIWr9m9jVdAdlsxCluJsA',
      'time': '10:00 PM',
      'message': 'Hello',
      'online': false,
      'noOfMessage' : 0
    },
    // {
    //   'name': 'Bhupendra',
    //   'image':
    //   'https://images.unsplash.com/photo-1559629819-638a8f0a4303?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Ym95fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60',
    //   'time': '09:00 AM',
    //   'message': 'By',
    //   'online': true
    // },
    // {
    //   'name': 'Shubham bhai',
    //   'image':
    //   'https://images.unsplash.com/photo-1514926255734-79b2e9ef2501?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTJ8fGJveXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60',
    //   'time': '08:00 PM',
    //   'message': 'Gm',
    //   'online': true
    // },
    // {
    //   'name': 'Satish Coder',
    //   'image':
    //   'https://images.unsplash.com/photo-1482849737880-498de71dda8d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTd8fGJveXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60',
    //   'time': '01:00 AM',
    //   'message': 'GM',
    //   'online': false
    // },
    // {
    //   'name': 'Roshan Lale',
    //   'image':
    //   'https://images.unsplash.com/photo-1488161628813-04466f872be2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTh8fGJveXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60',
    //   'time': '06:00 PM',
    //   'message': 'GN',
    //   'online': true
    // },
    // {
    //   'name': 'Suraj Tiwari',
    //   'image':
    //   'https://images.unsplash.com/photo-1507438222021-237ff73669b5?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjB8fGJveXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60',
    //   'time': '02:00 AM',
    //   'message': 'Kayse Hai',
    //   'online': false
    // },
  ];

  void checkMessageData() async {
    final responses = objectbox.noteBox.getAll();
    if (responses.isEmpty) {
      await objectbox
          .addNote(types.TextMessage(senderId: 'c', receiverId: userName));
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
            .addNote(types.TextMessage(senderId: 'c', receiverId: userName));
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
      // if(message.receiverId != checkId){
      //   if(Get.find<MqttController>().checkStatus){
      //     Get.find<MqttController>().sendAcknowledgement(message.receiverId!, DateTime.now().millisecondsSinceEpoch, 3,
      //         message.senderId!, message.messageType!);
      //   }
      // }

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
    Map<String, dynamic>? lastMessage;
    for (var x = 0; x < responses.length; x++) {
      for (var y = 0; y < data.length; y++) {
        if (responses[x].receiverId == data[y]['name']) {
          if (responses[x].mainMessageData!.isEmpty) {
            message = data[y]['message'];
          } else {
            lastMessage = jsonDecode(responses[x].mainMessageData!.last);
            message = utf8.fuse(base64).decode(lastMessage!['payload']);
          }
          final timestamp1 = lastMessage!['createdAt']; // timestamp in seconds
          final DateTime date1 =
              DateTime.fromMillisecondsSinceEpoch(timestamp1);
          String timeFormate = DateFormat.jm().format(date1);
          data[y]['message'] = message;
          data[y]['time'] = timeFormate;
          update();
        }
      }
    }
  }

  void pendingMessageCheck(types.MessageData message) {
    if(userMessageList.isEmpty){
      print('userMessageList');
    } else {

    }
    // for (var x in data) {
    //   if (x['name'] == message.senderId) {
    //
    //     // print(userMessageList.length);
    //     // print('rahul ${userMessageList[0].messageList.a}');
    //   }
    // }
    pendingMessagesList.add(message);
    numberOfMessage = pendingMessagesList.length;
    update();
  }

  void pendingMessageSettle() {
    if (pendingMessage) {
      for (var x in pendingMessagesList) {
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

class CheckMessage {
  CheckMessage({this.receiverName, this.messageList});
  String? receiverName;
  List<types.MessageData>? messageList;
}



