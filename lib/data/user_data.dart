import 'package:image_picker/image_picker.dart';

class UserData {
  late int _id;
  late String _fullName;
  late String _phone;
  late String _emailID;
  late String _password;
  late String _address;
  late String _addressName;
  late String _dp;
  late int _rewardPoints;
  late int _vouchers;

  get getID {
    return _id;
  }

  set setID(int id) {
    _id = id;
  }

  get getName {
    return _fullName;
  }

  set setName(String name) {
    _fullName = name;
  }

  get getPhone {
    return _phone;
  }

  set setPhone(String phone) {
    _phone = phone;
  }

  get getEmail {
    return _emailID;
  }

  set setEmail(String email) {
    _emailID = email;
  }

  get getPassword {
    return _password;
  }

  set setPassword(String password) {
    _password = password;
  }

  get getAddress {
    return _address;
  }

  set setAddress(String address) {
    _address = address;
  }

  get getAddressName {
    return _addressName;
  }

  set setAddressName(String addressName) {
    _addressName = addressName;
  }

  get getRewardPoints {
    return _rewardPoints;
  }

  set setRewardPoints(int points) {
    _rewardPoints = points;
  }

  get getVouchers {
    return _vouchers;
  }

  set setVouchers(int vouchers) {
    _vouchers = vouchers;
  }

  get getDp {
    return _dp;
  }

  set setDp(String dp) {
    _dp = dp;
  }
}
