import 'dart:math' as math;

import 'package:doctor_client/model/chatModel.dart';
import 'package:doctor_client/model/userModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

String getRandomImage() =>
    profileImagesList[math.Random().nextInt(profileImagesList.length)];

Widget getDoctorProfileHolder({
  required BuildContext context,
  required UserModel userModel,
  required void Function() onPressed,
  double heightRatio = 0.75,
  double rightMargin = 5,
  double topMargin = 5,
  double leftMargin = 5,
  double bottomMargin = 5,
}) =>
    Card(
      elevation: 0,
      color: Colors.transparent,
      child: Container(
          width: MediaQuery.of(context).size.width * heightRatio,
          constraints: const BoxConstraints(
            minHeight: 150,
            maxHeight: 150,
          ),
          margin: EdgeInsets.only(
              top: topMargin,
              bottom: bottomMargin,
              left: leftMargin,
              right: rightMargin),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[300]!,
                  blurRadius: 14.0,
                ),
              ]),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                  constraints: BoxConstraints(
                    maxWidth:
                        MediaQuery.of(context).size.width * heightRatio / 2.5,
                  ),
                  decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(14.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[200]!,
                          blurRadius: 18.0,
                        ),
                      ]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14.0),
                    child: Image.asset(
                      "assets/boy.jpg",
                      fit: BoxFit.cover,
                    ),
                  )),
              Flexible(
                flex: 1,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text.rich(TextSpan(
                              text: "Name: ",
                              style: GoogleFonts.lato(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: userModel.name.toTitleCase(),
                                  style: GoogleFonts.lato(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                  ),
                                )
                              ])),
                          const SizedBox(
                            height: 5,
                          ),
                          Text.rich(TextSpan(
                              text: "Specialist: ",
                              style: GoogleFonts.lato(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                              children: <InlineSpan>[
                                TextSpan(
                                  text:
                                      userModel.doctorType?.name.toTitleCase(),
                                  style: GoogleFonts.lato(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                  ),
                                )
                              ])),
                          const SizedBox(
                            height: 5,
                          ),
                          if (userModel.userType == UserType.DOCTOR) ...[
                            Text(
                              userModel.bio!,
                              maxLines: 2,
                              softWrap: true,
                              style: GoogleFonts.lato(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                              ),
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ],
                      ),
                      Center(
                        child: TextButton(
                          onPressed: onPressed,
                          child: const Text("Book Me"),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )),
    );

Widget getChatMessageItemUI({
  required BuildContext context,
  required bool isSendByCurrentUser,
  required ChatModel chatModel,
}) =>
    Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: isSendByCurrentUser ? 0 : 24,
          right: isSendByCurrentUser ? 24 : 0),
      alignment:
          isSendByCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: isSendByCurrentUser
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        padding:
            const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
        decoration: BoxDecoration(
            borderRadius: isSendByCurrentUser
                ? const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15))
                : const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
            gradient: LinearGradient(
              colors: isSendByCurrentUser
                  ? [
                      Colors.white70,
                      Colors.white,
                    ]
                  : [const Color(0xff263d54), const Color(0xff263d54)],
            )),
        child: RichText(
            text: TextSpan(children: [
          TextSpan(
            text: chatModel.text,
            style: TextStyle(
                color: isSendByCurrentUser ? Colors.black : Colors.white,
                fontSize: 13,
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.normal),
          ),
          TextSpan(
              text:
                  "   ${getTimeDiff(DateTime.fromMillisecondsSinceEpoch(chatModel.timeStamp))}",
              style: TextStyle(
                color:
                    isSendByCurrentUser ? Colors.grey[600] : Colors.grey[400],
                fontSize: 9,
                fontWeight: FontWeight.w300,
              )),
        ])),
      ),
    );

showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: Row(
      children: [
        const CircularProgressIndicator(),
        Container(
            margin: const EdgeInsets.only(left: 15),
            child: const Text("Loading...")),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

String getTimeDiff(DateTime dateTime){
  final duration = DateTime.now().difference(dateTime);
  if(duration.isNegative)
    return "0 sec ago";
  if(duration.inSeconds < 60) {
    return duration.inSeconds > 1 ? "${duration.inSeconds} secs ago": "${duration.inSeconds} sec ago";
  } else if(duration.inMinutes < 60) {
    return duration.inMinutes > 1 ? "${duration.inMinutes} mins ago": "${duration.inMinutes} min ago";
  } else if(duration.inHours < 24){
    return duration.inHours > 1 ? "${duration.inHours} hours ago": "${duration.inHours} hour ago";
  } else if(duration.inDays < 30) {
    return duration.inDays > 1 ? "${duration.inDays} days ago": "${duration.inDays} day ago";
  } else if(duration.inDays >= 30 && duration.inDays <= 364) {
    return (duration.inDays/30).floor() > 1 ? "${(duration.inDays/30).floor()} months ago": "${(duration.inDays/30).floor()} month ago";
  } else {
    return (duration.inDays/365).floor() > 1 ? "${(duration.inDays/365).floor()} years ago": "${(duration.inDays/365).floor()} year ago";
  }
}

void pushPage(BuildContext context, Widget page) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => page)
  );
}

void pushAndRemoveUntilPage(BuildContext context, Widget page) {
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => page),
          (Route<dynamic> route) => false);
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
