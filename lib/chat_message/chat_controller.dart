import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:intl/intl.dart';

import '../main.dart';

class ChatController extends GetxController{


  @override
  void onInit() {
    loadLastMessage();
    super.onInit();
  }

  List<Map> data = [
    // {
    //   'name': 'c',
    //   'image':
    //   'https://media-exp1.licdn.com/dms/image/C4D03AQGqCechvJ3VXA/profile-displayphoto-shrink_800_800/0/1615043633236?e=2147483647&v=beta&t=FBXEm0K4vHsg0bpojs4wCiHBhsQb_1aZUhj1WfI8ysQ',
    //   'time': '12:00 AM',
    //   'message': 'Bol bhai',
    //   'online': true
    // },
    {
      'name': 'a',
      'image':
      'https://media-exp1.licdn.com/dms/image/C4E03AQHrwP5CtFo_pg/profile-displayphoto-shrink_200_200/0/1628675384915?e=2147483647&v=beta&t=Pk5FrDBxm2Ryxv3YAZ99nb08jSKKz-ngUdkuLlZsduE',
      'time': '01:00 AM',
      'message': 'Hiii',
      'online': false
    },
    {
      'name': 'b',
      'image':
      'https://media-exp1.licdn.com/dms/image/C4D03AQHiznmKuo5jsw/profile-displayphoto-shrink_200_200/0/1516314605932?e=2147483647&v=beta&t=bg2MAprt3fPziGUfzvSWkPqIWr9m9jVdAdlsxCluJsA',
      'time': '10:00 PM',
      'message': 'Hello',
      'online': false
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


  int userIndex = -1;

  void loadLastMessage() {
    final responses = objectbox.noteBox.getAll();
    String? message;
    Map<String, dynamic>? lastMessage;
    print('length ${responses.length}');
    for(var x = 0; x < responses.length; x++){
      for(var y = 0; y < data.length; y++){
        if (responses[x].receiverId == data[y]['name']){
          if(responses[x].mainMessageData!.isEmpty){
            message = data[y]['message'];
          } else {
            lastMessage = jsonDecode(responses[x].mainMessageData!.last);
            message = utf8.fuse(base64).decode(lastMessage!['payload']);
          }
          final timestamp1 = lastMessage!['createdAt']; // timestamp in seconds
          final DateTime date1 = DateTime.fromMillisecondsSinceEpoch(timestamp1);
          String timeFormate = DateFormat.jm().format(date1);
          data[y]['message'] = message;
          data[y]['time'] = timeFormate;
          update();
        }
      }
    }
    // print('load front ${responses[0].mainMessageData!.last}');
    // print('load front ${responses[1].mainMessageData!.last}');
    // print('load front ${responses[2].mainMessageData!.last}');
  }


  // void setReceivedText(String text) async {
  //   final message = types.MessageData.fromJson(jsonDecode(text));
  //   messages.insert(0, message);
  //   // await objectbox.addNote(message);
  //   update();
  // }


}