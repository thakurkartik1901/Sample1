import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:oodles/model/address.dart';
import 'package:oodles/model/user.dart';

class UsersProvider with ChangeNotifier {
  List<User> _items = [];
  List<User> _originalItems = [];

  UsersProvider() {
    fetchAndSetUsers();
  }

  List<User> get items {
    return [..._items];
  }

  Future<void> filterUsersOnNameBases(String name) {
    List<User> filteredUsers = [];
    for (User item in _originalItems) {
      if (item.name.contains(name)) {
        filteredUsers.add(item);
      }
    }
    _items = filteredUsers;
    notifyListeners();
  }

  Future<void> fetchAndSetUsers() async {
    final url = 'https://jsonplaceholder.typicode.com/users';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as List<dynamic>;
      if (extractedData == null) {
        return;
      }
      List<User> loadedUsers = [];
      loadedUsers = extractedData
          .map(
            (item) => User(
              id: item['id'],
              name: item['name'],
              email: item['email'],
              phone: item['phone'],
              website: item['website'],
              address: Address(
                suite: item['address']['suite'],
                street: item['address']['street'],
                city: item['address']['city'],
                zipcode: item['address']['zipcode'],
              ),
            ),
          )
          .toList();
      _originalItems = loadedUsers;
      _items = loadedUsers;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> setUsers() async {
    if (_originalItems == null) {
      fetchAndSetUsers();
      return;
    }
    _items = _originalItems;
    notifyListeners();
  }
}
