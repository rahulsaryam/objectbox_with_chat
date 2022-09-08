import 'dart:convert';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:objectbox_with_chat/app/pages/chat_user/chat_user_controller.dart';

enum MQTTAppConnectionState {
  connected,
  disconnected,
  connecting,
  subscribed,
  unsubscribed
}

class MqttController extends GetxController {
  MqttServerClient? _client;

  String connectState = '';

  String subscribeState = '';

  String topic = 'flutter/chat/friend';

  String clientId = 'laptop';

  String checkId = '';

  bool checkStatus = true;

  // List<types.MessageData> messages = [];

  final chatUserController = Get.find<ChatUserController>();


  // MQTTAppConnectionState MQTTAppConnectionState = MQTTAppConnectionState.disconnected;

  @override
  void onInit() {
    chatUserController;
    initializeMQTTClient();
    connect();
    super.onInit();
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }

  void _switchMQTTAppConnectionState(
      MQTTAppConnectionState mqttAppConnectionState) {
    // MQTTAppConnectionState = MQTTAppConnectionState;
    if (mqttAppConnectionState == MQTTAppConnectionState.connected) {
      connectState = 'Connected';
    } else if (mqttAppConnectionState == MQTTAppConnectionState.disconnected) {
      connectState = 'Disconnected';
    }
    if (mqttAppConnectionState == MQTTAppConnectionState.subscribed) {
      subscribeState = 'Subscribed';
    } else if (mqttAppConnectionState == MQTTAppConnectionState.unsubscribed) {
      subscribeState = 'UnSubscribed';
    } else {}
    update();
  }

  void initializeMQTTClient() {
    _client = MqttServerClient('broker.emqx.io', clientId);
    _client!.port = 1883;
    _client!.keepAlivePeriod = 20;
    _client!.onDisconnected = onDisconnected;
    _client!.secure = false;
    _client!.logging(on: true);

    /// Add the successful connection callback
    _client!.onConnected = onConnected;
    _client!.onSubscribed = onSubscribed;

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .withWillTopic(
        'willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    print('EXAMPLE::Mosquitto client connecting....');
    _client!.connectionMessage = connMess;
  }

  // Connect to the host
  // ignore: avoid_void_async
  void connect() async {
    assert(_client != null);
    try {
      print('EXAMPLE::Mosquitto start client connecting....');
      _switchMQTTAppConnectionState(MQTTAppConnectionState.connected);
      // _currentState.setAppConnectionState(MQTTAppConnectionState.connecting);
      print('start');
      await _client!.connect();
    } on Exception catch (e) {
      print('EXAMPLE::client exception - $e');
      disconnect();
    }
  }

  void disconnect() {
    print('Disconnected');
    _client!.disconnect();
  }

  void publish(int createdAt, String payload, bool initiated, int messageType,
      String senderId, String receiverId, int status,
      {String fileName = '',
        int dataSize = 0,
        String thumbnail = '',
        double height = 0,
        double width = 0}) {
    if (connectState == 'Connected') {
      final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
      var dataToSend =
          '{"createdAt" : $createdAt, "payload" : "$payload", "initiated" : ${!initiated}, "messageType" : $messageType, "senderId" : "$senderId", "receiverId" : "$receiverId","status" : $status, "fileName" : "$fileName", "dataSize" : $dataSize , "thumbnail" : "$thumbnail" ,"height" : $height, "width" : $width }';
      builder.addString(dataToSend);
      _client!.publishMessage(
        topic,
        MqttQos.atLeastOnce,
        builder.payload!,
      );
    }
  }

  void sendAcknowledgement(String senderId, int deliveredAt, int status,
      String receiverId, int messageType) async {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    if (status == 3) {
      var dataToSend =
          '{"deliveredAt":$deliveredAt,"senderId":"$senderId","status":$status,"receiverId" : "$receiverId","messageType" : $messageType}';
      builder.addString(dataToSend);
      _client!.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!,retain: true);
      // Utility.printILog('publish message $pubStatus');
      update();
    } else if (status == 2) {
      print('$senderId =Rahul= $receiverId');
      var dataToSend =
          '{"deliveredAt":$deliveredAt,"senderId":"$senderId","status":$status,"receiverId" : "$receiverId","messageType" : $messageType}';
      builder.addString(dataToSend);
      _client!.publishMessage(
        topic,
        MqttQos.exactlyOnce,
        builder.payload!,
      );
      // Utility.printILog('publish message $pubStatus');
      update();
    }
  }

