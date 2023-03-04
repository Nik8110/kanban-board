import 'package:boardview/board_item.dart';
import 'package:boardview/board_list.dart';
import 'package:boardview/boardview.dart';
import 'package:boardview/boardview_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kanban_board_app/controllers/board_controller.dart';
import 'package:kanban_board_app/views/components/task_add_edit.dart';
import 'package:kanban_board_app/views/widgets/custom_app_bar.dart';
import 'package:kanban_board_app/views/widgets/custom_drawer.dart';
import 'package:kanban_board_app/views/widgets/task_card.dart';

import '../models/board_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  BoardViewController boardViewController = BoardViewController();
  final boardController = Get.put(BoardController());
  Tasks? task;

  Future<bool> _onWillPop(BuildContext context) async {
    bool? exitResult = await showDialog(
      context: context,
      builder: (context) => _buildExitDialog(context),
    );
    return exitResult ?? false;
  }

  CollectionReference toDO = FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    //  _getTasks();
    super.initState();
  }

  AlertDialog _buildExitDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Please confirm!'),
      content: const Text('Do you want to exit?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            'no',
            style: TextStyle(color: Get.theme.primaryColor),
          ),
        ),
        TextButton(
          onPressed: () => SystemNavigator.pop(),
          child: Text(
            'yes',
            style: TextStyle(color: Get.theme.primaryColor),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: const CustomAppBar(),
          endDrawer: const CustomDrawer(),
          body: Obx(
            () => BoardView(
              scrollbar: true,
              lists: boardController.columnList
                  .map((col) => BoardList(
                        onStartDragList: (int? listIndex) {},
                        onTapList: (int? listIndex) async {},
                        onDropList: (int? listIndex, int? oldListIndex) {
                          var list = boardController.columnList[oldListIndex!];
                          boardController.columnList.removeAt(oldListIndex);
                          boardController.columnList.insert(listIndex!, list);
                        },
                        headerBackgroundColor:
                            Get.theme.primaryColor.withOpacity(0.15),
                        backgroundColor:
                            Get.theme.primaryColor.withOpacity(0.10),
                        header: [
                          Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    col.title!,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 20),
                                  ))),
                          IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isDismissible: true,
                                  builder: (BuildContext context) {
                                    return TaskAddEdit(
                                      column: col,
                                    );
                                  },
                                );
                              },
                              color: Colors.green,
                              icon: const Icon(Icons.add)),
                        ],
                        items: col.tasks
                            ?.map<BoardItem>((task) => BoardItem(
                                onStartDragItem: (int? listIndex,
                                    int? itemIndex, BoardItemState? state) {},
                                onDropItem: (int? listIndex,
                                    int? itemIndex,
                                    int? oldListIndex,
                                    int? oldItemIndex,
                                    BoardItemState? state) {
                                  var item = boardController
                                      .columnList[oldListIndex!]
                                      .tasks![oldItemIndex!];
                                  boardController
                                      .columnList[oldListIndex].tasks!
                                      .removeAt(oldItemIndex);
                                  boardController.columnList[listIndex!].tasks!
                                      .insert(itemIndex!, item);
                                },
                                onTapItem: (int? listIndex, int? itemIndex,
                                    BoardItemState? state) async {},
                                item: TaskCard(
                                  col: col,
                                  ontap: setState,
                                  task: task,
                                )))
                            .toList(),
                      ))
                  .toList(),
              boardViewController: boardViewController,
            ),
          ),
        ));
  }
}
