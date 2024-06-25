import 'dart:async';

import 'package:checklist_master/database/checked_dao.dart';
import 'package:checklist_master/database/topic_dao.dart';
import 'package:checklist_master/models/checked.dart';
import 'package:checklist_master/models/topic.dart';
import 'package:checklist_master/utils/theme.dart';
import 'package:checklist_master/views/components/drawer.dart';
import 'package:checklist_master/views/edit_topic.dart';
import 'package:checklist_master/views/fragments/checked_builder.dart';
import 'package:checklist_master/views/fragments/topic_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:google_fonts/google_fonts.dart';

class TopicList extends StatefulWidget {
    const TopicList({super.key});
    
  @override
  State<StatefulWidget> createState() =>_TopicListState();
  
}

class _TopicListState extends State<TopicList>{
  int _selectedValue = 3;
  int _dayOfWeek = DateTime.now().weekday;
  Future<List<Topic>>? topicsFuture;
  Future<List<Checked>>? checkedsFuture;
  int? checkedPercentage;
  final TopicDao topicDao = TopicDao();
  final CheckedDao checkedDao = CheckedDao();
  double dx = 0.0;
  double dy = 0.0;
  int dayOfTheWeek = 0;
  DateTime now = DateTime.now().toUtc().add(const Duration(hours: -3));

  @override
  void initState() {
    super.initState();
    getDate();
    refreshTopics();
    refreshDateChecked();
    refreshDate();
    refreshPercentage();
  }

  String printDayOfWeek() {
  now = DateTime.now().toUtc().add(const Duration(hours: -3));
  List<String> daysOfWeek = ['Segunda-feira', 'Terça-feira', 'Quarta-feira', 'Quinta-feira', 'Sexta-feira', 'Sábado', 'Domingo'];
  return daysOfWeek[now.weekday - 1];
}

void getDate(){
  now = DateTime.now().toUtc().add(const Duration(hours: -3));
  dayOfTheWeek = now.weekday;
}

  void refreshTopics() {
    setState(() {
      topicsFuture = getTopics();
    });
  }

  void refreshDate() {
    setState(() {
      now = DateTime.now();
    });
  }

  void refreshPercentage() async {
    int newCheckedPercentage = await getPercentage();
    setState(() {
      checkedPercentage = newCheckedPercentage;
    });
  }

  void refreshChecked() {
    setState(() {
      checkedsFuture = getChecked();
    });
  }

