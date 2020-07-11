import 'package:oodles/model/address.dart';

class User {
  int id;
  String name;
  String email;
  String phone;
  String website;
  Address address;

  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.website,
    this.address,
  });
}
