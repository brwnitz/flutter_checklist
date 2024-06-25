import 'package:checklist_master/database/checked_dao.dart';
import 'package:checklist_master/database/topic_dao.dart';
import 'package:checklist_master/dialogs/confirm_dialog.dart';
import 'package:checklist_master/models/checked.dart';
import 'package:checklist_master/views/edit_checked.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef RefreshCallback = Function();
typedef GetCheckedCallback = Future<List<Checked>> Function();
typedef GetCheckedByTopicCallback = Future<List<Checked>> Function(int topicId);
typedef GetCheckedByDate = Future<List<Checked>> Function(int weekday);

class CheckedBuilder extends StatefulWidget{
  final GetCheckedCallback getChecked;
  final RefreshCallback refreshChecked;
  final GetCheckedByDate? getCheckedByDate;
  final int? weekday;
  final TopicDao topicDao = TopicDao();
  final CheckedDao checkedDao = CheckedDao();
  CheckedBuilder({required this.getChecked, required this.refreshChecked, this.getCheckedByDate, this.weekday,super.key});

  

  @override
  CheckedBuilderState createState() => CheckedBuilderState();

  
}

class CheckedBuilderState extends State<CheckedBuilder>{
  double dx = 0.0;
  double dy = 0.0;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Checked>>(
          future: widget.getCheckedByDate != null ? widget.getCheckedByDate!(widget.weekday!) : widget.getChecked(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(padding: const EdgeInsets.all(20.0),
              child: 
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 20.0,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return FutureBuilder<int>(
                    future: getColor(snapshot.data![index].idTopic),
                    builder: (context, colorSnapshot) {
                      if(colorSnapshot.hasData){
                        return Listener(
                    onPointerDown: (details){
                      dx = details.position.dx;
                      dy = details.position.dy;
                    },
                    child:
                    Material(
                     borderRadius: BorderRadius.circular(10.0),
                     color: colorSnapshot.data != null ? Color(colorSnapshot.data!) : Colors.white,
                    child: InkWell(
                    borderRadius: BorderRadius.circular(10.0),
                    onLongPress: (){
                      showMenu(context: context, position: RelativeRect.fromLTRB(
                      0,
                      dy,
                      dx,
                      0
                      ),
                      items: [
                        PopupMenuItem(
                          child: ListTile(
                            title: const Text('Editar'),
                            leading: const Icon(Icons.edit),
                            onTap: () async{
                              await Navigator.push(context, MaterialPageRoute(builder: (context) => EditCheckedPage(checked: snapshot.data![index], topicId: snapshot.data![index].idTopic,)
                              )
                            );
                            setState(() {
                              widget.refreshChecked();
                            });
                            },
                          ),
                        ),
                        PopupMenuItem(
                          child: ListTile(
                            title: const Text('Excluir'),
                            leading: const Icon(Icons.delete),
                            onTap: () {
                              showDialog(context: context, builder: (BuildContext context){
                                return ConfirmDialog(title: 'Aviso!', message: 'Tem certeza que deseja excluir esse item?',titleTextStyle: const TextStyle(color: Colors.white), messageTextStyle: const TextStyle(color: Colors.white), onConfirm: () async {
                                  widget.checkedDao.deleteItem(snapshot.data![index].idChecked);
                                  Navigator.of(context).pop();
                                  setState(() {});
                                }, onCancel: (){
                                  Navigator.of(context).pop();
                                });
                              });
                            },
                          ),
                        ),
                      ],
                      );
                    },
                      child: ListTile(
                        title:
                            Text('${snapshot.data![index].nameChecked} - ${DateFormat('dd/MM/yyyy').format(DateTime.parse(snapshot.data![index].dateChecked))}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0)
                            ),
                          subtitle: Text(snapshot.data![index].descChecked,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0)),
                        trailing:  IconButton(
                          icon: Icon(
                            snapshot.data![index].isFavorite ? Icons.star : Icons.star_border,
                          ),
                          onPressed: (){
                            setState(() {
                              snapshot.data![index].isFavorite = snapshot.data![index].isFavorite ? false : true;
                              widget.checkedDao.updatedItem(snapshot.data![index]);
                              widget.refreshChecked();
                            });
                          },
                        ),
                        )
                      )
                    )
                  );
                      }
                      else {
                        return const Center(
                        );
                      }
                    }
                  )
                  ;
                },
              )
              );
            } else {
              return const Center(
              );
            }
          },
        );
  }
  Future<int> getColor(int idTopic) async {
    return await widget.topicDao.getColor(idTopic);
  }
}







