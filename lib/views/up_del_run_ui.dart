// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_run_record_app/models/run.dart';

class UpDelRunUI extends StatefulWidget {
  int? runId;
  String? runLocation;
  double? runDistance;
  int? runTime;

  UpDelRunUI({
    super.key,
    this.runId,
    this.runLocation,
    this.runDistance,
    this.runTime,
  });

  @override
  State<UpDelRunUI> createState() => _UpDelRunUIState();
}

class _UpDelRunUIState extends State<UpDelRunUI> {
  //สร้างตัวควบคุม TexField
  TextEditingController runLocationCtrl = TextEditingController();
  TextEditingController runDistanceCtrl = TextEditingController();
  TextEditingController runTimeCtrl = TextEditingController();

  //แสดงคำเตือน
  Future<void> _showWarningDialog(String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('คำเตือน'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(msg),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ตกลง'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _ShowResultDialog(String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ผลการทำงาน'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(msg),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ตกลง'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState(); // ย้าย super.initState() ขึ้นมาก่อน
    
    // เช็ค null ก่อนใช้ค่า
    runLocationCtrl.text = widget.runLocation ?? '';
    runDistanceCtrl.text = widget.runDistance?.toString() ?? '';
    runTimeCtrl.text = widget.runTime?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text(
          'แก้ไข/ลบการวิ่งของฉัน',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: 40.0,
          right: 40.0,
        ),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 20.0,
              ),
              Image.asset(
                'assets/images/running.png',
                width: 150.0,
              ),
              SizedBox(
                height: 20.0,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'สถานที่วิ่ง',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                controller: runLocationCtrl,
                decoration: InputDecoration(
                  hintText: 'กรุณากรอกสถานที่วิ่ง',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'ระยะทางที่วิ่ง (กิโลเมตร)',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                controller: runDistanceCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'กรุณากรอกระยะทางที่วิ่ง',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'เวลาที่ใช้ในการวิ่ง (นาที)',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                controller: runTimeCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'กรุณากรอกเวลาที่ใช้ในการวิ่ง',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              ElevatedButton(
                onPressed: () async {
                  // เช็คว่า runId ไม่เป็น null
                  if (widget.runId == null) {
                    await _showWarningDialog("ไม่พบข้อมูล ID ของการวิ่ง");
                    return;
                  }

                  if (runLocationCtrl.text.isEmpty) {
                    await _showWarningDialog("กรุณากรอกสถานที่วิ่ง");
                  } else if (runDistanceCtrl.text.isEmpty) {
                    await _showWarningDialog("กรุณากรอกระยะทางที่วิ่ง");
                  } else if (runTimeCtrl.text.isEmpty) {
                    await _showWarningDialog("กรุณากรอกเวลาในการวิ่ง");
                  } else {
                    try {
                      // ตรวจสอบการแปลงข้อมูลก่อนส่ง
                      double? distance = double.tryParse(runDistanceCtrl.text);
                      int? time = int.tryParse(runTimeCtrl.text);

                      if (distance == null) {
                        await _showWarningDialog("กรุณากรอกระยะทางเป็นตัวเลข");
                        return;
                      }
                      if (time == null) {
                        await _showWarningDialog("กรุณากรอกเวลาเป็นตัวเลข");
                        return;
                      }

                      // แพ็กข้อมูลที่ส่ง
                      Run run = Run(
                        runLocation: runLocationCtrl.text,
                        runDistance: distance,
                        runTime: time,
                      );

                      print('กำลังส่งข้อมูล: ${run.toJson()}'); // Debug
                      print('URL: http://127.0.0.1:5050/api/run/${widget.runId}'); // Debug

                      // ส่งข้อมูลโดยเอาข้อมูลที่ส่งมาทำ JSON
                      final result = await Dio().put(
                        'http://127.0.0.1:5050/api/run/${widget.runId}',
                        data: run.toJson(),
                        options: Options(
                          headers: {
                            'Content-Type': 'application/json',
                          },
                        ),
                      );

                      print('Response Status: ${result.statusCode}'); // Debug
                      print('Response Data: ${result.data}'); // Debug

                      // ตรวจสอบผลการทำงาน Result
                      if (result.statusCode == 200) {
                        await _ShowResultDialog('แก้ไขการวิ่งเรียบร้อยแล้ว')
                            .then((value) {
                          Navigator.pop(context);
                        });
                      } else {
                        await _showWarningDialog('ไม่สามารถแก้ไขการวิ่งได้ (Status: ${result.statusCode})');
                      }
                    } catch (e) {
                      print('Error: $e'); // Debug
                      await _showWarningDialog('เกิดข้อผิดพลาด: ${e.toString()}');
                    }
                  }
                },
                child: Text(
                  'แก้ไขการวิ่ง',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  fixedSize: Size(
                    MediaQuery.of(context).size.width,
                    60.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  // เช็คว่า runId ไม่เป็น null
                  if (widget.runId == null) {
                    await _showWarningDialog("ไม่พบข้อมูล ID ของการวิ่ง");
                    return;
                  }

                  try {
                    print('กำลังลบ URL: http://127.0.0.1:5050/api/run/${widget.runId}'); // Debug

                    final result = await Dio().delete(
                      'http://127.0.0.1:5050/api/run/${widget.runId}',
                    );

                    print('Delete Response Status: ${result.statusCode}'); // Debug

                    // ตรวจสอบผลการทำงาน Result
                    if (result.statusCode == 200) {
                      await _ShowResultDialog('ลบการวิ่งเรียบร้อยแล้ว')
                          .then((value) {
                        Navigator.pop(context);
                      });
                    } else {
                      await _showWarningDialog('ไม่สามารถลบการวิ่งได้ (Status: ${result.statusCode})');
                    }
                  } catch (e) {
                    print('Delete Error: $e'); // Debug
                    await _showWarningDialog('เกิดข้อผิดพลาดในการลบ: ${e.toString()}');
                  }
                },
                child: Text(
                  'ลบการวิ่ง',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  fixedSize: Size(
                    MediaQuery.of(context).size.width,
                    60.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}