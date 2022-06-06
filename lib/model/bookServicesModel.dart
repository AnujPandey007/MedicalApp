const BOOKING_SERVICES_MODEL_COLLECTION = "booking";

// class SlotModel {
//   late bool isBooked;
//
//   SlotModel({this.isBooked = false});
//
//   Map<String, dynamic> toJson() {
//     return {
//       "isBooked": isBooked,
//     };
//   }
//
//   SlotModel.fromJson(Map<String, dynamic> json) {
//     isBooked = json["isBooked"];
//   }
// }

class BookServicesModel {
  late String? bookId;
  late String doctorName;
  late String doctorId;
  late String patientId;
  late String patientName;
  late int timeStamp;
  // late List<SlotModel> bookingSlot;

  BookServicesModel(
      {required this.doctorName,
      required this.doctorId,
      required this.patientId,
      required this.patientName,
      required this.timeStamp,
      // required this.bookingSlot,
      this.bookId});

  Map<String, dynamic> toJson() {
    return {
      "doctorName": doctorName,
      "doctorId": doctorId,
      "patientId": patientId,
      "patientName": patientName,
      "timeStamp": timeStamp,
      // "bookingSlot": bookingSlot.map((e) => e.toJson()).toList(),
    };
  }

  BookServicesModel.fromJson(Map<String, dynamic> json) {
    doctorName = json["doctorName"];
    doctorId = json["doctorId"];
    patientId = json["patientId"];
    patientName = json["patientName"];
    timeStamp = json["timeStamp"];
    // if (json["bookingSlot"].runtimeType == [].runtimeType) {
    //   bookingSlot =
    //       json["bookingSlot"].map((e) => SlotModel.fromJson(e)).toList();
    // }
    bookId = json["uid"];
  }
}
