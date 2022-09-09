
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:objectbox_with_chat/app/navigators/app_pages.dart';
import 'package:objectbox_with_chat/app/pages/chat_user/chat_user_controller.dart';
import 'package:objectbox_with_chat/app/pages/chat_user/mqtt_controller.dart';
import 'objectbox.dart';

/// Provides access to the ObjectBox Store throughout the app.
late ObjectBox objectbox;



Future<void> main() async {
  // This is required so ObjectBox can get the application directory
  // to store the database in.
  WidgetsFlutterBinding.ensureInitialized();
  objectbox = await ObjectBox.create();
  initServices();
  runApp(const MyApp(),);
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 745),
        builder: (BuildContext c1,__) => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.system,
          theme: ThemeData(fontFamily: 'Circular Air Pro'),
          getPages: AppPages.pages,
          initialRoute: Routes.chatUser,
          enableLog: true,
          unknownRoute: AppPages.pages[0],
        ));
  }
}


// / Initialize the services
// before the app starts.
Future<void> initServices() async {

  /// Services
  Get.put<ChatUserController>(ChatUserController(),permanent: true
  );
  Get.put<MqttController>(MqttController(),permanent: true);
}


