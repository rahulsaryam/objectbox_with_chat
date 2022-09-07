
import 'package:get/instance_manager.dart';
import 'package:objectbox_with_chat/app/pages/chat_user/mqtt_controller.dart';

import 'chat_user_controller.dart';

/// A list of bindings which will be used in the route of [ProfileScreen].
///
class ChatUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatUserController>(() => ChatUserController(),fenix: true);
    Get.lazyPut<MqttController>(() => MqttController(),fenix: true);
  }
}