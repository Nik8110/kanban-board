import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../controllers/board_controller.dart';

class DateWidget extends StatefulWidget {
  DateWidget({Key? key, required this.controler}) : super(key: key);

  final BoardController controler;

  @override
  State<DateWidget> createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {
  String? _dateCount;
  String? _range;
  bool isChecked = false; // changed the default value to false
  int selectedDates = 0;
  Size size = Get.size;
  DateRangePickerController? _controller;

  @override
  void initState() {
    _dateCount = '';
    _range = '';
    super.initState();
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      var startDate = DateFormat('dd/MM/yyyy').format(args.value);
      var dueDate = DateFormat('dd/MM/yyyy').format(args.value);
      if (isChecked == true) {
        widget.controler.startDate.value = startDate;
      } else {
        widget.controler.dueDate.value = dueDate;
      }
      if (args.value is PickerDateRange) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Get.dialog(AlertDialog(
          content: StatefulBuilder(builder: (context, setState) {
            return SizedBox(
              height: 525,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      Text(
                        "Dates",
                        style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.close),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                  Divider(
                    color: Theme.of(context).primaryColorDark,
                    thickness: 0.7,
                  ),
                  selectedDates == 0 || selectedDates == 1
                      ? SizedBox(
                          height: 300,
                          child: SfDateRangePicker(
                            onSelectionChanged: _onSelectionChanged,
                            showNavigationArrow: true,
                            controller: _controller,
                            selectionMode: DateRangePickerSelectionMode.single,
                            initialSelectedRange: PickerDateRange(
                              DateTime.now().subtract(const Duration(days: 4)),
                              DateTime.now().add(const Duration(days: 3)),
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 300,
                          child: TimePickerSpinner(
                            is24HourMode: false,
                            time: widget.controler.selectedTime!.value ??
                                DateTime.now(),
                            normalTextStyle: TextStyle(
                              fontSize: 24,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            highlightedTextStyle: const TextStyle(
                                fontSize: 24, color: Colors.black),
                            spacing: 50,
                            itemHeight: 80,
                            isForce2Digits: true,
                            onTimeChange: (time) {
                              setState(() {
                                widget.controler.selectedTime!.value = time;
                              });
                            },
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      "Start date",
                      style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked == true,
                        onChanged: (value) {
                          setState(() {
                            isChecked = value ?? false;
                            selectedDates = 0;
                          });
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDates = 0;
                          });
                        },
                        child: Container(
                            width: 120,
                            height: 45,
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.04),
                            decoration: BoxDecoration(
                              color: const Color(0xffeeeeee),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                                child: Text(
                              widget.controler.startDate.value == ""
                                  ? 'dd/MM/yyyy'
                                  : widget.controler.startDate.value.toString(),
                              style: const TextStyle(fontSize: 15),
                            ))),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      "Due date",
                      style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: !isChecked,
                        onChanged: (value) {
                          setState(() {
                            isChecked = !(value ?? true);
                            selectedDates = 1;
                          });
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDates = 1;
                          });
                        },
                        child: Container(
                            width: 120,
                            height: 45,
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.04),
                            decoration: BoxDecoration(
                              color: const Color(0xffeeeeee),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                                child: Text(
                              widget.controler.dueDate.value == ""
                                  ? 'dd/MM/yyyy'
                                  : widget.controler.dueDate.value,
                              style: const TextStyle(fontSize: 15),
                            ))),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDates = 2;
                          });
                        },
                        child: Container(
                            height: 45,
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.04),
                            decoration: BoxDecoration(
                              color: const Color(0xffeeeeee),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                                child: Text(
                              widget.controler.selectedTime == null
                                  ? 'h:mm A'
                                  : DateFormat('hh:mm a').format(
                                      widget.controler.selectedTime!.value),
                              style: const TextStyle(fontSize: 12),
                            ))),
                      ),
                    ],
                  ),
                  Center(
                    child: IconButton(
                      onPressed: () async {
                        // if (_startDate != null || _dueDate != null) {
                        //   String startDateString = DateFormat('MM/dd/yyyy')
                        //       .format(DateTime.parse(_startDate!));
                        //   String dueDateString = DateFormat('MM/dd/yyyy h:mm a')
                        //       .format(DateTime.parse(_dueDate!));
                        //
                        //   print('Start date: $startDateString');
                        //   print('Due date: $dueDateString');
                        //
                        //   _startDate != null;
                        //   _dueDate != null;
                        //   isChecked = true;
                        Navigator.pop(context);

                        // }
                      },
                      icon: const Text("Save",
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w700)),
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            );
          }),
        ));
      },
      child: Row(
        children: [
          Icon(Icons.watch_later_outlined,
              size: 15, color: Theme.of(context).primaryColorDark),
          const SizedBox(
            width: 5,
          ),
          Text(
            "Date",
            style: TextStyle(color: Theme.of(context).primaryColorDark),
          ),
        ],
      ),
    );
  }
}
