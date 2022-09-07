import 'package:get/get.dart';
import 'package:objectbox_with_chat/app/pages/chat_user/chat_user.dart';
import 'package:objectbox_with_chat/app/pages/chat_user/widget/chat_page.dart';

import '../pages/chat_user/chat_user_binding.dart';

part 'app_routes.dart';

class AppPages {
  static var transitionDuration = const Duration(milliseconds: 300);

  static const initial = Routes.chatUser;

  static final pages = [
    GetPage<ChatUser>(
      name: _Paths.chatUser,
      transitionDuration: transitionDuration,
      page: ChatUser.new,
      binding: ChatUserBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<ChatPage>(
      name: _Paths.chatPage,
      transitionDuration: transitionDuration,
      page: ChatPage.new,
      binding: ChatUserBinding(),
      transition: Transition.cupertino,
    ),
  ];
}
