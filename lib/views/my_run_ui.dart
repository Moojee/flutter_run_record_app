// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_run_record_app/models/run.dart';
import 'package:flutter_run_record_app/views/insert_run_ui.dart';
import 'package:flutter_run_record_app/views/up_del_run_ui.dart';

class MyRunUI extends StatefulWidget {
  const MyRunUI({super.key});

  @override
  State<MyRunUI> createState() => _MyRunUIState();
}

class _MyRunUIState extends State<MyRunUI> {
  late Future<List<Run>> myRuns;

  Future<List<Run>> fetcMyRun() async {
    try {
      final response = await Dio().get('http://localhost:5050/api/run');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data['result'] as List<dynamic>;
        return data.map((json) => Run.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load runs');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load runs: ${e.message}');
    }
  }

  @override
  void initState() {
    super.initState();
    myRuns = fetcMyRun();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text(
          'การวิ่งของฉัน',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 30.0,
            ),
            Image.asset(
              'assets/images/running.png',
              width: 200.0,
              height: 200.0,
            ),
            SizedBox(
              height: 30.0,
            ),
            FutureBuilder<List<Run>>(
              future: myRuns,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  List<Run> runs = snapshot.data!;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: runs.length,
                      itemBuilder: (context, index) {
                        Run run = runs[index];
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpDelRunUI(
                                  runId: run.runId,
                                  runLocation: run.runLocation,
                                  runDistance: run.runDistance,
                                  runTime: run.runTime,
                                ),
                              ),
                            );
                          },
                          leading: CircleAvatar(
                            backgroundColor: Colors.purple,
                            child: Text(
                              (index + 1).toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          title: Text(
                            'สถานที่วิ่ง: ' + run.runLocation!,
                          ),
                          subtitle: Text(
                            'ระยะทางวิ่ง: ' +
                                run.runDistance!.toString() +
                                ' km',
                          ),
                          trailing: Icon(Icons.arrow_forward_ios,
                              color: Colors.purple),
                          tileColor:
                              index % 2 == 0 ? Colors.white : Colors.grey[200],
                        );
                      },
                    ),
                  );
                } else {
                  return const Text('No runs found.');
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InsertRunUI(),
            ),
          ).then((value) {
            setState(() {
              myRuns = fetcMyRun();
            });
          });
        },
        label: Text(
          'เพิ่มการวิ่ง',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
        icon: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.amberAccent[700],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
