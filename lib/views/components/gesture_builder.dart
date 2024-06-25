import 'package:checklist_master/database/checked_dao.dart';
import 'package:checklist_master/database/topic_dao.dart';
import 'package:checklist_master/dialogs/confirm_dialog.dart';
import 'package:checklist_master/models/checked.dart';
import 'package:checklist_master/models/topic.dart';
import 'package:checklist_master/views/edit_checked.dart';
import 'package:checklist_master/views/edit_topic.dart';
import 'package:flutter/material.dart';

typedef RefreshCallback = Function();

class GestureBuilderComponent extends StatefulWidget {
  final Topic topic;
  final RefreshCallback refreshTopics;
  GestureBuilderComponent({super.key, required this.topic, required this.refreshTopics});
  final TopicDao topicDao = TopicDao();
  final CheckedDao checkedDao = CheckedDao();
  

  @override
  GestureBuilderComponentState createState() => GestureBuilderComponentState();
}

class GestureBuilderComponentState extends State<GestureBuilderComponent> {
  double dx = 0.0;
  double dxDrag = 0.0;
  bool isDragging = false;
  double dy = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
  onTapDown: (details) {
    dx = details.globalPosition.dx;
    dy = details.globalPosition.dy;
  },
  onPanStart: (details) {
    setState(() {
      isDragging = true;
      dxDrag = 0.0;
    });
  },
  onPanUpdate: (details) {
    setState(() {
      dxDrag += details.delta.dx;
      if(dxDrag > (MediaQuery.of(context).size.width / 2 - 40)){
        dxDrag = MediaQuery.of(context).size.width / 2 - 40;
    }
    else if (dxDrag < (-MediaQuery.of(context).size.width / 2 + 40)){
      dxDrag = -MediaQuery.of(context).size.width / 2 + 40;
    }});
  },
  onPanEnd: (details) {
    print(dxDrag);
    print(MediaQuery.of(context).size.width / 2 - 90);
    if (dxDrag > MediaQuery.of(context).size.width / 2 - 90) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => EditCheckedPage(checked: Checked(idChecked: null, nameChecked: '', descChecked: '', isChecked: false, dateChecked: '', idTopic: widget.topic.idTopic, isFavorite: false), topicId: widget.topic.idTopic)));
    } else if (dxDrag < (-(MediaQuery.of(context).size.width / 2 - 90))) {
                          showDialog(
                            context: context,
                            builder: (context) => ConfirmDialog(
                              title: 'Excluir Tópico',
                              message: 'Deseja realmente excluir o tópico ${widget.topic.titleTopic}?',
                              titleTextStyle: const TextStyle(color: Colors.white),
                              messageTextStyle: const TextStyle(color: Colors.white),
                              onConfirm: () async {
                                await widget.topicDao.deleteTopic(widget.topic.idTopic);
                                await widget.checkedDao.deleteFromTopic(widget.topic.idTopic);
                                Navigator.of(context).pop();
                                widget.refreshTopics();
                              },
                              onCancel: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          );
    }
    setState(() {
      isDragging = false;
      dxDrag = 0.0;
    });
  },
  child: isDragging
      ?
      Row(
        children:[
          Opacity(
            opacity: calculateOpacity(MediaQuery.of(context).size.width/2 - 40, dxDrag.abs()),
            child: 
      SizedBox(
          width: dxDrag > 0 ? dxDrag : 0,
          height: 72,
          child: Container(
            color: const Color(0xFF2F40AF),
            child: const Center(
              child: Icon(Icons.add, color: Colors.white,),
            ),
          ),
        )
        ),
        Container(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        width: MediaQuery.of(context).size.width - dxDrag.abs(),
        height: 72,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 7, 11, 38),
          ),
          child: ListTile(
            title: Text(widget.topic.titleTopic, style: const TextStyle(color: Colors.white),),
            subtitle: Text(widget.topic.descTopic, style: const TextStyle(color: Colors.white),),
          ),
        ),
        Opacity(
            opacity: calculateOpacity(MediaQuery.of(context).size.width/2 - 40, dxDrag.abs()),
            child: 
        SizedBox(
          width: dxDrag < 0 ? dxDrag.abs() : 0,
          height: 72,
          child: Container(
            color: const Color(0xFF2F40AF),
            child: const Center(
              child: Icon(Icons.delete, color: Colors.white,),
            ),
          ),
        )
        )
        ]
        )
      :
      Container(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        height: 72,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 7, 11, 38),
          ),
          child: ListTile(
            title: Text(widget.topic.titleTopic, style: const TextStyle(color: Colors.white),),
            subtitle: Text(widget.topic.descTopic, style: const TextStyle(color: Colors.white),),
            trailing: TextButton(
              onPressed: (){
                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(dx, dy, 0, 0),
                  items: [
                    PopupMenuItem(
                      child: ListTile(
                        title: const Text('Editar'),
                        leading: const Icon(Icons.edit),
                        onTap: () async{
                          await Navigator.push(context, MaterialPageRoute(builder: (context) => EditTopicPage(topic: widget.topic,)
                          )
                        );
                        widget.refreshTopics();
                        },
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        title: const Text('Excluir'),
                        leading: const Icon(Icons.delete),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => ConfirmDialog(
                              title: 'Excluir Tópico',
                              message: 'Deseja realmente excluir o tópico ${widget.topic.titleTopic}?',
                              titleTextStyle: const TextStyle(color: Colors.white),
                              messageTextStyle: const TextStyle(color: Colors.white),
                              onConfirm: () async {
                                await widget.topicDao.deleteTopic(widget.topic.idTopic);
                                await widget.checkedDao.deleteFromTopic(widget.topic.idTopic);
                              },
                              onCancel: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
              child: const Icon(Icons.more_vert, color: Colors.white,),
            ),
          ),
        ),
      );
    }
  double calculateOpacity(double maxVal, double currentVal){
    if(currentVal == 0) return 0;
    return (currentVal / maxVal);
  }
}