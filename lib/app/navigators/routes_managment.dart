import 'package:get/get.dart';
import 'package:objectbox_with_chat/app/navigators/app_pages.dart';

abstract class RouteManagement{
  static void goToChatUser(){
    Get.toNamed<void>(Routes.chatUser);
  }

  static void goToChatPage(int index){
    Get.toNamed<void>(Routes.chatPage,arguments: index);
  }
}