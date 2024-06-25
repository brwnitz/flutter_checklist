import 'package:checklist_master/database/checked_dao.dart';
import 'package:checklist_master/database/topic_dao.dart';
import 'package:checklist_master/dialogs/loading_dialog.dart';
import 'package:checklist_master/models/checked.dart';
import 'package:checklist_master/models/topic.dart';
import 'package:checklist_master/utils/theme.dart';
import 'package:checklist_master/views/appbar.dart';
import 'package:checklist_master/views/checklist.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditCheckedPage extends StatefulWidget {
  final Checked checked;
  final int topicId;
  EditCheckedPage({super.key, required this.checked, required this.topicId});
  

  @override
  EditCheckedPageState createState() => EditCheckedPageState();
}

class EditCheckedPageState extends State<EditCheckedPage> {
  TopicDao topicDao = TopicDao();
  CheckedDao checkedDao = CheckedDao();
  final nameController = TextEditingController();
  final descController = TextEditingController();
  int limit = 1;

  @override
  void initState() {
    super.initState();
    dateLimit();
  }
  void dateLimit () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      limit = prefs.getInt('weeks') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {

    
    DateTime initialDate = DateTime.now();
    if(widget.checked.idChecked != null){
      nameController.text = widget.checked.nameChecked;
      descController.text = widget.checked.descChecked;
      initialDate = DateTime.parse(widget.checked.dateChecked);
    }
    return MaterialApp(
    theme: myTheme(context),
    home: Scaffold(
      appBar: MyAppBar(title: 'Edição de item', onBackButtonPressed: () => {
          Navigator.of(context).pop()
        },),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Título do item',
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: 'Descrição do item',
              ),
            ),
            const SizedBox(height: 8.0),
            ElevatedButton(
            onPressed: () async{
              DateTime now = DateTime.now();
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: now,
                firstDate: now,
                lastDate: now.add(Duration(days: limit * 7)),
                );
                if (pickedDate != null) {
                  initialDate = pickedDate;
                }
            }, 
            child: const Text('Selecionar data')),     
            const SizedBox(height: 16.0),
            ElevatedButton(
              child: const Text('Salvar'),
              onPressed: () async {
                if (nameController.text.isNotEmpty && descController.text.isNotEmpty) {
                  var dialogContext;
                  showDialog(context: context, barrierDismissible: false, builder: (BuildContext context){
                    dialogContext = context;
                    return const LoadingDialog();
                  });
                  if (widget.checked.idChecked != null) {
                    await checkedDao.updatedItem(widget.checked);
                  }
                  else {
                    await checkedDao.addItem(Checked(idChecked: await checkedDao.getCount() + 1, nameChecked: nameController.text, descChecked: descController.text, isChecked: false, dateChecked: initialDate.toString(), idTopic: widget.topicId, isFavorite: false));
                  }
                  Navigator.pop(dialogContext);
                  Navigator.pushReplacement(context,
                   MaterialPageRoute(
                    builder: (context) => FutureBuilder<Topic>(
                      future: getTopic(widget.topicId),
                      builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return const LoadingDialog();
                        }
                        else if(snapshot.hasData){
                          return Checklist(topic: snapshot.data!);
                        }
                        else {
                          return const Center(
                            child: Text('Erro ao carregar tópico'),
                          );
                        }
                      },
                  )));
                }
                else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Erro'),
                        content: const Text('Preencha todos os campos'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    ));
  }
    Future<Topic> getTopic(int topicId) async {
      return await topicDao.getTopic(topicId);
    }

}