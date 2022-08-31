import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:objectbox/objectbox.dart';
import 'package:objectbox_with_chat/chat_message/chat_controller.dart';
import 'package:objectbox_with_chat/chat_message/chat_page.dart';

import 'objectbox.dart';

/// Provides access to the ObjectBox Store throughout the app.
late ObjectBox objectbox;

Future<void> main() async {
  // This is required so ObjectBox can get the application directory
  // to store the database in.
  WidgetsFlutterBinding.ensureInitialized();

  objectbox = await ObjectBox.create();

  runApp(const GetMaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  var controller = Get.put(ChatController()) ;
  //
  // void initSate(){
  //   controller;
  //   super.initState();
  // }

  // var controller = Get.put(ChatController()) ;

  @override
  Widget build(BuildContext context)=> GetBuilder<ChatController>(builder: (controllers)=> Scaffold(
    appBar: AppBar(
      title: const Text('Chat'),
      centerTitle: true,
    ),
    body: SizedBox(
      height: Get.height,
      child: ListView.separated(
          itemBuilder: (context, index) => GestureDetector(
            onTap: (){
              Get.to(ChatPage(index: index,));
              controller.userIndex = index;
              controller.update();

            },
            child: ListTile(
              leading: Stack(
                children: [
                  CircleAvatar(
                    backgroundImage:
                    NetworkImage(controller.data[index]['image'].toString()),
                  ),
                  controller.data[index]['online']
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
              title: Text(controller.data[index]['name'].toString()),
              subtitle: Text(controller.data[index]['message'].toString()),
              trailing: Text(controller.data[index]['time'].toString()),
            ),
          ),
          separatorBuilder: (context, index) => const SizedBox(
            height: 10,
          ),
          itemCount: controller.data.length),
    ),
  ));
}
