// To parse this JSON data, do
//
//     final doorResponse = doorResponseFromJson(jsonString);

import 'dart:convert';

DoorResponse doorResponseFromJson(String str) =>
    DoorResponse.fromJson(json.decode(str));

String doorResponseToJson(DoorResponse data) => json.encode(data.toJson());

class DoorResponse {
  DoorResponse({
    this.companyList,
    this.company,
    this.companyModuleList,
    this.connectionStringList,
    required this.doorInformationsList,
    required this.doorInformations,
    this.doorLogDetailList,
    this.doorProcessList,
    this.doorProcess,
    this.logDetailList,
    this.receptionList,
    this.receptionProcessList,
    this.roomProcessList,
    required this.errorCode,
    required this.errorMessage,
  });

  dynamic companyList;
  dynamic company;
  dynamic companyModuleList;
  dynamic connectionStringList;
  List<DoorInformations> doorInformationsList;
  DoorInformations doorInformations;
  dynamic doorLogDetailList;
  dynamic doorProcessList;
  dynamic doorProcess;
  dynamic logDetailList;
  dynamic receptionList;
  dynamic receptionProcessList;
  dynamic roomProcessList;
  String errorCode;
  String errorMessage;

  factory DoorResponse.fromJson(Map<String, dynamic> json) => DoorResponse(
        companyList: json["CompanyList"],
        company: json["Company"],
        companyModuleList: json["CompanyModuleList"],
        connectionStringList: json["ConnectionStringList"],
        doorInformationsList: List<DoorInformations>.from(
            json["DoorInformationsList"]
                .map((x) => DoorInformations.fromJson(x))),
        doorInformations: DoorInformations.fromJson(json["DoorInformations"]),
        doorLogDetailList: json["DoorLogDetailList"],
        doorProcessList: json["DoorProcessList"],
        doorProcess: json["DoorProcess"],
        logDetailList: json["LogDetailList"],
        receptionList: json["ReceptionList"],
        receptionProcessList: json["ReceptionProcessList"],
        roomProcessList: json["RoomProcessList"],
        errorCode: json["ErrorCode"],
        errorMessage: json["ErrorMessage"],
      );

  Map<String, dynamic> toJson() => {
        "CompanyList": companyList,
        "Company": company,
        "CompanyModuleList": companyModuleList,
        "ConnectionStringList": connectionStringList,
        "DoorInformationsList":
            List<dynamic>.from(doorInformationsList.map((x) => x.toJson())),
        "DoorInformations": doorInformations.toJson(),
        "DoorLogDetailList": doorLogDetailList,
        "DoorProcessList": doorProcessList,
        "DoorProcess": doorProcess,
        "LogDetailList": logDetailList,
        "ReceptionList": receptionList,
        "ReceptionProcessList": receptionProcessList,
        "RoomProcessList": roomProcessList,
        "ErrorCode": errorCode,
        "ErrorMessage": errorMessage,
      };
}

class DoorInformations {
  DoorInformations({
    required this.id,
    required this.doorName,
    required this.doorSerial,
    required this.description,
    required this.companyId,
  });

  int id;
  String doorName;
  String doorSerial;
  String description;
  int companyId;

  factory DoorInformations.fromJson(Map<String, dynamic> json) =>
      DoorInformations(
        id: json["ID"],
        doorName: json["DoorName"],
        doorSerial: json["DoorSerial"],
        description: json["Description"],
        companyId: json["CompanyID"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "DoorName": doorName,
        "DoorSerial": doorSerial,
        "Description": description,
        "CompanyID": companyId,
      };
}
