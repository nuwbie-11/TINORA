// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:tinora/Components/custom_textfield.dart';
import 'package:tinora/model/tasks_model.dart';
import 'package:tinora/provider/tasks_provider.dart';

// ignore: must_be_immutable
class TasksActions extends StatefulWidget {
  TasksModel? task;
  TasksActions({Key? key, this.task}) : super(key: key);

  @override
  State<TasksActions> createState() => _TasksActionsState();
}

class _TasksActionsState extends State<TasksActions> {
  final TextEditingController desc = TextEditingController();
  DateTime? _deadlineDate;
  bool isChecked = false;
  String status = "";

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      setState(() {
        desc.text = widget.task!.description;
        isChecked = widget.task!.isImportant == 0 ? false : true;
        _deadlineDate =
            DateTime.fromMillisecondsSinceEpoch(widget.task!.deadline);
      });
    }
  }

  @override
  void dispose() {
    desc.dispose();
    super.dispose();
  }

  Future<bool> _AddViaFirebase() async {
    final TasksModel model = TasksModel(
      createdAt: DateTime.now().millisecondsSinceEpoch,
      deadline: _deadlineDate!.millisecondsSinceEpoch,
      description: desc.value.text,
      id: widget.task?.id,
      isImportant: isChecked,
    );
    var response =
        await FirebaseFirestore.instance.collection('tasks').add(model.toMap());
    print(response);
    return true;
  }

  Future<bool> _checkData() async {
    if ((desc.value.text != "") && (_deadlineDate != null)) {
      return true;
    }
    return false;
  }

  createTask() async {
    final TasksModel model = TasksModel(
      createdAt: DateTime.now().millisecondsSinceEpoch,
      deadline: _deadlineDate!.millisecondsSinceEpoch,
      description: desc.value.text,
      id: widget.task?.id,
      isImportant: isChecked,
    );
    if (widget.task == null) {
      await TasksProvider.addTasks(model);
    }
  }

  _deleteTask(TasksModel task) {
    TasksProvider.deleteTasks(task);
  }

  _updateTask() {
    final TasksModel model = TasksModel(
      createdAt: DateTime.now().millisecondsSinceEpoch,
      deadline: _deadlineDate!.millisecondsSinceEpoch,
      description: desc.value.text,
      id: widget.task?.id,
      isImportant: isChecked,
    );
    TasksProvider.updateTasks(model);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTextField(
          hint: widget.task != null ? widget.task!.description : 'hint',
          controller: desc,
          onChanged: (value) {},
          usedIcon: Icons.description,
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text("Important"),
            Checkbox(
                value: isChecked,
                onChanged: (value) {
                  setState(() {
                    isChecked = value!;
                  });
                }),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(_deadlineDate == null
                ? 'Pick a deadline date'
                : DateFormat('dd-MM-yyy').format(_deadlineDate!).toString()),
            IconButton(
              color: Colors.deepPurple,
              onPressed: () {
                showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2099))
                    .then((value) => setState(() {
                          _deadlineDate = value;
                        }));
              },
              icon: const Icon(Icons.date_range_rounded),
            )
                .animate()
                .shimmer(duration: 1800.ms, delay: 400.ms)
                .shake(hz: 4, curve: Curves.easeInOut),
          ],
        ),
        Text(
          status,
          style: TextStyle(color: Colors.red, fontSize: 8),
        ),
        Container(
          alignment: Alignment.bottomRight,
          child: widget.task != null
              ? Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          _deleteTask(widget.task!);
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Delete",
                          style: TextStyle(color: Colors.red),
                        )),
                    TextButton(
                        onPressed: () {
                          _updateTask();
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Update",
                          style: TextStyle(color: Colors.amber),
                        )),
                  ],
                )
              : TextButton(
                  onPressed: () {
                    _checkData().then((value) {
                      if (value) {
                        // createTask();
                        _AddViaFirebase();
                        Navigator.pop(context);
                      }
                      setState(() {
                        status = "is Empty";
                      });
                    });
                  },
                  child: Text("Add")),
        )
      ],
    );
  }
}
