import 'package:checklist_master/database/topic_dao.dart';
import 'package:checklist_master/dialogs/loading_dialog.dart';
import 'package:checklist_master/models/topic.dart';
import 'package:checklist_master/utils/theme.dart';
import 'package:checklist_master/views/appbar.dart';
import 'package:checklist_master/views/topic_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_color_picker_plus/flutter_color_picker_plus.dart';

class EditTopicPage extends StatefulWidget {
  final Topic? topic;
  EditTopicPage({Key? key, this.topic});

  @override
  EditTopicPageState createState() => EditTopicPageState();
  
}

class EditTopicPageState extends State<EditTopicPage> {
  final nameController = TextEditingController();
  final descController = TextEditingController();
  Color currentColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    if (widget.topic != null){
      nameController.text = widget.topic!.titleTopic;
      descController.text = widget.topic!.descTopic;
      currentColor = Color(widget.topic!.colorTopic);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: myTheme(context),
      home: Scaffold(
      appBar: MyAppBar(title: 'Edição de tópico', onBackButtonPressed: () => {
          Navigator.of(context).pop()
        },),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Título do tópico',
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: 'Descrição do tópico',
              ),
            ),
            const SizedBox(height: 8.0),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
              child: const Text('Escolher cor'),
              onPressed: () {
                showDialog(context: context, builder: (BuildContext context){
                  return AlertDialog(
                    title: const Text('Escolha uma cor'),
                    content: SingleChildScrollView(
                      child: BlockPicker(
                        pickerColor: currentColor,
                        onColorChanged: (Color color) {
                          setState(() {
                            currentColor = color;
                          });
                        },
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                });
              },
            ),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: currentColor,
                borderRadius: BorderRadius.circular(25.0),
              )
            )
              ],
            )
            ),
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
                  if (widget.topic?.idTopic != null) {
                    await TopicDao().updateTopic(widget.topic!.idTopic, nameController.text, descController.text, currentColor.value);
                  }
                  else {
                    await TopicDao().addTopic(nameController.text, descController.text, currentColor.value);
                  }
                  Navigator.pop(dialogContext);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TopicList()));
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
    )
    );
  }
}
