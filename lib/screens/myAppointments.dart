import 'package:doctor_client/components/uiUtils.dart';
import 'package:doctor_client/screens/chatPage.dart';
import 'package:doctor_client/services/dataUtils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../model/bookServicesModel.dart';
import '../model/userModel.dart';

class MyAppointments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            'My Appointments & Chat',
            style: GoogleFonts.lato(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<UserModel>(
          stream: DataUtils.getCurrentUserModel(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasData && snapshot.data == null) {
              DataUtils.logoutUser();
              return Container();
            }

            return Container(
              padding: const EdgeInsets.only(right: 10, left: 10, top: 10),
              child: StreamBuilder<List<BookServicesModel>>(
                  stream: DataUtils.getListOfAppointments(snapshot.data!),
                  builder: (context, appointmentSnapShots) {
                    if (!appointmentSnapShots.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (appointmentSnapShots.hasData &&
                        (appointmentSnapShots.data == null ||
                            (appointmentSnapShots.data != null &&
                                appointmentSnapShots.data!.isEmpty))) {
                      return Center(
                        child: Text(
                          "Sorry :(, No Appointment available",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                        itemCount: appointmentSnapShots.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          final appointmentName = snapshot.data!.userType ==
                                  UserType.DOCTOR
                              ? appointmentSnapShots.data![index].patientName
                              : appointmentSnapShots.data![index].doctorName;

                          final getAppointmentDateTime = DateFormat.yMMMMd()
                              .format(DateTime.fromMillisecondsSinceEpoch(
                                  appointmentSnapShots.data![index].timeStamp));

                          final getAppointmentDate = DateFormat('dd\nE').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  appointmentSnapShots.data![index].timeStamp));

                          return GestureDetector(
                            onTap: () {
                              pushPage(
                                  context,
                                  ChatPage(
                                    userModel: snapshot.data,
                                    bookServicesModel:
                                        appointmentSnapShots.data![index],
                                  ));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.symmetric(
                                      horizontal: BorderSide(
                                          color: Colors.grey[200]!, width: 1))),
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.orange[300]!,
                                              width: 12,
                                            ),
                                            color: Colors.orange[300]!,
                                            shape: BoxShape.circle),
                                        child: Text(
                                          getAppointmentDate,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Appointment with ${appointmentName.toCapitalized()} on',
                                            style: GoogleFonts.lato(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 9,
                                          ),
                                          Text(
                                              '${getAppointmentDateTime}, tap on it to chat')
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  }),
            );
          }),
    );
  }
}
