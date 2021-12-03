import 'package:flutter/material.dart';

class Customer with ChangeNotifier {
  static Customer? _instance;

  String? id = "1";
  String? name = "Hieu";
  String? phone = "0943310394";
  String? fullAddress = "60 Tho quan";
  String? customerProfileId = "1";

  static Customer get instance {
    return _instance ??= Customer();
  }

  bool get hasCustomer {
    return id != null && customerProfileId != null;
  }

  void setCustomer(dynamic jsonString) {
    print(jsonString);
    id = jsonString['id'];
    customerProfileId = jsonString['customerProfileId'];
    name = jsonString['name'];
    phone = jsonString['phone'];
    fullAddress = jsonString['fullAddress'];
    notifyListeners();
  }
}
