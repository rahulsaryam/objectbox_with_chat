import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:objectbox_with_chat/app/navigators/routes_managment.dart';
import 'package:objectbox_with_chat/app/pages/chat_user/chat_user_controller.dart';
import 'package:objectbox_with_chat/app/theme/colors_value.dart';
import 'package:objectbox_with_chat/app/theme/dimens.dart';
import 'package:objectbox_with_chat/app/theme/style.dart';

class ChatUser extends StatelessWidget {
  const ChatUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GetBuilder<ChatUserController>(
      builder: (controller) => Scaffold(
          appBar: AppBar(
            backgroundColor: ColorsValue.whiteColor,
            title: Text(
              'Chats',
              style: Styles.boldRed28,
            ),
            leading: Padding(
              padding: Dimens.edgeInsetsLeft10,
              child: Icon(
                Icons.adaptive.arrow_back,
                color: ColorsValue.lightRedColor,
                size: Dimens.thirty,
              ),
            ),
            leadingWidth: Dimens.fourty,
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
                        controller.userName =
                            controller.data[index].name ?? '';
                        controller.pendingMessage = true;
                        controller.pendingMessageSettle();
                        controller.checkMessageData();
                        controller.loadMessages();
                        controller.update();
                      },
                      child: ListTile(
                        leading: Stack(
                          children: [
                            Container(
                              width: Dimens.fourtyNine,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Dimens.fifty)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: Dimens.three,
                                      spreadRadius: Dimens.zero,
                                      offset: Offset(
                                          Dimens.zero, Dimens.zero)),
                                ],
                                color: ColorsValue.whiteColor,
                              ),
                              padding: Dimens.edgeInsets2,
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Dimens.fifty)),
                                child: Image.network(controller
                                    .data[index].image
                                    .toString()),
                              ),
                            ),
                            controller.data[index].online!
                                ? Positioned(
                                    bottom: Dimens.five,
                                    right: Dimens.zero,
                                    child: Container(
                                        width: Dimens.ten,
                                        height: Dimens.ten,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                                  ColorsValue.whiteColor,
                                              width: Dimens.one),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  Dimens.fifty)),
                                          color: ColorsValue.greenColor,
                                        )),
                                  )
                                : Dimens.box0
                          ],
                        ),
                        title: Text(
                          controller.data[index].name.toString(),
                          style: Styles.BoldGrey16,
                        ),
                        subtitle: Text(
                          controller.messageSender ==
                                  controller.data[index].name
                              ? controller.lastMessage
                              : '',
                          style: Styles.mediumGrey12,
                        ),
                        trailing: Padding(
                          padding: Dimens.edgeInsetsTop5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                controller.messageSender ==
                                        controller.data[index].name
                                    ? controller.lastTime
                                    : '',
                                style: Styles.lightGrey10,
                              ),
                              Dimens.boxHeight10,
                              controller.numberOfMessage == 0
                                  ? Dimens.boxHeight20
                                  : controller.messageSender ==
                                          controller.data[index].name
                                      ? Container(
                                          alignment: Alignment.center,
                                          width: Dimens.fifteen,
                                          height: Dimens.fifteen,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(
                                                          Dimens.ten)),
                                              color: ColorsValue
                                                  .lightRedColor),
                                          child: Text(
                                            controller.numberOfMessage
                                                .toString(),
                                            style: Styles.white8,
                                          ),
                                        )
                                      : const SizedBox()
                            ],
                          ),
                        ),
                      ),
                    ),
                separatorBuilder: (context, index) => Dimens.boxHeight10,
                itemCount: controller.data.length),
          )));
}