  /// The subscribed callback
  void onSubscribed(String topic) {
    print('EXAMPLE::Subscription confirmed for topic $topic');
  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (_client!.connectionStatus!.returnCode ==
        MqttConnectReturnCode.noneSpecified) {
      print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    }
    _switchMQTTAppConnectionState(MQTTAppConnectionState.disconnected);
  }

  /// The successful connect callback
  void onConnected() {
    _switchMQTTAppConnectionState(MQTTAppConnectionState.connected);
    print('EXAMPLE::Mosquitto client connected....');
    _client!.subscribe(topic, MqttQos.atLeastOnce);
    _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      // ignore: avoid_as
      final MqttPublishMessage recMess = c![0].payload as MqttPublishMessage;

      // final MqttPublishMessage recMess = c![0].payload;
      final String pt =
      MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      final message = types.MessageData.fromJson(jsonDecode(pt));
      if (message.receiverId != checkId) {
        if (message.status == 1) {
          chatUserController.addMessage(message);
          checkStatus = true;
          update();
        } else {
          checkStatus = false;
          update();
          chatUserController.updateStatus(
              message.senderId!, message.deliveredAt!, message.status!);
          // if(chatUserController.pendingMessage){
          //   sendAcknowledgement(
          //       message.receiverId!,
          //       DateTime.now().millisecondsSinceEpoch,
          //       3,
          //       message.senderId!,
          //       message.messageType!);
          // }

        }

      }
      if (checkStatus) {
        sendAcknowledgement(
            message.receiverId!,
            DateTime.now().millisecondsSinceEpoch,
            2,
            message.senderId!,
            message.messageType!);
        checkStatus = false;
        update();
        if(chatUserController.pendingMessage){
          sendAcknowledgement(
              message.receiverId!,
              DateTime.now().millisecondsSinceEpoch,
              3,
              message.senderId!,
              message.messageType!);
        }
      }

      // chatController.messages.insert(index, element)
      // chatController.setReceivedText(pt);
      print(
          'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
      print('');
    });
    print(
        'EXAMPLE::OnConnected client callback - Client connection was sucessful');
  }
}

