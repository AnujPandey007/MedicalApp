import 'dart:async';
import 'package:doctor_client/screens/homePage.dart';
import 'package:doctor_client/screens/myAppointments.dart';
import 'package:doctor_client/screens/userProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'components/bottom_navigation.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Widget> _pages = [
    HomePage(),
    MyAppointments(),
    UserProfile(),
  ];
  final List<IconData> _iconsData = [
    Icons.map,
    Icons.chat_bubble_outlined,
    Icons.person,
  ];

  FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  final pageController = PageController();

  Future<void> _getUser() async {
    user = _auth.currentUser;
  }

  String shortcut = "no action set";

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        // body: _pages[_selectedIndex],
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: _pages,
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationDotBar(
          activeColor: Colors.black54,
          color: Colors.grey[350],
          items: <BottomNavigationDotBarItem>[
            ..._iconsData.mapIndexed((ele, index) {
              return BottomNavigationDotBarItem(
                  icon: ele,
                  onTap: () {
                    pageController.jumpToPage(index);
                  });
            })
          ],
        ),
        resizeToAvoidBottomInset: false,
    );
  }
}

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return  map((e) => f(e, i++));
  }
}
