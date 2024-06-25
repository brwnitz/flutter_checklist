import 'package:checklist_master/database/checked_dao.dart';
import 'package:checklist_master/database/topic_dao.dart';
import 'package:checklist_master/models/topic.dart';
import 'package:checklist_master/views/components/gesture_builder.dart';
import 'package:flutter/material.dart';

typedef RefreshCallback = Function();
typedef GetTopicsCallback = Future<List<Topic>> Function();

class TopicBuilder extends StatefulWidget{
  final GetTopicsCallback getTopics;
  final RefreshCallback refreshTopics;
  final TopicDao topicDao = TopicDao();
  final CheckedDao checkedDao = CheckedDao();
  TopicBuilder({required this.getTopics, required this.refreshTopics, super.key});

  @override
  TopicBuilderState createState() => TopicBuilderState();
}

class TopicBuilderState extends State<TopicBuilder>{
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Topic>>(
      future: widget.getTopics(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(0,20,0,20),
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (context, index) {
                  return GestureBuilderComponent(topic: snapshot.data![index], refreshTopics: widget.refreshTopics);
                },
              );
            } else {
              return const Center(
              );
            }
      }
    );
  }
}