import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:objectbox_with_chat/app/navigators/routes_managment.dart';
import 'package:objectbox_with_chat/app/pages/chat_user/chat_user_controller.dart';

class ChatUser extends StatelessWidget {
  const ChatUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GetBuilder<ChatUserController>(
      builder: (controller) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title:  const Text('Chats',style: TextStyle(color: Colors.red, fontSize: 25,fontWeight: FontWeight.bold),),
            leading: Icon(Icons.adaptive.arrow_back,color: Colors.red,),
            elevation: 1,
            // centerTitle: true,
          ),
          body: SizedBox(
            height: Get.height,
            child: ListView.separated(
                itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        // Get.to(ChatPage(index: index));
                        RouteManagement.goToChatPage(index);
                        // controller.userIndex = index;
                        controller.userName = controller.data[index].name ?? '';
                        controller.pendingMessage = true;
                        controller.pendingMessageSettle();
                        controller.checkMessageData();
                        controller.loadMessages();
                        controller.update();
                      },
                      child: ListTile(
                        // minLeadingWidth: 50,
                        leading: Stack(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 5,
                                      spreadRadius: 0,
                                      offset: Offset(0, 0)),
                                ],
                                color: Colors.white,
                              ),
                              padding: const EdgeInsets.all(2),
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(50)),
                                child: Image.network(
                                    controller.data[index].image.toString()),
                              ),
                            ),
                            controller.data[index].online!
                                ? Positioned(
                                    bottom: 1,
                                    right: 0,
                                    child: Container(
                                      width: 15,
                                      height: 15,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white,width: 2),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(50)),
                                          color: Colors.green,)
                                    ),
                                  )
                                : const SizedBox(
                                    width: 0,
                                    height: 0,
                                  )
                          ],
                        ),
                        title: Text(
                          controller.data[index].name.toString(),
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(controller.messageSender ==
                                controller.data[index].name
                            ? controller.lastMessage
                            : ''),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(controller.messageSender ==
                                    controller.data[index].name
                                ? controller.lastTime
                                : ''),
                            const SizedBox(
                              height: 5,
                            ),
                            controller.numberOfMessage == 0
                                ? const SizedBox(
                              width: 20,
                              height: 20,
                            )
                                : controller.messageSender ==
                                        controller.data[index].name
                                    ? Container(
                                        alignment: Alignment.center,
                                        width: 20,
                                        height: 20,
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            color: Colors.red),
                                        child: Text(
                                          controller.numberOfMessage.toString(),
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                      )
                                    : const SizedBox()
                          ],
                        ),
                      ),
                    ),
                separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                itemCount: controller.data.length),
          )));
}
