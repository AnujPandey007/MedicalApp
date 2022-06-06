enum UserType { DOCTOR, PATIENT }

enum City { DELHI, MUMBAI, KOLKATA }

enum DoctorType { CARDIOLOGIST, DENTIST, PHYSICIAN, ORTHOPAEDIC, PAEDIATRICIAN }

List<String> profileImagesList = ["assets/boy.png", "assets/girl.png"];

const USER_MODEL_COLLECTION = "users";

class UserModel {
  late String uid;
  late String name;
  late String email;
  late UserType userType;
  late String? bio;
  late String image;
  late DoctorType? doctorType;
  late City city;

  UserModel(
      {required this.uid,
      required this.name,
      required this.email,
      required this.userType,
      required this.bio,
      required this.image,
      required this.doctorType,
      required this.city});

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "city": city.name,
      "bio": bio ?? "",
      "image": image,
      "doctorType": doctorType?.name ?? "",
      "userType": userType.name
    };
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json["uid"];
    name = json["name"];
    email = json["email"];
    image = json["image"];
    city = City.values.byName(json["city"]);
    userType = UserType.values.byName(json["userType"]);
    if (userType == UserType.DOCTOR) {
      doctorType = DoctorType.values.byName(json["doctorType"]);
      bio = json["bio"];
    }
  }
}
