import 'package:doctor_client/components/uiUtils.dart';
import 'package:doctor_client/model/chatModel.dart';
import 'package:doctor_client/services/dataUtils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../model/bookServicesModel.dart';
import '../model/userModel.dart';

class ChatPage extends StatefulWidget {
  UserModel? userModel;
  BookServicesModel? bookServicesModel;

  ChatPage({Key? key, this.userModel, this.bookServicesModel})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // late DocumentSnapshot _products;
  // bool _isRequesting = false;
  // bool _isFinish = false;

  TextEditingController messageEditingController = TextEditingController();

  void requestNextPage() async {
    // if (!_isRequesting && !_isFinish) {
    //   QuerySnapshot querySnapshot;
    //   _isRequesting = true;
    //   if (_products.isEmpty) {
    //     querySnapshot = await Firestore.instance
    //         .collection('products')
    //         .orderBy('index')
    //         .limit(5)
    //         .getDocuments();
    //   } else {
    //     querySnapshot = await Firestore.instance
    //         .collection('products')
    //         .orderBy('index')
    //         .startAfterDocument(_products[_products.length - 1])
    //         .limit(5)
    //         .getDocuments();
    //   }
    //
    //   if (querySnapshot != null) {
    //     int oldSize = _products.length;
    //     _products.addAll(querySnapshot.documents);
    //     int newSize = _products.length;
    //     if (oldSize != newSize) {
    //       _streamController.add(_products);
    //     } else {
    //       _isFinish = true;
    //     }
    //   }
    //   _isRequesting = false;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            widget.userModel!.name,
            style: GoogleFonts.lato(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        padding: const EdgeInsets.only(right: 10, left: 10, top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.maxScrollExtent ==
                    scrollInfo.metrics.pixels) {
                  requestNextPage();
                }
                return true;
              },
              child: StreamBuilder<List<ChatModel>>(
                  stream: DataUtils.getListOfChatsByAppointment(
                      widget.bookServicesModel!),
                  builder: (context, chatSnapShots) {
                    if (!chatSnapShots.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (chatSnapShots.hasData &&
                        (chatSnapShots.data == null ||
                            (chatSnapShots.data != null &&
                                chatSnapShots.data!.isEmpty))) {
                      return Center(
                        child: Text(
                          "Sorry :(, No Chat available",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }

                    return Expanded(
                      child: Scrollbar(
                        thickness: 4.5,
                        child: ListView.builder(
                            reverse: true,
                            shrinkWrap: true,
                            itemCount: chatSnapShots.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return getChatMessageItemUI(
                                  context: context,
                                  isSendByCurrentUser:
                                      chatSnapShots.data![index].userId ==
                                          widget.userModel!.uid,
                                  chatModel: chatSnapShots.data![index]);
                            }),
                      ),
                    );
                  }),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.10,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextField(
                          textInputAction: TextInputAction.send,
                          controller: messageEditingController,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 13),
                          onTap: () {},
                          onEditingComplete: () {
                            DataUtils.sendChatMsgServices(
                                bookingId: widget.bookServicesModel!.bookId!,
                                chatModel: ChatModel(
                                    text: messageEditingController.text,
                                    timeStamp:
                                        DateTime.now().millisecondsSinceEpoch,
                                    userId: widget.userModel!.uid));
                            messageEditingController.text = "";
                          },
                          decoration: InputDecoration(
                              hintText: "Message ...",
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                              filled: true,
                              fillColor: Colors.white70,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide:
                                    const BorderSide(color: Colors.white70),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide:
                                    const BorderSide(color: Colors.white70),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide:
                                    const BorderSide(color: Colors.white70),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide:
                                    const BorderSide(color: Colors.white70),
                              ),
                              contentPadding: const EdgeInsets.all(12.5)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    IconButton(
                      onPressed: () {
                        DataUtils.sendChatMsgServices(
                            bookingId: widget.bookServicesModel!.bookId!,
                            chatModel: ChatModel(
                                text: messageEditingController.text,
                                timeStamp:
                                    DateTime.now().millisecondsSinceEpoch,
                                userId: widget.userModel!.uid));
                        messageEditingController.text = "";
                      },
                      splashRadius: 25.0,
                      splashColor: Colors.transparent,
                      icon: const Icon(
                        Icons.send,
                        color: Color(0xff263d54),
                        size: 23,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
