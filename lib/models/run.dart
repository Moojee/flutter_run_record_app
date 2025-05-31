//หน้าที่คือ
//1. เอาไว้แพ็คข้อมูล
//2. เอาไว้แปลงข้อมูล JSON เพื่อส่งไปยัง API
//3. เอาไว้แปลงข้อมูล JSON ที่ได้จาก API เป็นข้อมูลที่ใช้งานได้ในแอป

class Run {
  int? runId;
  String? runLocation;
  double? runDistance;
  int? runTime;

  Run({this.runId, this.runLocation, this.runDistance, this.runTime});

  Run.fromJson(Map<String, dynamic> json) {
    runId = json['runId'];
    runLocation = json['runLocation'];
    runDistance = json['runDistance'];
    runTime = json['runTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['runId'] = this.runId;
    data['runLocation'] = this.runLocation;
    data['runDistance'] = this.runDistance;
    data['runTime'] = this.runTime;
    return data;
  }
}