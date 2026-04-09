import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user.dart';

class ApiService {
  // Fetch user data from the REST API and parse it into a list of User objects.
  static Future<List<User>> fetchUsers() async {
    final uri = Uri.parse('https://jsonplaceholder.typicode.com/users');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> decoded = jsonDecode(response.body) as List<dynamic>;
      return decoded
          .map((userJson) => User.fromJson(userJson as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
