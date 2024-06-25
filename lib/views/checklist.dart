import 'package:checklist_master/database/checked_dao.dart';
import 'package:checklist_master/models/checked.dart';
import 'package:checklist_master/models/topic.dart';
import 'package:checklist_master/utils/theme.dart';
import 'package:checklist_master/views/appbar.dart';
import 'package:checklist_master/views/edit_checked.dart';
import 'package:checklist_master/views/fragments/checked_builder.dart';
import 'package:flutter/material.dart';

class Checklist extends StatefulWidget {
  final Topic topic;
  const Checklist({super.key, required this.topic});

  @override
  ChecklistWidget createState() => ChecklistWidget();
}

class ChecklistWidget extends State<Checklist> {
  Future<List<Checked>>? checkedsFuture;
  late Topic _topic;
  CheckedDao checkedDao = CheckedDao();
  double dx = 0.0;
  double dy = 0.0;

  @override
  void initState() {
    super.initState();
    _topic = widget.topic;
  }

  void refreshChecked() {
    checkedsFuture = getChecked();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: myTheme(context),
      home: Scaffold(
        appBar: MyAppBar(title: 'Checklist - ${_topic.titleTopic}', onBackButtonPressed: () => {
          Navigator.of(context).pop()
        },),
        body: CheckedBuilder(getChecked: getChecked, refreshChecked: refreshChecked),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => EditCheckedPage(checked: Checked(idChecked: null, nameChecked: '', descChecked: '', isChecked: false, dateChecked: '', idTopic: _topic.idTopic, isFavorite: false), topicId: _topic.idTopic)));
          },
          child: const Icon(Icons.add),
        )
      ),
    );
  }

  Future<List<Checked>> getChecked() async {
    return checkedDao.getCheckedByTopic(_topic.idTopic);
  }
}