import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:kanban_board_app/controllers/board_controller.dart';
import 'package:kanban_board_app/models/board_model.dart';
import 'package:kanban_board_app/utils/const.dart';

import '../components/task_add_edit.dart';

class TaskCard extends StatelessWidget {
  TaskCard({
    super.key,
    required this.col,
    required this.ontap,
    required this.task,
  });

  final BoardModel col;
  final Tasks task;
  final Function(void Function()) ontap;
  final BoardController boardController = Get.find();
  PopItem? selectedMenu;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                    child: Text(
                  task.title.toString(),
                  style: const TextStyle(fontSize: 18),
                )),
                PopupMenuButton<PopItem>(
                  icon: const Icon(Icons.more_vert_rounded,
                      color: Colors.black54),
                  initialValue: selectedMenu,
                  onSelected: (PopItem item) async {
                    _onSelect(item: item, context: context);
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<PopItem>>[
                    const PopupMenuItem<PopItem>(
                      value: PopItem.edit,
                      child:
                          Text('Edit', style: TextStyle(color: Colors.black54)),
                    ),
                    PopupMenuItem<PopItem>(
                      value: PopItem.delete,
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Colors.red.withOpacity(0.6)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              task.description.toString(),
              style: const TextStyle(color: Colors.grey),
            ),
            const Divider(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.create_new_folder_outlined,
                        size: 12,
                        color: Colors.grey,
                      ),
                      Flexible(
                          child: Text(
                        " ${Jiffy(task.createdAt).fromNow()}",
                        style:
                            const TextStyle(fontSize: 10, color: Colors.grey),
                      )),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.edit,
                        size: 12,
                        color: Colors.grey,
                      ),
                      Flexible(
                          child: Text(
                        " ${Jiffy(task.createdAt).fromNow()}",
                        style:
                            const TextStyle(fontSize: 10, color: Colors.grey),
                      )),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                task.duration == null
                    ? const SizedBox()
                    : Expanded(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.watch_later_outlined,
                              size: 12,
                              color: Colors.grey,
                            ),
                            Flexible(
                                child: Text(
                              " ${task.duration ?? "-"}",
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.grey),
                            )),
                          ],
                        ),
                      ),
                task.duration == null
                    ? const SizedBox()
                    : Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(
                              Icons.done_all_rounded,
                              size: 12,
                              color: Colors.grey,
                            ),
                            Flexible(
                                child: Text(
                              " ${Jiffy(task.completedAt).fromNow()}",
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.grey),
                            )),
                          ],
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _onSelect({PopItem? item, BuildContext? context}) async {
    selectedMenu = item;
    if (item == PopItem.edit) {
      await showModalBottomSheet(
        isDismissible: true,
        context: context!,
        builder: (BuildContext context) {
          return TaskAddEdit(
            column: col,
            task: task,
          );
        },
      );
    } else {
      await showDialog(
        context: context!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text("The task will be deleted forever."),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
                color: Colors.red,
              ),
              IconButton(
                onPressed: () async {
                  print('DELETE::::::');
                  await boardController
                      .deleteTask(col.id!, task.id!)
                      .whenComplete(() {
                    //   Navigator.pop(context);
                  });
                },
                icon: const Icon(Icons.check),
                color: Colors.green,
              ),
            ],
          );
        },
      );
    }
  }
}
