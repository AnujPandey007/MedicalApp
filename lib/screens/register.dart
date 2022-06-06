import 'package:doctor_client/components/customSelect.dart';
import 'package:doctor_client/services/dataUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:doctor_client/screens/signIn.dart';

import '../components/uiUtils.dart';
import '../mainPage.dart';
import '../model/userModel.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _displayName = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  UserType? userType;
  DoctorType? doctorType;
  City? cityType;

  FocusNode f1 = new FocusNode();
  FocusNode f2 = new FocusNode();
  FocusNode f3 = new FocusNode();
  FocusNode f4 = new FocusNode();
  FocusNode f5 = new FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowGlow();
              return true;
            },
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
                    child: _signUp(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _signUp() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(right: 16, left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 50),
              child: Text(
                'Sign up',
                style: GoogleFonts.lato(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            CustomSelect<UserType>(
              hintText: "Are you a doctor or patient?",
              options: UserType.values,
              value: userType,
              validator: (value) {
                if (value == null) {
                  return 'Please enter this field';
                } else {
                  return null;
                }
              },
              onChanged: (UserType? value) {
                if (value != null) {
                  setState(() {
                    userType = value;
                  });
                }
              },
              getLabel: (UserType value) => value.name,
            ),
            const SizedBox(
              height: 25.0,
            ),
            if (userType == UserType.DOCTOR) ...[
              CustomSelect<DoctorType>(
                hintText: "Which type of Doctor?",
                options: DoctorType.values,
                value: doctorType,
                validator: (value) {
                  if (value == null) {
                    return 'Please enter this field';
                  } else {
                    return null;
                  }
                },
                onChanged: (DoctorType? value) {
                  if (value != null) {
                    setState(() {
                      doctorType = value;
                    });
                  }
                },
                getLabel: (DoctorType value) => value.name,
              ),
              const SizedBox(
                height: 25.0,
              ),
            ] else ...[
              Container()
            ],
            CustomSelect<City>(
              hintText: "Where do you live?",
              options: City.values,
              value: cityType,
              validator: (value) {
                if (value == null) {
                  return 'Please enter this field';
                } else {
                  return null;
                }
              },
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
              height: 25.0,
            ),
            TextFormField(
              focusNode: f1,
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              keyboardType: TextInputType.emailAddress,
              controller: _displayName,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(90.0)),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[350],
                hintText: 'Name',
                hintStyle: GoogleFonts.lato(
                  color: Colors.black26,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              onFieldSubmitted: (value) {
                f1.unfocus();
                FocusScope.of(context).requestFocus(f2);
              },
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value!.isEmpty) return 'Please enter the Name';
                return null;
              },
            ),
            const SizedBox(
              height: 25.0,
            ),
            TextFormField(
              focusNode: f2,
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(90.0)),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[350],
                hintText: 'Email',
                hintStyle: GoogleFonts.lato(
                  color: Colors.black26,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              onFieldSubmitted: (value) {
                f2.unfocus();
                if (_passwordController.text.isEmpty) {
                  FocusScope.of(context).requestFocus(f3);
                }
              },
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the Email';
                } else if (!emailValidate(value)) {
                  return 'Please enter correct Email';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 25.0,
            ),
            TextFormField(
              focusNode: f3,
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              //keyboardType: TextInputType.visiblePassword,
              controller: _passwordController,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(90.0)),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[350],
                hintText: 'Password',
                hintStyle: GoogleFonts.lato(
                  color: Colors.black26,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              onFieldSubmitted: (value) {
                f3.unfocus();
                if (_passwordConfirmController.text.isEmpty) {
                  FocusScope.of(context).requestFocus(f4);
                }
              },
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the Password';
                } else if (value.length < 8) {
                  return 'Password must be at least 8 characters long';
                } else {
                  return null;
                }
              },
              obscureText: true,
            ),
            const SizedBox(
              height: 25.0,
            ),
            TextFormField(
              focusNode: f4,
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              controller: _passwordConfirmController,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(90.0)),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[350],
                hintText: 'Confirm Password',
                hintStyle: GoogleFonts.lato(
                  color: Colors.black26,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              onFieldSubmitted: (value) {
                f4.unfocus();
              },
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the Password';
                } else if (value.compareTo(_passwordController.text) != 0) {
                  return 'Password not Matching';
                } else {
                  return null;
                }
              },
              obscureText: true,
            ),
            if (userType == UserType.DOCTOR) ...[
              const SizedBox(
                height: 25.0,
              ),
              TextFormField(
                focusNode: f5,
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
                maxLines: 3,
                controller: _bioController,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(90.0)),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[350],
                  hintText: 'Bio',
                  hintStyle: GoogleFonts.lato(
                    color: Colors.black26,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                onFieldSubmitted: (value) {
                  f5.unfocus();
                },
                textInputAction: TextInputAction.newline,
                validator: (value) {
                  if (value!.isEmpty && userType == UserType.DOCTOR) {
                    return 'Please enter the Bio';
                  } else {
                    return null;
                  }
                },
              )
            ] else ...[
              Container()
            ],
            Container(
              padding: const EdgeInsets.only(top: 25.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      showLoaderDialog(context);
                      DataUtils.registerAccount(
                              userModel: UserModel(
                                  uid: "",
                                  name: _displayName.text,
                                  email: _emailController.text,
                                  userType: userType!,
                                  doctorType: doctorType,
                                  image: userType! == UserType.PATIENT
                                      ? 'assets/person.jpg'
                                      : getRandomImage(),
                                  bio: _bioController.text,
                                  city: cityType!),
                              password: _passwordController.text)
                          .then((value) {
                        pushAndRemoveUntilPage(context, MainPage());
                      }).catchError((err) => showAlertDialog(context));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 2,
                    primary: Colors.indigo[900],
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  child: Text(
                    "Sign Up",
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 25, left: 10, right: 10),
              width: MediaQuery.of(context).size.width,
              child: const Divider(
                thickness: 1.5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: GoogleFonts.lato(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent)),
                    onPressed: () => pushPage(context, SignIn()),
                    child: Text(
                      'Sign in',
                      style: GoogleFonts.lato(
                        fontSize: 15,
                        color: Colors.indigo[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    Navigator.pop(context);
    // set up the button
    Widget okButton = TextButton(
      child: Text(
        "OK",
        style: GoogleFonts.lato(fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.pop(context);
        FocusScope.of(context).requestFocus(f2);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Error!",
        style: GoogleFonts.lato(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        "Email already Exists",
        style: GoogleFonts.lato(),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  bool emailValidate(String email) {
    if (RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      return true;
    } else {
      return false;
    }
  }
}
