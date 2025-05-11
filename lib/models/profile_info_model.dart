import 'dart:convert';

ProfileInfoModel profileInfoModelFromJson(String str) =>
    ProfileInfoModel.fromJson(json.decode(str));

class ProfileInfoModel {
  ProfileInfoModel({
    required this.userDetails,
  });

  UserDetails userDetails;

  factory ProfileInfoModel.fromJson(Map<String, dynamic> json) =>
      ProfileInfoModel(
        userDetails: UserDetails.fromJson(json["user_details"]),
      );
}

class UserDetails {
  UserDetails({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    required this.emailVerified,
    this.emailVerifyToken,
    this.userPoints,
    required this.phone,
    this.address,
    required this.state,
    this.city,
    this.zipcode,
    required this.country,
    this.image,
    this.facebookId,
    this.googleId,
    this.profileImageUrl,
    this.profileImage,
    required this.userCountry,
    required this.shipping,
    required this.userState,
    required this.userCity,
  });

  dynamic id;
  String name;
  String email;
  String username;
  bool emailVerified;
  dynamic emailVerifyToken;
  dynamic phone;
  dynamic address;
  String? state;
  dynamic city;
  dynamic userPoints;
  dynamic zipcode;
  String? country;
  dynamic image;
  dynamic facebookId;
  dynamic googleId;
  dynamic profileImageUrl;
  dynamic profileImage;
  CountryState? userCountry;
  List<dynamic> shipping;
  CountryState? userState;
  CountryState? userCity;

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        username: json["username"],
        emailVerified: json["email_verified"] == 1,
        emailVerifyToken: json["email_verify_token"],
        phone: json["phone"],
        address: json["address"],
        state: json["state"],
        city: json["city"],
        userPoints: json["user_points"],
        zipcode: json["zipcode"],
        country: json["country"],
        image: json["image"],
        facebookId: json["facebook_id"],
        googleId: json["google_id"],
        profileImageUrl: json["profile_image_url"],
        profileImage: json["profile_image"],
        userCountry: json["user_country"] == null
            ? null
            : CountryState.fromJson(json["user_country"]),
        shipping: List<dynamic>.from(json["shipping"].map((x) => x)),
        userState: json["user_state"] == null
            ? null
            : CountryState.fromJson(json["user_state"]),
        userCity: json["user_city"] == null
            ? null
            : CountryState.fromJson(json["user_city"]),
      );
}

class CountryState {
  CountryState({
    required this.id,
    required this.name,
    required this.status,
    this.countryId,
    this.stateId,
  });

  dynamic id;
  String name;
  String status;
  dynamic countryId;
  dynamic stateId;

  factory CountryState.fromJson(Map<String, dynamic> json) => CountryState(
        id: json["id"],
        name: json["name"],
        status: json["status"],
        countryId: json["country_id"],
        stateId: json["state_id"],
      );
}
