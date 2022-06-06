import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_client/model/bookServicesModel.dart';
import 'package:doctor_client/model/chatModel.dart';
import 'package:doctor_client/model/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataUtils {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authInstance => _auth.authStateChanges();

  static User? getCurrentUser() => _auth.currentUser;

  static Stream<UserModel> getCurrentUserModel() {
    return FirebaseFirestore.instance
        .collection(USER_MODEL_COLLECTION)
        .doc(getCurrentUser()?.uid)
        .snapshots()
        .map((doc) => UserModel.fromJson(doc.data()!));
  }

  static logoutUser() => _auth.signOut();

  static Stream<List<UserModel>> getListOfDoctorsByCity(City city) {
    Query<Map<String, dynamic>> queryRef = FirebaseFirestore.instance
        .collection(USER_MODEL_COLLECTION)
        .where("userType", isEqualTo: UserType.DOCTOR.name)
        .where("uid", isNotEqualTo: getCurrentUser()!.uid)
        .where("city", isEqualTo: city.name);
    return queryRef.snapshots().map(
        (doc) => doc.docs.map((e) => UserModel.fromJson(e.data())).toList());
  }

  static Stream<List<BookServicesModel>> getListOfAppointments(
      UserModel userModel) {
    Query<Map<String, dynamic>> queryRef = FirebaseFirestore.instance
        .collection(BOOKING_SERVICES_MODEL_COLLECTION);
    if (userModel.userType == UserType.DOCTOR) {
      queryRef = queryRef.where("doctorId", isEqualTo: userModel.uid);
    } else {
      queryRef = queryRef.where("patientId", isEqualTo: userModel.uid);
    }
    return queryRef.snapshots().map((doc) => doc.docs.map((e) {
          final item = BookServicesModel.fromJson(e.data());
          item.bookId = e.id;
          return item;
        }).toList());
  }

  static Stream<List<ChatModel>> getListOfChatsByAppointment(
      BookServicesModel bookServicesModel,
      {startAfter}) {
    Query<Map<String, dynamic>> queryRef = FirebaseFirestore.instance
        .collection(BOOKING_SERVICES_MODEL_COLLECTION)
        .doc(getBookingServicesDocKey(bookServicesModel: bookServicesModel))
        .collection(CHAT_MODEL_COLLECTION)
        .orderBy("timeStamp", descending: true)
        .limit(10);
    if (startAfter != null) {
      queryRef = queryRef.startAfterDocument(startAfter);
    }
    return queryRef.snapshots().map(
        (doc) => doc.docs.map((e) => ChatModel.fromJson(e.data())).toList());
  }

  static Future<String> registerAccount({
    required UserModel userModel,
    required String password,
  }) async {
    User? user;
    UserCredential? credential;

    try {
      credential = await _auth.createUserWithEmailAndPassword(
        email: userModel.email,
        password: password,
      );
    } catch (error) {
      if (error.toString().compareTo(
              '[firebase_auth/email-already-in-use] The email address is already in use by another account.') ==
          0) {
        return Future.error("Already in Use");
      }
      return Future.error(error.toString());
    }
    user = credential.user;

    if (user != null) {
      await user.updateDisplayName(userModel.name);
      userModel.uid = user.uid;

      FirebaseFirestore.instance
          .collection(USER_MODEL_COLLECTION)
          .doc(user.uid)
          .set(userModel.toJson(), SetOptions(merge: true));

      return Future.value("Done");
    }
    return Future.error("User not found");
  }

  static Future<void> bookServices(
      {required BookServicesModel bookServicesModel}) {
    return FirebaseFirestore.instance
        .collection(BOOKING_SERVICES_MODEL_COLLECTION)
        .doc(getBookingServicesDocKey(bookServicesModel: bookServicesModel))
        .set(bookServicesModel.toJson(), SetOptions(merge: true));
  }

  static String getBookingServicesDocKey(
          {required BookServicesModel bookServicesModel}) =>
      '${bookServicesModel.doctorId}_${bookServicesModel.patientId}_${DateTime.now().subtract(Duration(hours: DateTime.now().hour, minutes: DateTime.now().minute, seconds: DateTime.now().second, milliseconds: DateTime.now().millisecond)).millisecondsSinceEpoch}';

  static void sendChatMsgServices(
      {required String bookingId, required ChatModel chatModel}) {
    FirebaseFirestore.instance
        .collection(BOOKING_SERVICES_MODEL_COLLECTION)
        .doc(bookingId)
        .collection(CHAT_MODEL_COLLECTION)
        .add(chatModel.toJson());
  }
}
