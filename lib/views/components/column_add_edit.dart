import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanban_board_app/controllers/board_controller.dart';
import 'package:kanban_board_app/models/board_model.dart';
import 'package:kanban_board_app/views/widgets/custom_textfield.dart';

class ColumnAddEdit extends StatefulWidget {
  final BoardController boardController = Get.find();
  final BoardModel? column;

  ColumnAddEdit({super.key, this.column});

  @override
  State<ColumnAddEdit> createState() => _ColumnAddEditState();
}

class _ColumnAddEditState extends State<ColumnAddEdit> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController columnTitleController;

  @override
  void initState() {
    columnTitleController = TextEditingController(text: widget.column?.title);
    super.initState();
  }

  @override
  void dispose() {
    columnTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.column == null ? 'Add Column' : ' Edit Column'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            CustomTextField(
              hintText: "To-do",
            ),
          ],
        ),
      ),
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
            if (_formKey.currentState!.validate()) {
              if (widget.column == null) {
                await widget.boardController
                    .addColumn(title: columnTitleController.text);
              } else {
                await widget.boardController.editColumn(
                    title: columnTitleController.text, column: widget.column!);
              }
              columnTitleController.clear();
              Navigator.pop(context);
            }
          },
          icon: const Icon(Icons.check),
          color: Colors.green,
        ),
      ],
    );
  }
}
