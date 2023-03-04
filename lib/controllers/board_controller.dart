import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kanban_board_app/utils/local_storage_utils.dart';

import '../models/board_model.dart';

class BoardController extends GetxController {
  var columnList = <BoardModel>[].obs;

  @override
  void onInit() {
    getColumns();
    super.onInit();
  }

  var startDate = "".obs;
  var dueDate = "".obs;
  Rx<DateTime>? selectedTime = DateTime.now().obs;

  int uuid() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch;
  }

  CollectionReference toDO = FirebaseFirestore.instance.collection('users');

  Future deleteTask(int id, int taskId) async {
    try {
      final data = columnList.where((element) => element.id == id).first;

      var uid = await LocalStorageUtil.read("userId");
      if (data.id == id) {
        final id = await FirebaseFirestore.instance
            .collection("users")
            .where('uid', isEqualTo: uid)
            .get();
        FirebaseFirestore.instance
            .collection("users")
            .doc(id.docs.first.id)
            .collection("columns")
            .get()
            .then((value) {
          for (var e in value.docs) {
            if (e.get('id') == taskId) {
              FirebaseFirestore.instance
                  .collection("users")
                  .doc(id.docs.first.id)
                  .collection("columns")
                  .doc(e.reference.id)
                  .delete();
              data.tasks!.removeWhere((element) => element.id == taskId);
              getColumns();
              Get.back();
            }
          }
        });
      }
    } catch (e) {
      Get.snackbar("Failed to delete", "Try after sometime!");
    }
  }

  Future addColumn({required String title}) async {
    int id = uuid();
    BoardModel column = BoardModel(id: id, title: title, tasks: []);
    columnList.add(column);
    List columnJson = [];
    for (BoardModel item in columnList) {
      columnJson.add(item.toJson());
    }
    LocalStorageUtil.write("columns", jsonEncode(columnJson));

    columnList.refresh();
  }

  Future editColumn({required String title, required BoardModel column}) async {
    column.title = title;

    List columnJson = [];
    for (BoardModel item in columnList) {
      columnJson.add(item.toJson());
    }
    LocalStorageUtil.write("columns", jsonEncode(columnJson));
    columnList.refresh();
  }

  Future getColumns() async {
    var columnsStr = await LocalStorageUtil.read("columns");
    List columns = jsonDecode(columnsStr ?? "[]");
    var uid = await LocalStorageUtil.read("userId");
    FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: uid.toString())
        .snapshots()
        .listen((querySnapshot) async {
      if (querySnapshot.docs.isNotEmpty) {
        var documentSnapshot = querySnapshot.docs.first;
        FirebaseFirestore.instance
            .collection("users")
            .doc(documentSnapshot.id)
            .collection("columns")
            .snapshots()
            .listen((querySnapshot) {
          List<Tasks>? toDoTasks = querySnapshot.docs
              .map((doc) => Tasks.fromJson(
                    doc.data(),
                  ))
              .toList();
          if (columns.isEmpty) {
            columnList = [
              BoardModel(id: 1, title: "To-Do", tasks: []),
              BoardModel(id: 2, title: "In-Progress", tasks: []),
              BoardModel(id: 3, title: "Done", tasks: [])
            ].obs;
          } else {
            for (int i = 0; i < columns.length; i++) {
              var item = columns[i];
              List<Tasks>? taskas = [];
              print(item);
              if (item['id'] == 1) {
                taskas = toDoTasks
                    .where((element) => element.type == "todo")
                    .toList(growable: true);
                print(taskas.length);
              } else if (item['id'] == 2) {
                taskas = toDoTasks
                    .where((element) => element.type == "in progress")
                    .toList(growable: true);
              } else {
                taskas = toDoTasks
                    .where((element) => element.type == "done")
                    .toList(growable: true);
              }

              columnList.add(BoardModel(
                  id: item["id"], title: item["title"], tasks: taskas));
            }
          }
        });
      }
    });
  }

  Future deleteColumn(int id) async {
    columnList.removeWhere((element) => element.id == id);
    LocalStorageUtil.write("columns", jsonEncode(columnList));
  }

  Future addTask(
      {required String title,
      required String description,
      required BoardModel column}) async {
    int id = uuid();
    DateTime currentTime = DateTime.now();
    Tasks task = Tasks(
        id: id,
        title: title,
        description: description,
        createdAt: currentTime.toString(),
        updatedAt: currentTime.toString());

    var uid = await LocalStorageUtil.read("userId");

    String type;
    if (column.id == 1) {
      type = 'todo';
    } else if (column.id == 2) {
      type = 'in progress';
    } else {
      type = 'done';
    }
    toDO.where("uid", isEqualTo: uid).get().then((value) async {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(value.docs.first.id)
          .collection('columns')
          .add({
        'title': title,
        'description': description,
        'type': type,
        "id": id,
        "start_date": startDate.value,
        "end_date": dueDate.value,
        "selected_time": selectedTime!.value.toString()
      });
    });
    column.tasks?.add(task);

    List columnJson = [];
    for (BoardModel item in columnList) {
      columnJson.add(item.toJson());
    }

    LocalStorageUtil.write("columns", jsonEncode(columnJson));

    columnList.refresh();
  }

  Future editTask(
      {required String title,
      required String description,
      required Tasks task}) async {
    DateTime currentTime = DateTime.now();
    //update
    task.title = title;
    task.description = description;
    task.updatedAt = currentTime.toString();

    List columnJson = [];
    for (BoardModel item in columnList) {
      columnJson.add(item.toJson());
    }

    LocalStorageUtil.write("columns", jsonEncode(columnJson));

    columnList.refresh();
  }
}
