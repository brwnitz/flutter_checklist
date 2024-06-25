import 'package:checklist_master/views/topic_list.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x99D18F00),
      appBar: AppBar(
        title: const Text('Main Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/checklist_image.png', width: 300, height: 300),
            const SizedBox(height: 20),
            const Text(
              'Versão 1.0.0',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TopicList()));
              },
              child: const Text('Visualizar tópicos'),
            ),
          ],
        ),
      ),
    );
  }
}