import 'dart:async';
import 'package:doctor_client/mainPage.dart';
import 'package:doctor_client/model/bookServicesModel.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/customSelect.dart';
import '../components/uiUtils.dart';
import '../model/userModel.dart';
import '../services/dataUtils.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late List<UserModel> userModels = [];

  City cityType = City.KOLKATA;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late String _message;
    DateTime now = DateTime.now();
    String _currentHour = DateFormat('kk').format(now);
    int hour = int.parse(_currentHour);

    setState(
      () {
        if (hour >= 5 && hour < 12) {
          _message = 'Good Morning';
        } else if (hour >= 12 && hour <= 17) {
          _message = 'Good Afternoon';
        } else {
          _message = 'Good Evening';
        }
      },
    );
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[Container()],
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          padding: const EdgeInsets.only(top: 5),
          child: Center(
            child: Text(
              _message,
              style: GoogleFonts.lato(
                color: Colors.black54,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowGlow();
            return true;
          },
          child: StreamBuilder<User?>(
              stream: DataUtils().authInstance,
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
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          "Hello ${snapshot.data!.displayName!}",
                          style: GoogleFonts.lato(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(bottom: 25),
                        child: Text(
                          "Let's Find Your\nDoctor",
                          style: GoogleFonts.lato(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      CustomSelect<City>(
                        options: City.values,
                        value: cityType,
                        onChanged: (City? value) {
                          if (value != null) {
                            setState(() {
                              cityType = value;
                            });
                          }
                        },
                        getLabel: (City value) => value.name,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Top Rated Doctors",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                              color: Colors.blue[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      StreamBuilder<List<UserModel>>(
                          stream: DataUtils.getListOfDoctorsByCity(cityType),
                          builder: (context, userModels) {
                            if (!userModels.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (userModels.hasData &&
                                (userModels.data == null ||
                                    (userModels.data != null &&
                                        userModels.data!.isEmpty))) {
                              return Center(
                                child: Text(
                                  "Sorry :(, No Doctor for this location available",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lato(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }

                            return ListView(
                              shrinkWrap: true,
                              children:
                                  userModels.data!.mapIndexed((ele, index) {
                                return getDoctorProfileHolder(
                                    context: context,
                                    userModel: ele,
                                    onPressed: () {
                                      showLoaderDialog(context);
                                      DataUtils.bookServices(
                                          bookServicesModel: BookServicesModel(
                                        doctorId: ele.uid,
                                        doctorName: ele.name,
                                        patientId: snapshot.data!.uid,
                                        patientName:
                                            snapshot.data!.displayName!,
                                        // bookingSlot: List<SlotModel>.generate(2,
                                        //     (i) => SlotModel(isBooked: false)),
                                        timeStamp: DateTime.now()
                                            .millisecondsSinceEpoch,
                                      )).then((value) {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text("Booked for Today"),
                                        ));
                                      }).catchError((err) {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text("Error Occurred"),
                                        ));
                                      });
                                    });
                              }).toList(),
                            );
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}
