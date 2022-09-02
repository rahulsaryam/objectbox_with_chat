import 'dart:convert';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'models.dart';
import 'objectbox.g.dart';

// import 'objectbox.g.dart'; // created by `flutter pub run build_runner build`

/// Provides access to the ObjectBox Store throughout the app.
///
/// Create this in the apps main function.
class ObjectBox {
  ObjectBox._create(this.store) {
    // noteBox = Box<MessageModel>(store);

    noteBox = Box<UserMessage>(store);

    // final qBuilder = noteBox.query()
    //   ..order(Note_.date, flags: Order.descending);
    // queryStream = qBuilder.watch(triggerImmediately: true);

    // // Add some demo data if the box is empty.
    // if (noteBox.isEmpty()) {
    //   _putDemoData();
    // }
  }

  /// The Store of this app.
  late final Store store;

  /// A Box of notes.
  // late final Box<MessageModel> noteBox;

  late final Box<UserMessage> noteBox;

  // // /// A stream of all notes ordered by date.
  // late final Stream<Query<MessageModel>> queryStream;

  late final Stream<Query<UserMessage>> queryStream;

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart.
    final store = await openStore();
    return ObjectBox._create(store);
  }

  /// Add a note within a transaction.
  ///
  /// To avoid frame drops, run ObjectBox operations that take longer than a
  /// few milliseconds, e.g. putting many objects, in an isolate with its
  /// own Store instance.
  /// For this example only a single object is put which would also be fine if
  /// done here directly.
  Future<void> addNote(types.MessageData message) =>
      store.runInTransactionAsync(TxMode.write, _addNoteInTx, message);

  /// Note: due to [dart-lang/sdk#36983](https://github.com/dart-lang/sdk/issues/36983)
  /// not using a closure as it may capture more objects than expected.
  /// These might not be send-able to an isolate. See Store.runAsync for details.
  static void _addNoteInTx(Store store, types.MessageData message) async {
    List<String>? messageList;
    final user = store.box<UserMessage>().getAll();
    final messageInString = json.encode(message);
    var boxStore = store.box<UserMessage>();
    if (message.initiated == null) {
      messageList = [];
      store.box<UserMessage>().put(UserMessage(
          mainMessageData: messageList,
          receiverId: message.receiverId,
          senderId: message.senderId));
    } else {
      for (var x = 0; x < user.length; x++) {
        if (message.initiated!) {
          print('yes initiated ${message.initiated}');
          print('${message.receiverId} == ${user[x].receiverId}');
          if (message.receiverId == user[x].receiverId) {
            var index = boxStore.get(user[x].id);
            index?.mainMessageData?.add(messageInString);
            boxStore.put(index!);
            // break;
          }
        } else {
          print('yes initiated ${message.initiated}');
          print('${message.senderId} == ${user[x].receiverId}');
          if (message.senderId == user[x].receiverId) {
            var index = boxStore.get(user[x].id);
            index?.mainMessageData?.add(messageInString);
            boxStore.put(index!);
          }
        }
      }
    }

    // Perform ObjectBox operations that take longer than a few milliseconds
    // here. To keep it simple, this example just puts a single object.

    // store.box<MessageModel>().put(MessageModel(
    //     initiated: message.initiated,
    //     payload: message.payload,
    //     createdAt: message.createdAt,
    //     messageType: message.messageType,
    //     senderId: message.senderId,
    //     messageId: message.messageId,
    //     fileName: message.fileName,
    //     dataSize: message.dataSize,
    //     thumbnail: message.thumbnail,
    //
  }
}