//
// import 'dart:convert';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:mqtt_client/mqtt_client.dart';
// import 'package:mqtt_client/mqtt_server_client.dart';
// import 'package:objectbox_with_chat/models.dart';
//
// import 'chat_controller.dart';
//
// enum MQTTAppConnectionState { connected, disconnected, connecting,subscribed,unsubscribed }
//
// class MQTTController extends GetxController {
//   // MQTTController(this._homePresenter);
//
//   MqttServerClient? _mqttServerClient;
//   List<types.MessageData> messages = [];
//   late MessageModel? messageModel;
//
//   final chatController = Get.put(ChatController());
//   //
//   // final _profileController = Get.find<ProfileInfoController>();
//
//   // ignore: prefer_typing_uninitialized_variables
//   var args;
//
//   // ignore: prefer_typing_uninitialized_variables
//   var file;
//
//   final bottomMenuList = [
//     {
//       'title': 'video'.tr,
//       'url': 'assets/icon/video_icon.svg',
//     },
//     {
//       'title': 'document'.tr,
//       'url': 'assets/icon/document.svg',
//     },
//     {
//       'title': 'camera'.tr,
//       'url': 'assets/icon/camera.svg',
//     },
//     {
//       'title': 'image'.tr,
//       'url': 'assets/icon/photos_videos.svg',
//     },
//   ];
//
//   final scrollController = ScrollController();
//   // final HomePresenter _homePresenter;
//   String receivedMessage = '';
//   String historyMessage = '';
//
//   String connectState = '';
//   String subscribeState = '';
//   var userID = '';
//
//   var messageController = TextEditingController();
//
//   MQTTAppConnectionState mqttAppConnectionState = MQTTAppConnectionState.disconnected;
//
//   // Future<void> getMessages() async {
//   //   final res =
//   //   // await chatController.getMessaege(args['chatID'] as String? ?? '');
//   //   messageModel = res;
//   // }
//
//   void loadMessages() async {
//     messages.clear();
//     // await getMessages();
//     final mesRes = messageModel;
//     // final messages1 = mesRes!.data!;
//     // messages = messages1;
//     update();
//   }
//
//   @override
//   void onInit() async {
//     // userID = await _homePresenter.getUserID();
//     setupMqttConnection2();
//
//     super.onInit();
//   }
//
//   void addMessage(types.MessageData message) {
//     messages.insert(0, message);
//     update();
//   }
//
//   // void handleAtachmentPressed(BuildContext context) {
//   //   Get.bottomSheet(
//   //     Padding(
//   //       padding: Dimens.edgeInsets16,
//   //       child: GridView.count(
//   //         crossAxisCount: 3,
//   //         shrinkWrap: true,
//   //         children: List.generate(
//   //           bottomMenuList.length,
//   //               (index) => GestureDetector(
//   //             onTap: () async {
//   //               Get.back();
//   //               if (index == 0) {
//   //                 var file = await ImagePicker()
//   //                     .pickVideo(source: ImageSource.gallery);
//   //
//   //                 final uint8list = await VideoThumbnail.thumbnailData(
//   //                   video: file!.path,
//   //                   imageFormat: ImageFormat.JPEG,
//   //                   maxWidth: 128,
//   //                   quality: 25,
//   //                 );
//   //                 final imageEncoded = base64.encode(uint8list!);
//   //
//   //                 final res = await _homePresenter.uploadDoc(
//   //                   image: file.path,
//   //                   folderName: 'nurse/media',
//   //                   fileName:
//   //                   '${_profileController.model!.providerData!.id!}_${file.name}',
//   //                   fileType: 'image',
//   //                 );
//   //
//   //                 final jsonRes = jsonDecode(res!) as Map<String, dynamic>;
//   //                 final size = await file.length();
//   //
//   //                 handleSendPressed(
//   //                   '${jsonRes['url']}',
//   //                   3,
//   //                   fileName: file.name,
//   //                   fileSize: size,
//   //                   thumbnail: imageEncoded,
//   //                 );
//   //               } else if (index == 1) {
//   //                 var file = await FilePicker.platform.pickFiles(
//   //                   allowMultiple: false,
//   //                 );
//   //
//   //                 if (file != null) {
//   //                   final res = await _homePresenter.uploadDoc(
//   //                     image: file.paths[0]!,
//   //                     folderName: 'nurse/media',
//   //                     fileName:
//   //                     '${_profileController.model!.providerData!.id!}_${file.names[0]}',
//   //                     fileType: 'image',
//   //                   );
//   //
//   //                   final jsonRes = jsonDecode(res!) as Map<String, dynamic>;
//   //                   handleSendPressed(
//   //                     '${jsonRes['url']},${file.names[0]!.split('.')[1]}',
//   //                     10,
//   //                     fileName: file.names[0]!,
//   //                     fileSize: file.files[0].size,
//   //                   );
//   //                 }
//   //               } else if (index == 2) {
//   //                 var file = await ImagePicker()
//   //                     .pickImage(source: ImageSource.camera, imageQuality: 25);
//   //                 if (file != null) {
//   //                   final res = await _homePresenter.uploadDoc(
//   //                     image: file.path,
//   //                     folderName: 'nurse/media',
//   //                     fileName:
//   //                     '${_profileController.model!.providerData!.id!}_${file.name}',
//   //                     fileType: 'image',
//   //                   );
//   //
//   //                   final jsonRes = jsonDecode(res!) as Map<String, dynamic>;
//   //                   handleSendPressed(
//   //                     jsonRes['url'].toString(),
//   //                     2,
//   //                   );
//   //                 }
//   //               } else if (index == 3) {
//   //                 var file = await ImagePicker()
//   //                     .pickImage(source: ImageSource.gallery, imageQuality: 25);
//   //
//   //                 if (file != null) {
//   //                   final res = await _homePresenter.uploadDoc(
//   //                     image: file.path,
//   //                     folderName: 'nurse/media',
//   //                     fileName:
//   //                     '${_profileController.model!.providerData!.id!}_${file.name}',
//   //                     fileType: 'image',
//   //                   );
//   //                   final jsonRes = jsonDecode(res!) as Map<String, dynamic>;
//   //                   handleSendPressed(
//   //                     jsonRes['url'].toString(),
//   //                     2,
//   //                   );
//   //                 }
//   //               }
//   //             },
//   //             child: Column(
//   //               mainAxisAlignment: MainAxisAlignment.center,
//   //               children: [
//   //                 SvgPicture.asset(bottomMenuList[index]['url']!),
//   //                 Dimens.boxHeight10,
//   //                 Text(
//   //                   bottomMenuList[index]['title']!,
//   //                 ),
//   //               ],
//   //             ),
//   //           ),
//   //         ),
//   //       ),
//   //     ),
//   //     backgroundColor: Colors.white,
//   //   );
//   // }
//
//   void handleSendPressed(String message, int messageType,
//         {String fileName = '', int fileSize = 0, String thumbnail = ''}) async {
//     if (messageType == 10) {
//       var data = await publishMessage(
//         base64Encode(utf8.encode(message)),
//         args['receiverID'] as String? ?? '',
//         args['chatID'] as String? ?? '',
//         DateTime.now().millisecondsSinceEpoch,
//         DateTime.now().millisecondsSinceEpoch,
//         messageType,
//         args['imageUrl'] as String? ?? '',
//         fileName,
//         fileSize,
//         thumbnail,
//       );
//       var data1 = jsonDecode(data);
//       var resp = {
//         'initiated': true,
//         'messageId': data1['messageId'],
//         'senderId': data1['senderId'],
//         'receiverId': data1['receiverId'],
//         'payload': data1['payload'],
//         'messageType': data1['messageType'],
//         'timestamp': data1['timestamp'],
//         'fileName': data1['fileName'],
//         'dataSize': data1['dataSize'],
//       };
//
//       var resp1 = types.MessageData.fromJson(resp);
//
//       addMessage(resp1);
//     } else if (messageType == 3) {
//       var data = await publishMessage(
//         base64Encode(utf8.encode(message)),
//         args['receiverID'] as String? ?? '',
//         args['chatID'] as String? ?? '',
//         DateTime.now().millisecondsSinceEpoch,
//         DateTime.now().millisecondsSinceEpoch,
//         messageType,
//         args['imageUrl'] as String? ?? '',
//         fileName,
//         fileSize,
//         thumbnail,
//       );
//       var data1 = jsonDecode(data);
//       var resp = {
//         'initiated': true,
//         'messageId': data1['messageId'],
//         'senderId': data1['senderId'],
//         'receiverId': data1['receiverId'],
//         'payload': data1['payload'],
//         'messageType': data1['messageType'],
//         'timestamp': data1['timestamp'],
//         'thumbnail': data1['thumbnail'],
//       };
//
//       var resp1 = types.MessageData.fromJson(resp);
//
//       addMessage(resp1);
//     } else {
//       var data = await publishMessage(
//         base64Encode(utf8.encode(message)),
//         'b',
//         'a',
//         DateTime.now().millisecondsSinceEpoch,
//         DateTime.now().millisecondsSinceEpoch,
//         messageType,
//         'c',
//         fileName,
//         fileSize,
//         thumbnail,
//       );
//       var data1 = jsonDecode(data);
//       var resp = {
//         'initiated': true,
//         'messageId': data1['messageId'],
//         'senderId': data1['senderId'],
//         'receiverId': data1['receiverId'],
//         'payload': data1['payload'],
//         'messageType': data1['messageType'],
//         'timestamp': data1['timestamp'],
//       };
//
//       var resp1 = types.MessageData.fromJson(resp);
//
//
//
//       addMessage(resp1);
//     }
//   }
//
//   // void deleteChat(String chatID, BuildContext context, int val) async {
//   //   await Get.bottomSheet(
//   //     Container(
//   //       padding: Dimens.edgeInsets20,
//   //       height: Get.height * .24,
//   //       decoration: BoxDecoration(
//   //         borderRadius: BorderRadius.circular(2.0),
//   //       ),
//   //       child: Column(
//   //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //         crossAxisAlignment: CrossAxisAlignment.start,
//   //         children: [
//   //           Text(
//   //             'areYouSureWantToDeleteTheChat'.tr,
//   //             maxLines: 2,
//   //             style: Styles.boldBlack22,
//   //           ),
//   //           Row(
//   //             children: [
//   //               Expanded(
//   //                 child: Container(
//   //                   height: 45,
//   //                   decoration: BoxDecoration(
//   //                     borderRadius: BorderRadius.circular(5.0),
//   //                     border: Border.all(
//   //                       width: 2,
//   //                       color: ColorsValue.primaryColor,
//   //                     ),
//   //                   ),
//   //                   child: TextButton(
//   //                     onPressed: () async {
//   //                       Get.back();
//   //                     },
//   //                     child: Text(
//   //                       'cancel'.tr.toUpperCase(),
//   //                       style: Styles.darkBlue16,
//   //                     ),
//   //                   ),
//   //                 ),
//   //               ),
//   //               Dimens.boxWidth18,
//   //               Expanded(
//   //                 child: Container(
//   //                   height: 45,
//   //                   decoration: BoxDecoration(
//   //                     borderRadius: BorderRadius.circular(5.0),
//   //                     color: ColorsValue.redColor,
//   //                   ),
//   //                   child: TextButton(
//   //                     onPressed: () async {
//   //                       Get.back();
//   //                       var data = await chatController.deleteMessages(chatID);
//   //                       if (!data.hasError) {
//   //                         chatController.chatList.removeWhere(
//   //                                 (element) => element.chatId == chatID);
//   //                         chatController.update();
//   //                         Get.back();
//   //                       }
//   //                       if (val == 2) {
//   //                         Get.back();
//   //                         Get.back();
//   //                       }
//   //                       Utility.printLog(data);
//   //                     },
//   //                     child: Text(
//   //                       'delete'.tr.toUpperCase(),
//   //                       style: Styles.boldWhite16,
//   //                     ),
//   //                   ),
//   //                 ),
//   //               ),
//   //             ],
//   //           ),
//   //           Dimens.boxHeight2,
//   //         ],
//   //       ),
//   //     ),
//   //     backgroundColor: Colors.white,
//   //   );
//   // }
//
//   bool isCloseDismissle = false;
//   // void handleMessageTap(types.MessageData message) async {
//   //   if (message is types.FileMessage) {
//   //     await launch(
//   //         utf8.fuse(base64).decode(message.payload.toString()).split(',')[0]);
//   //     // await OpenFile.open(utf8.fuse(base64).decode(message.payload.toString()).split(',')[0]);
//   //   } else if (message is types.ImageMessage) {
//   //     await Get.dialog(ImageEnlarger(
//   //         imageUrl: [utf8.fuse(base64).decode(message.payload.toString())]));
//   //   } else if (message is types.VideoMessage) {
//   //     await showDialog(
//   //       context: Get.context!,
//   //       builder: (context) => Dialog(
//   //         backgroundColor: Colors.transparent,
//   //         insetPadding: Dimens.edgeInsets10,
//   //         child: CustomVideoPlayer(
//   //           videoLink: utf8.fuse(base64).decode(
//   //             message.payload.toString(),
//   //           ),
//   //           videoTitle: message.fileName,
//   //         ),
//   //       ),
//   //     );
//   //   }
//   // }
//
//   void sendAcknowledgement(
//       String chatID, int deliveryTime, int status, String receiverID) async {
//     final builder = MqttClientPayloadBuilder();
//     if (status == 3) {
//       var dataToSend =
//           '{"client_id":"$userID","chatId":"$chatID","readTime":$deliveryTime,"senderId":"$userID","status":$status}';
//       builder.addUTF8String(dataToSend);
//       var pubStatus = _mqttServerClient!.publishMessage(
//           'Acknowledgement/$receiverID', MqttQos.exactlyOnce, builder.payload!,
//           retain: true);
//       // Utility.printILog('publish message $pubStatus');
//       update();
//     } else if (status == 2) {
//       var dataToSend =
//           '{"client_id":"$userID","chatId":"$chatID","deliveryTime":$deliveryTime,"senderId":"$userID","status":$status}';
//       builder.addUTF8String(dataToSend);
//       var pubStatus = _mqttServerClient!.publishMessage(
//           'Acknowledgement/$receiverID', MqttQos.exactlyOnce, builder.payload!,
//           retain: true);
//       // Utility.printILog('publish message $pubStatus');
//       update();
//     }
//   }
//
//   void _switchMQTTAppConnectionState(MQTTAppConnectionState mqttAppConnectionState) {
//     this.mqttAppConnectionState = mqttAppConnectionState;
//     if (mqttAppConnectionState == MQTTAppConnectionState.connected) {
//       connectState = 'Connected';
//     } else if (mqttAppConnectionState == MQTTAppConnectionState.disconnected) {
//       connectState = 'Disconnected';
//     }
//     if (mqttAppConnectionState == MQTTAppConnectionState.subscribed) {
//       subscribeState = 'Subscribed';
//     } else if (mqttAppConnectionState == MQTTAppConnectionState.unsubscribed) {
//       subscribeState = 'UnSubscribed';
//     } else {}
//     update();
//   }
//
//   void _onConnected() {
//     // Utility.printILog('mqttnew in onconnected');
//     _switchMQTTAppConnectionState(MQTTAppConnectionState.connected);
//     // Utility.printILog(MQTTAppConnectionState);
//     _mqttServerClient!.updates!
//         .listen((List<MqttReceivedMessage<MqttMessage>> c) {
//       final recMessage = c[0].payload as MqttPublishMessage;
//       final pt =
//       MqttPublishPayload.bytesToStringAsString(recMessage.payload.message);
//       // Utility.printILog('mqttnew Recieved message $pt');
//       var data1 = jsonDecode(pt);
//       if (pt.contains('"messageType"')) {
//         // chatController.getChatList(loading: false, search: '');
//         var resp = {
//           'initiated': false,
//           'messageId': data1['messageId'] as int? ?? 0,
//           'senderId': data1['senderId'] as String? ?? '',
//           'receiverId': data1['receiverId'] as String? ?? '',
//           'payload': data1['payload'] as String? ?? '',
//           'messageType': data1['messageType'] as int? ?? 0,
//           'timestamp': data1['timestamp'],
//           'dataSize': data1['dataSize'],
//           'fileName': data1['fileName'],
//           'thumbnail': data1['thumbnail'] as String? ?? '',
//         };
//         var resp1 = types.MessageData.fromJson(resp);
//
//         // sendAcknowledgement(
//         //     data1['chatId'].toString(),
//         //     DateTime.now().millisecondsSinceEpoch,
//         //     2,
//         //     data1['senderId'].toString());
//         if (args['chatID'] == data1['chatId']) {
//           print('received chat $resp1');
//           // sendAcknowledgement(
//           //     data1['chatId'].toString(),
//           //     DateTime.now().millisecondsSinceEpoch,
//           //     3,
//           //     args['receiverID'].toString());
//           // addMessage(resp1);
//         }
//       }
//       var connectStatus =
//           _mqttServerClient!.connectionStatus!.returnCode!.index;
//       // Utility.printILog('connectStatus in onConnected $connectStatus');
//       update();
//       // Utility.printILog('Mqttnew connection succeded');
//     });
//   }
//
//   void _onDisconnected() {
//     if (_mqttServerClient!.connectionStatus!.returnCode ==
//         MqttConnectReturnCode.noneSpecified) {
//       // Utility.printILog('Disconnected callback');
//     }
//     _switchMQTTAppConnectionState(MQTTAppConnectionState.disconnected);
//     update();
//   }
//
//   void _onSubscribed(String topic) {
//     // Utility.printILog('OnSubscribed to: $topic');
//     _switchMQTTAppConnectionState(MQTTAppConnectionState.subscribed);
//     update();
//   }
//
//   void _onUnSubscribed(String? topic) {
//     // Utility.printILog('OnUnSubscribed to: $topic');
//     _switchMQTTAppConnectionState(MQTTAppConnectionState.unsubscribed);
//     update();
//   }
//
//   void _onSubscribeFailed(String topic) {
//     // Utility.printILog('Failed to subscribe to: $topic');
//     _switchMQTTAppConnectionState(MQTTAppConnectionState.subscribed);
//     update();
//   }
//
//   void _pong() {
//     // Utility.printILog('MQTT Ping response client callback invoked');
//     update();
//   }
//
//   void subscribeTo() {
//     try {
//       var messages =
//       _mqttServerClient!.subscribe('Message/$userID', MqttQos.atMostOnce);
//       var acknowledgement = _mqttServerClient!
//           .subscribe('Acknowledgement/$userID', MqttQos.atMostOnce);
//       // Utility.printLog(messages!.messageIdentifier.toString());
//       // Utility.printLog(acknowledgement!.messageIdentifier.toString());
//     } catch (e) {
//       // Utility.printILog('error in subscription');
//     }
//     update();
//   }
//
//   void unSubscribe() {
//     // Utility.printILog('clicked unsubscribe');
//     try {
//       _mqttServerClient!.unsubscribe('Message/$userID');
//       // Utility.printILog('mqttnew UnSubscription success');
//     } catch (e) {
//       // Utility.printILog('Error in unsubscription $e');
//     }
//   }
//
//   Future<String> publishMessage(
//       String message,
//       String receiverID,
//       String chatID,
//       int timeStamp,
//       int messageId,
//       int messageType,
//       String image,
//       String? fileName,
//       int? fileSize,
//       String? thumbnail,
//       ) async {
//     var connectionStatus = _mqttServerClient!.connectionStatus;
//     // Utility.printILog('mqttnew connection status $connectionStatus');
//     // Utility.printILog(
//     //     'mqttnew connection message ${_mqttServerClient!.connectionMessage}');
//
//     final builder = MqttClientPayloadBuilder();
//
//     var dataToSend = '';
//
//     if (messageType == 10) {
//       dataToSend =
//       '{"username":"$userID","client_id":"$userID","senderId":"$userID","receiverId":"$receiverID","payload":"$message","chatId":"$chatID","timestamp":$timeStamp,"messageId":$messageId,"messageType":$messageType,"actionType":1,"initiated":false,"retain":true,"topic":"Message/$receiverID","qos":2,"userImage":"$image","mountpoint":"","fileName":"$fileName","dataSize":"$fileSize","selfMessage":false}';
//     } else if (messageType == 3) {
//       dataToSend =
//       '{"username":"$userID","client_id":"$userID","senderId":"$userID","thumbnail":"$thumbnail","receiverId":"$receiverID","payload":"$message","chatId":"$chatID","timestamp":$timeStamp,"messageId":$messageId,"messageType":$messageType,"actionType":1,"initiated":false,"retain":true,"topic":"Message/$receiverID","qos":2,"userImage":"$image","mountpoint":"","selfMessage":false}';
//     } else {
//       dataToSend =
//       '{"username":"$userID","client_id":"$userID","senderId":"$userID","receiverId":"$receiverID","payload":"$message","chatId":"$chatID","timestamp":$timeStamp,"messageId":$messageId,"messageType":$messageType,"actionType":1,"initiated":false,"retain":true,"topic":"Message/$receiverID","qos":2,"userImage":"$image","mountpoint":"","selfMessage":false}';
//     }
//     builder.addUTF8String(dataToSend);
//     var pubStatus = _mqttServerClient!.publishMessage(
//         'Message/$receiverID', MqttQos.atMostOnce, builder.payload!,
//         retain: true);
//
//     // Utility.printILog('publish message $pubStatus');
//     update();
//     return dataToSend;
//   }
//
//   void disconnected() {
//     // Utility.printILog('Disconnected');
//     _mqttServerClient!.disconnect();
//   }
//
//   void setupMqttConnection2() async {
//     // _mqttServerClient =MqttServerClient('wss://dev-mqtts.vief.app', userID);
//     // _mqttServerClient?.port=2052;
//     // _mqttServerClient?.useWebSocket=true;
//     // _mqttServerClient?.websocketProtocols = MqttClientConstants.protocolsSingleDefault;
//     // _mqttServerClient?.setProtocolV311();
//     _mqttServerClient = MqttServerClient.withPort(
//       'broker.emqx.io',
//       //wss://dev-mqtts.vief.app:2083/mqtt
//       '${chatController.data[chatController.userIndex]['name']}.',
//       1883,
//       maxConnectionAttempts: 5,
//     )..keepAlivePeriod = 60;
//
//     _mqttServerClient!
//       ..logging(
//         on: true,
//       )
//       ..onConnected = _onConnected
//       ..onDisconnected = _onDisconnected
//       ..onUnsubscribed = _onUnSubscribed
//       ..onSubscribed = _onSubscribed
//       ..onSubscribeFail = _onSubscribeFailed
//       ..autoReconnect = true
//       ..secure = false
//       ..pongCallback = _pong;
//
//     //DEV
//     // dev-mqtts.vief.app
//     // 'prosensDevMqtt',
//     // 'fRCw3FCNekPhpbp3VeF7vv',
//
//     //PROD
//     //mqtts.vief.app
//     //prosensMqtt
//     //HNHbgb7b8Fj43U3CjsYt
//
//     // _mqttServerClient!.connectionMessage = connMessage;
//
//     try {
//       // await _mqttServerClient!.connect('prosensDevMqtt','fRCw3FCNekPhpbp3VeF7vv');
//       await _mqttServerClient!.connect('rahul','Rahul@123');
//
//       var connectStatus =
//           _mqttServerClient!.connectionStatus!.returnCode!.index;
//       // Utility.printILog('connectStatus in connect $connectStatus');
//       // Utility.printILog('mqttnew is connected to client');
//       subscribeTo();
//     } catch (e) {
//       _mqttServerClient!.disconnect();
//     }
//   }
// }
