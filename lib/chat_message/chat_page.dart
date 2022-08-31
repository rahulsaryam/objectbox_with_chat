import 'dart:convert';
import 'dart:io' show File, Platform;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:objectbox_with_chat/chat_message/mqtt_controller.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import '../models.dart';
import '../widget/enlarger_widget.dart';
import 'chat_controller.dart';
import 'package:http/http.dart' as http;

class ChatPage extends StatefulWidget {
  ChatPage({Key? key, required this.index}) : super(key: key);

  int index;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final chatController = Get.put(ChatController());
  final mqttController = Get.put(MqttController());

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    // manager.disconnect();
    mqttController.disconnect();
    // chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GetBuilder<MqttController>(
      builder: (controller) => Scaffold(
            // appBar: AppBar(
            //   leadingWidth: 30,
            //   actions: [
            //     GestureDetector(
            //       child: const Icon(Icons.attach_file),
            //       onTap: () {
            //         _handleAtachmentPressed();
            //       },
            //     ),
            //     PopupMenuButton<int>(
            //       itemBuilder: (context) => [
            //         // PopupMenuItem 1
            //         PopupMenuItem(
            //           value: 1,
            //           // row with 2 children
            //           child: Row(
            //             children: const [
            //               Icon(
            //                 Icons.delete,
            //                 color: Colors.black,
            //               ),
            //               SizedBox(
            //                 width: 10,
            //               ),
            //               Text('Delete Chat')
            //             ],
            //           ),
            //         ),
            //         // PopupMenuItem 2
            //         PopupMenuItem(
            //           value: 2,
            //           // row with two children
            //           child: Row(
            //             children: const [
            //               Icon(
            //                 Icons.block,
            //                 color: Colors.red,
            //               ),
            //               SizedBox(
            //                 width: 10,
            //               ),
            //               Text(
            //                 'Block User',
            //                 style: TextStyle(color: Colors.red),
            //               )
            //             ],
            //           ),
            //         ),
            //       ],
            //       elevation: 2,
            //       // on selected we show the dialog box
            //       onSelected: (value) {
            //         // if value 1 show dialog
            //         if (value == 1) {
            //           // _showDialog(context);
            //           // if value 2 show dialog
            //         } else if (value == 2) {
            //           // _showDialog(context);
            //         }
            //       },
            //     ),
            //   ],
            //   title: Row(
            //     children: [
            //       Stack(
            //         children: [
            //           CircleAvatar(
            //             backgroundImage: NetworkImage(
            //                 controller.data[widget.index]['image'].toString()),
            //           ),
            //           controller.data[widget.index]['online']
            //               ? Positioned(
            //                   bottom: 0,
            //                   right: 0,
            //                   child: Container(
            //                     width: 12,
            //                     height: 12,
            //                     decoration: const BoxDecoration(
            //                         borderRadius:
            //                             BorderRadius.all(Radius.circular(50)),
            //                         color: Colors.greenAccent),
            //                   ),
            //                 )
            //               : const SizedBox(
            //                   width: 0,
            //                   height: 0,
            //                 )
            //         ],
            //       ),
            //       const SizedBox(
            //         width: 10,
            //       ),
            //       Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(controller.data[widget.index]['name'].toString()),
            //           const SizedBox(
            //             height: 2,
            //           ),
            //           controller.data[widget.index]['online']
            //               ? const Text(
            //                   'Active',
            //                   style: TextStyle(fontSize: 15),
            //                 )
            //               : const SizedBox(
            //                   height: 0,
            //                   width: 0,
            //                 )
            //         ],
            //       )
            //     ],
            //   ),
            // ),
            // body: Padding(
            //   padding: const EdgeInsets.all(20.0),
            //   child: SizedBox(
            //     height: 700,
            //     child: ListView.separated(itemBuilder: (context,index) => Text(list[index]), separatorBuilder: (context,index) => SizedBox(height: 10,), itemCount: list.length)
            //   ),
            // ),
            // bottomSheet: Padding(
            //     padding: const EdgeInsets.all(15),
            //     child: TextField(
            //       controller: _messageTextController,
            //       decoration: InputDecoration(
            //         suffixIcon: GestureDetector(
            //           child: const Icon(Icons.send),
            //           onTap: () {
            //             _publishMessage(_messageTextController.text);
            //           },
            //         ),
            //         border: const OutlineInputBorder(),
            //         hintText: 'Enter Message',
            //       ),
            //     )),

            body: Chat(
              key: UniqueKey(),
              // fileMessageBuilder: ,
              messages: mqttController.messages,
              // onAttachmentPressed: _handleAtachmentPressed,
              onMessageTap: _handleMessageTap,
              // onPreviewDataFetched: _handlePreviewDataFetched,
              onSendPressed: _handleSendPressed,
              showUserAvatars: true,
              showUserNames: true,
              appBarWidget: AppBar(
                leading: InkWell(
                  child: const Icon(Icons.arrow_back),
                  onTap: (){
                    chatController.loadLastMessage();
                    Get.back<void>();



                  },
                ),
                leadingWidth: 30,
                actions: [
                  GestureDetector(
                    child: const Icon(Icons.attach_file),
                    onTap: () {
                      _handleAtachmentPressed();
                    },
                  ),
                  PopupMenuButton<int>(
                    itemBuilder: (context) => [
                      // PopupMenuItem 1
                      PopupMenuItem(
                        value: 1,
                        // row with 2 children
                        child: Row(
                          children: const [
                            Icon(
                              Icons.delete,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Delete Chat')
                          ],
                        ),
                      ),
                      // PopupMenuItem 2
                      PopupMenuItem(
                        value: 2,
                        // row with two children
                        child: Row(
                          children: const [
                            Icon(
                              Icons.block,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Block User',
                              style: TextStyle(color: Colors.red),
                            )
                          ],
                        ),
                      ),
                    ],
                    elevation: 2,
                    // on selected we show the dialog box
                    onSelected: (value) {
                      // if value 1 show dialog
                      if (value == 1) {
                        // _showDialog(context);
                        // if value 2 show dialog
                      } else if (value == 2) {
                        // _showDialog(context);
                      }
                    },
                  ),
                ],
                title: Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(chatController
                              .data[widget.index]['image']
                              .toString()),
                        ),
                        chatController.data[widget.index]['online']
                            ? Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                      color: Colors.greenAccent),
                                ),
                              )
                            : const SizedBox(
                                width: 0,
                                height: 0,
                              )
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(chatController.data[widget.index]['name']
                            .toString()),
                        const SizedBox(
                          height: 2,
                        ),
                        chatController.data[widget.index]['online']
                            ? const Text(
                                'Active',
                                style: TextStyle(fontSize: 15),
                              )
                            : const SizedBox(
                                height: 0,
                                width: 0,
                              )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ));

  void _handleAtachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
          createdAt: DateTime.now().millisecondsSinceEpoch,
          fileName: 'sample.pdf',
          payload: 'http://www.africau.edu/images/default/sample.pdf',
          dataSize: result.files.single.size,
          initiated: true,
          messageType: 10,
          senderId: 'b',
          receiverId: chatController.data[widget.index]['name']);
      mqttController.addMessage(message);
      mqttController.publish(
          message.createdAt!,
          message.payload!,
          message.initiated!,
          message.messageType!,
          message.senderId!,
          message.receiverId!,
          fileName: message.fileName!,
          dataSize: message.dataSize);
      mqttController.checkId = message.receiverId!;
      mqttController.update();
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 25,
      source: ImageSource.gallery,
    );
    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        payload: utf8.fuse(base64).encode(
            'https://images.unsplash.com/photo-1480074568708-e7b720bb3f09?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8N3x8aG9tZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60'),
        fileName: result.name,
        dataSize: bytes.length,
        messageType: 2,
        initiated: true,
        senderId: 'b',
        receiverId: chatController.data[widget.index]['name'],
        width: image.width.toDouble(),
      );

      mqttController.publish(
          message.createdAt!,
          message.payload!,
          message.initiated!,
          message.messageType!,
          message.senderId!,
          message.receiverId!,
          fileName: message.fileName!,
          dataSize: message.dataSize,
          width: message.width!,
          height: message.height!);
      mqttController.addMessage(message);
      mqttController.checkId = message.receiverId!;
      mqttController.update();
    }
  }

  void _handleMessageTap(types.MessageData message) async {
    if (message is types.FileMessage) {
      // await launch(message.payload!);
      var localPath = message.payload;

      if (message.payload!.startsWith('http')) {
        try {
          // final index =
          // _messages.indexWhere((element) => element.id == message.id);
          // final updatedMessage =
          // (_messages[index] as types.FileMessage).copyWith(
          //   isLoading: true,
          // );
          //
          // setState(() {
          //   _messages[index] = updatedMessage;
          // });

          final client = http.Client();
          final request = await client.get(Uri.parse(message.payload!));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.fileName}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          // final index =
          // _messages.indexWhere((element) => element.id == message.id);
          // final updatedMessage =
          // (_messages[index] as types.FileMessage).copyWith(
          //   isLoading: null,
          // );

          // setState(() {
          //   _messages[index] = updatedMessage;
          // });
        }
      }
      await OpenFile.open(localPath);
    } else if (message is types.ImageMessage) {
      await Get.dialog<dynamic>(ImageEnlarger(
          imageUrl: [utf8.fuse(base64).decode(message.payload.toString())]));
    }

    // void _handlePreviewDataFetched(
    //     types.TextMessage message,
    //     types.PreviewData previewData,
    //     ) {
    //   final index = _messages.indexWhere((element) => element.id == message.id);
    //   final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
    //     previewData: previewData,
    //   );
    //
    //   setState(() {
    //     _messages[index] = updatedMessage;
    //   });
  }

  void _handleSendPressed(types.PartialText message) {
    // mqttController.handleSendPressed(message.text, 1);
    final textMessage = types.TextMessage(
        createdAt: DateTime.now().millisecondsSinceEpoch,
        payload: utf8.fuse(base64).encode(message.text),
        initiated: true,
        messageType: 1,
        senderId: 'b',
        receiverId: chatController.data[widget.index]['name']);

    mqttController.publish(
        textMessage.createdAt!,
        textMessage.payload.toString(),
        textMessage.initiated!,
        textMessage.messageType!,
        textMessage.senderId!,
        textMessage.receiverId!);
    mqttController.addMessage(textMessage);
    mqttController.checkId = textMessage.receiverId!;
    mqttController.update();
  }

  void _loadMessages() async {
    print('loading');
    print(mqttController.userName);
    final responses = objectbox.noteBox.getAll();
    for (var x = 0; x < responses.length; x++) {
      if (mqttController.userName == responses[x].receiverId) {
        final messages = responses[x]
            .mainMessageData!
            .map((e) => types.MessageData.fromJson(
                json.decode(e) as Map<String, dynamic>))
            .toList()
            .reversed;
        setState(() {
          mqttController.messages = messages.toList();
        });
        // print('${responses[x].id} ${responses[x].receiverId} ${responses[x].mainMessageData}');
      }
    }
    // print('list of object ${responses[0].mainMessageData}');
    //   List<Tag> tags = responses
    //       .map((e) => Tag(
    //           initiated: e.initiated,
    //           messageId: e.messageId,
    //           messageType: e.messageType,
    //           receiverId: e.receiverId,
    //           senderId: e.senderId,
    //           payload: e.payload,
    //           createdAt: e.createdAt,
    //           dataSize: e.dataSize,
    //           delivered: e.delivered,
    //           deliveredAt: e.deliveredAt,
    //           fileName: e.fileName,
    //           offerReplyStatus: e.offerReplyStatus,
    //           read: e.read,
    //           status: e.status,
    //           thumbnail: e.thumbnail))
    //       .toList();
    //   String jsonTags = jsonEncode(tags);
    //   print('databaselength ${jsonTags}');
    //   // final response = await rootBundle.loadString('assets/messages.json');
    //   final messages = (jsonDecode(responses[0].mainMessageData!) as List)
    //       .map((e) => types.MessageData.fromJson(e as Map<String, dynamic>))
    //       .toList()
    //       .reversed;
    //   setState(() {
    //     print('main List ${messages.length}');
    //     mqttController.messages = messages.toList();
    //   });
  }
}

class Tag {
  bool? initiated;
  int? messageId;
  String? senderId;
  String? receiverId;
  String? payload;
  int? messageType;
  int? createdAt;
  int? status;
  int? delivered;
  int? read;
  int? deliveredAt;
  dynamic offerReplyStatus;
  String? thumbnail;
  String? fileName;
  int? dataSize;

  Tag(
      {this.initiated,
      this.read,
      this.senderId,
      this.receiverId,
      this.payload,
      this.messageId,
      this.offerReplyStatus,
      this.messageType,
      this.thumbnail,
      this.fileName,
      this.deliveredAt,
      this.delivered,
      this.dataSize,
      this.status,
      this.createdAt});

  Map toJson() => {
        'initiated': initiated,
        'messageId': messageId,
        'senderId': senderId,
        'receiverId': receiverId,
        'payload': payload,
        'messageType': messageType,
        'createdAt': createdAt,
        'status': status,
        'delivered': delivered,
        'read': read,
        'deliveredAt': deliveredAt,
        'offerReplyStatus': offerReplyStatus,
        'thumbnail': thumbnail,
        'fileName': fileName,
        'dataSize': dataSize,
      };
}