  void refreshDateChecked() {
    setState(() {
      checkedsFuture = getCheckedByDate(dayOfTheWeek);
    });
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: myTheme(context),
      home: Scaffold(
        drawer: MyDrawer(),
        body: Builder(
          builder: (context) => Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 40.0, left: 10.0),
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              color: Colors.white,
              iconSize: 25.0,
            )
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(top: 20.0, left: 20.0),
            child: Text(
            now.hour <= 12 ? 'Bom\nDia' : now.hour <= 18 ? 'Boa\nTarde' : 'Boa\nNoite',
            style: GoogleFonts.varelaRound(textStyle: const TextStyle(
              fontSize: 50.0,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(238, 57, 87, 253),
              height: 1.0,
            )),
          )
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 10.0),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${printDayOfWeek()},',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        )
                      ),
                    ),
                    Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${now.day}/${now.month}/${now.year}',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.white54,
                      ),
                    )
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '$checkedPercentage% Concluído',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    )
                    ),
                    const Align(
                    alignment: Alignment.centerRight,
                    child: Text('Itens concluídos',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.white54,
                      )
                      )
                      ),
                  ],
                )
              ],
            )),
          ),
          Container(
            margin: const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
            child: Column(
            children: [
            Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: _selectedValue == 3 ? Colors.white70 : _selectedValue == 1 ? Colors.white70 : Colors.white24,
                        width: 2.0
                      )
                    )
                  ),
                  child: TextButton(
                    style: ButtonStyle(
                      overlayColor: WidgetStateProperty.resolveWith<Color>((states) {
                        if (states.contains(WidgetState.hovered)) {
                          return Colors.transparent;
                        }
                        if (states.contains(WidgetState.pressed)) {
                          return Colors.transparent;
                        }
                        return Colors.transparent;
                      })
                    ),
                  onPressed: () {
                    setState(() {
                      _selectedValue = 3;
                    });
                  },
                  child: FutureBuilder<int>(
                    future: getCheckedCount(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(padding: const EdgeInsets.fromLTRB(15 ,0, 15, 0),
                            child: DecoratedBox(
                              decoration: _selectedValue == 3 || _selectedValue == 1 ? BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25.0)
                              ) : BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: Colors.white70, width: 1.0),
                                borderRadius: BorderRadius.circular(25.0)
                              ),
                              child:
                              Padding(
                                padding: const EdgeInsets.fromLTRB(7, 2, 7, 2),
                                child: Text(snapshot.data.toString(), style: TextStyle(color: _selectedValue == 1 || _selectedValue == 3 ? const Color(0x99212A5A) : Colors.white70, fontWeight: FontWeight.bold, fontSize: 14.0),),))),
                            AnimatedDefaultTextStyle(style: _selectedValue == 1 || _selectedValue == 3 ? 
                            const TextStyle(color: Color.fromARGB(238, 57, 87, 253), fontWeight: FontWeight.w300, fontSize: 24.0) : 
                            const TextStyle(color: Colors.white70, fontWeight: FontWeight.w300, fontSize: 24.0),
                            duration: const Duration(milliseconds: 400),
                            child: const Text('Itens'),)
                          ],
                        );
                      }
                      else {
                        return const Text('Erro ao carregar itens');
                      }
                    },
                  ),
                ),
              )
              ),
              Expanded(
              flex: 1,
              child: AnimatedContainer(
                duration: const Duration(milliseconds:400),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: _selectedValue == 2 ? Colors.white70 : Colors.white24,
                      width: 2.0
                    )
                  )
                ),
                child: TextButton(
                  style: ButtonStyle(
                      overlayColor: WidgetStateProperty.resolveWith<Color>((states) {
                        if (states.contains(WidgetState.hovered)) {
                          return Colors.transparent;
                        }
                        if (states.contains(WidgetState.pressed)) {
                          return Colors.transparent;
                        }
                        return Colors.transparent;
                      }),
                      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                        if (states.contains(WidgetState.hovered)) {
                          return Colors.transparent;
                        }
                        if (states.contains(WidgetState.pressed)) {
                          return Colors.transparent;
                        }
                        return Colors.transparent;
                      })
                    ),
                  onPressed: () {
                    setState(() {
                      _selectedValue = 2;
                    });
                  },
                  child: FutureBuilder<int>(
                    future: getTopicCount(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(padding: const EdgeInsets.fromLTRB(15 ,0, 15, 0),
                            child: DecoratedBox(
                              decoration: _selectedValue == 2 ? BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25.0)
                              ) : BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: Colors.white70, width: 1.0),
                                borderRadius: BorderRadius.circular(25.0)
                              ),
                              child:
                              Padding(
                                padding: const EdgeInsets.fromLTRB(7, 2, 7, 2),
                                child: Text(snapshot.data.toString(), style: TextStyle(color: _selectedValue == 2 ? const Color(0x99212A5A) : Colors.white70, fontWeight: FontWeight.bold, fontSize: 14.0),),))),
                            AnimatedDefaultTextStyle(style: _selectedValue == 2 ? 
                            const TextStyle(color: Color.fromARGB(238, 57, 87, 253), fontWeight: FontWeight.w300, fontSize: 24.0) : 
                            const TextStyle(color: Colors.white70, fontWeight: FontWeight.w300, fontSize: 24.0),
                            duration: const Duration(milliseconds: 400),
                            child: const Text('Tópicos'),)
                          ],
                        );
                      }
                      else {
                        return const Text('Erro ao carregar tópicos');
                      }
                    },
                  ),
                ),
                )
              )
            ],
          ),
          SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                  onPressed: (){setState(() {
                    _dayOfWeek = 0;
                    _selectedValue = 1;
                    checkedsFuture = getChecked();
                    refreshChecked();
                  });},
                  child: Text('Todos', style: TextStyle(color: _dayOfWeek == 0 ? const Color(0xFF2F40AF) : Colors.white70, fontSize: 14.0),),
              ),
                TextButton(
                  onPressed: (){setState(() {
                    _dayOfWeek = 1;
                    dayOfTheWeek = 1;
                    checkedsFuture = getCheckedByDate(_dayOfWeek);
                    _selectedValue = 3;
                    refreshDateChecked();
                  });},
                  child: Text('Seg', style: TextStyle(color: _dayOfWeek == 1 ? const Color(0xFF2F40AF) : Colors.white70, fontSize: 14.0),),
              ),
              TextButton(
                  onPressed: (){setState(() {
                    _dayOfWeek = 2;
                    dayOfTheWeek = 2;
                    checkedsFuture = getCheckedByDate(_dayOfWeek);
                    _selectedValue = 3;
                    refreshDateChecked();
                  });},
                  child: Text('Ter', style: TextStyle(color: _dayOfWeek == 2 ? const Color(0xFF2F40AF) : Colors.white70, fontSize: 14.0),),
              ),
              TextButton(
                  onPressed: (){setState(() {
                    _dayOfWeek = 3;
                    dayOfTheWeek = 3;
                    checkedsFuture = getCheckedByDate(_dayOfWeek);
                    _selectedValue = 3;
                    refreshDateChecked();
                  });},
                  child: Text('Qua', style: TextStyle(color: _dayOfWeek == 3 ? const Color(0xFF2F40AF) : Colors.white70, fontSize: 14.0),),
              ),
              TextButton(
                  onPressed: (){setState(() {
                    _dayOfWeek = 4;
                    dayOfTheWeek = 4;
                    checkedsFuture = getCheckedByDate(_dayOfWeek);
                    _selectedValue = 3;
                    refreshDateChecked();
                  });},
                  child: Text('Qui', style: TextStyle(color: _dayOfWeek == 4 ? const Color(0xFF2F40AF) : Colors.white70, fontSize: 14.0),),
              ),
              TextButton(
                  onPressed: (){setState(() {
                    _dayOfWeek = 5;
                    dayOfTheWeek = 5;
                    checkedsFuture = getCheckedByDate(_dayOfWeek);
                    _selectedValue = 3;
                    refreshDateChecked();
                  });},
                  child: Text('Sex', style: TextStyle(color: _dayOfWeek == 5 ? const Color(0xFF2F40AF) : Colors.white70, fontSize: 14.0),),
              ),
              TextButton(
                  onPressed: (){setState(() {
                    _dayOfWeek = 6;
                    dayOfTheWeek = 6;
                    checkedsFuture = getCheckedByDate(_dayOfWeek);
                    _selectedValue = 3;
                    refreshDateChecked();
                  });},
                  child: Text('Sáb', style: TextStyle(color: _dayOfWeek == 6 ? const Color(0xFF2F40AF) : Colors.white70, fontSize: 14.0),),
              ),
              TextButton(
                  onPressed: (){setState(() {
                    _dayOfWeek = 7;
                    dayOfTheWeek = 7;
                    checkedsFuture = getCheckedByDate(_dayOfWeek);
                    _selectedValue = 3;
                    refreshDateChecked();
                  });},
                  child: Text('Dom', style: TextStyle(color: _dayOfWeek == 7 ? const Color(0xFF2F40AF) : Colors.white70, fontSize: 14.0),),
              ),
            ],
          )
          )
            ]
            )
          ),
          Expanded(
            flex: 1,
            child:
            SwipeDetector(
            onSwipeRight: (){
              setState(() {
                _selectedValue = 3;
              });
            },
            onSwipeLeft: (){
              setState(() {
                _selectedValue = 2;
              });
            },
            child: FractionallySizedBox(
            heightFactor: 1.0,
            alignment: Alignment.topLeft,
            child: _selectedValue == 1 
            ? CheckedBuilder(getChecked: getChecked, refreshChecked: refreshChecked)
            : _selectedValue == 3 ? CheckedBuilder(getChecked: getChecked, refreshChecked: refreshDateChecked, getCheckedByDate: getCheckedByDate, weekday: dayOfTheWeek,)
            : TopicBuilder(getTopics: getTopics, refreshTopics: refreshTopics)
        )
        )
        )
        ]
        )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => EditTopicPage()));
          },
          child: const Icon(Icons.add),
        )
      ),
    );
  }
  
  

  Future<List<Topic>> getTopics() async {
    return await topicDao.getAll();
  }

  Future<int> getPercentage() async {
    return await checkedDao.checkPercentage();
  }

  Future<List<Checked>> getChecked() async {
    return checkedDao.getAll();
  }

  Future<List<Checked>> getCheckedByDate(int weekday) async {
    List<Checked> checkeds = await checkedDao.getAll();
    List<Checked> dayCheckeds = [];
    for (var checked in checkeds) {
      DateTime checkedDate = DateTime.parse(checked.dateChecked);
      if(checkedDate.weekday == weekday) {
        dayCheckeds.add(checked);
      }
    }
    dayCheckeds.sort((a,b) => DateTime.parse(b.dateChecked).compareTo(DateTime.parse(a.dateChecked)));
    return dayCheckeds;
  }

  Future<int> getCheckedCount() async {
    return checkedDao.getCount();
  }

  Future<int> getTopicCount() async {
    return topicDao.getCount();
  }
  
}