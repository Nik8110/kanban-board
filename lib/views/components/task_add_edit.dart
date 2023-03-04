import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:kanban_board_app/controllers/board_controller.dart';
import 'package:kanban_board_app/models/board_model.dart';
import 'package:kanban_board_app/views/widgets/custom_textfield.dart';
import 'package:kanban_board_app/views/widgets/date_widget.dart';

import '../../controllers/home_controller.dart';

class TaskAddEdit extends StatefulWidget {
  final BoardController boardController = Get.find();
  final BoardModel column;
  final Tasks? task;

  TaskAddEdit({
    super.key,
    this.task,
    required this.column,
  });

  @override
  State<TaskAddEdit> createState() => _TaskAddEditState();
}

class _TaskAddEditState extends State<TaskAddEdit> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController taskTitleController;

  late TextEditingController taskDescriptionController;

  TextEditingController? dateController;
  TextEditingController? timeController;
  CollectionReference toDO = FirebaseFirestore.instance.collection('users');
  BoardController? controller;

  @override
  void initState() {
    taskTitleController = TextEditingController(text: widget.task?.title);
    controller = Get.find<BoardController>();
    taskDescriptionController =
        TextEditingController(text: widget.task?.description);
    super.initState();
  }

  @override
  void dispose() {
    taskTitleController.dispose();
    taskDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 15, right: 15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.task == null ? 'Add Task' : ' Edit Task',
              style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 25,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: GetBuilder<HomeController>(
                            id: 'dropDownIcon',
                            init: HomeController(),
                            builder: (controller) {
                              return DropdownButton(
                                iconSize: 4,
                                elevation: 6,
                                value: controller.selectedIcon,
                                underline: Container(color: Colors.transparent),
                                hint: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, top: 10),
                                  child: SvgPicture.asset(
                                    controller.icons.first,
                                    width: 40,
                                    height: 40,
                                  ),
                                ),
                                items: controller.icons.map(
                                  (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, top: 10),
                                        child: SizedBox(
                                          width: 40,
                                          child: SvgPicture.asset(value,
                                              width: 20, height: 20),
                                        ),
                                      ),
                                    );
                                  },
                                ).toList(),
                                onChanged: controller.changeIcon,
                                dropdownColor:
                                    Theme.of(context).primaryColorLight,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Get.height * 0.03),
                    Text(
                      "Title",
                      style:
                          TextStyle(color: Theme.of(context).primaryColorDark),
                    ),
                    InputTextFormField(
                      hintText: 'Title',
                      tController: taskTitleController,
                      textFeildColor: Theme.of(context).primaryColorLight,
                      contentTextColor: Theme.of(context).primaryColorDark,
                    ),
                    const SizedBox(height: 25),
                    Text(
                      "Description",
                      style:
                          TextStyle(color: Theme.of(context).primaryColorDark),
                    ),
                    InputTextFormField(
                      hintText: 'Description',
                      tController: taskDescriptionController,
                      textFeildColor: Theme.of(context).primaryColorLight,
                      contentTextColor: Theme.of(context).primaryColorDark,
                    ),
                    SizedBox(height: Get.height * 0.02),
                    DateWidget(
                      controler: controller!,
                    ),
                    SizedBox(height: Get.height * 0.015),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Text("Cancel",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.w700)),
                  color: Colors.red,
                ),
                IconButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (widget.task == null) {
                        await widget.boardController.addTask(
                            title: taskTitleController.text,
                            description: taskDescriptionController.text,
                            column: widget.column);
                      } else {
                        await widget.boardController.editTask(
                            title: taskTitleController.text,
                            description: taskDescriptionController.text,
                            task: widget.task!);
                      }
                      taskTitleController.clear();
                      Navigator.pop(context);
                    }
                  },
                  icon: Text(widget.task == null ? 'Add' : ' Edit',
                      style: const TextStyle(
                          color: Colors.green, fontWeight: FontWeight.w700)),
                  color: Colors.green,
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }
}
