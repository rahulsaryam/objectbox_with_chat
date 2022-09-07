import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:objectbox_with_chat/app/navigators/routes_managment.dart';
import 'package:objectbox_with_chat/app/pages/chat_user/chat_user_controller.dart';



class ChatUser extends StatelessWidget {
  const ChatUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GetBuilder<ChatUserController>(builder: (controller)=> Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        centerTitle: true,
      ),
      body: SizedBox(
        height: Get.height,
        child:
        ListView.separated(
            itemBuilder: (context, index) => GestureDetector(
              onTap: (){
                // Get.to(ChatPage(index: index));
                RouteManagement.goToChatPage(index);
                // controller.userIndex = index;
                controller.userName = controller.data[index]['name'] ?? '';
                controller.pendingMessage = true;
                controller.pendingMessageSettle();
                controller.checkMessageData();
                controller.loadMessages();
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
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(controller.data[index]['time'].toString()),
                    const SizedBox(height: 5,),
                  controller.numberOfMessage == 0 ? const SizedBox():  Container(
                      alignment: Alignment.center,
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.green
                      ),
                      child: Text(controller.numberOfMessage.toString() ,style: TextStyle(color: Colors.white),),
                    )
                  ],
                ),
              ),
            ),
            separatorBuilder: (context, index) => const SizedBox(
              height: 10,
            ),
            itemCount: controller.data.length),
      )
  ));
}
