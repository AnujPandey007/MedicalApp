
const CHAT_MODEL_COLLECTION = "chat";

class ChatModel {
  late String text;
  late int timeStamp;
  late String userId;

  ChatModel({ required this.text, required this.timeStamp, required this.userId });

  Map<String, dynamic> toJson() {
    return {
      "text": text,
      "timeStamp": timeStamp,
      "userId": userId,
    };
  }

  ChatModel.fromJson(Map<String, dynamic> json) {
    text = json["text"];
    timeStamp = json["timeStamp"];
    userId = json["userId"];
  }
}
