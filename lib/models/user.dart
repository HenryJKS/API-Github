import 'dart:convert';
import 'dart:html';
import 'package:http/http.dart' as http;

void main(List<String> arguments) {}

class GithubApi {
  final token = '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';

  Future<User?> getUser(String username) async {
    final uri = Uri.parse("https://api.github.com/users/$username");
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final user = User.fromJson(data);
      return user;
    } else {
      return null;
    }
  }
}

class User {
  final String login;
  final String avatarUrl;

  User({required this.login, required this.avatarUrl});

  factory User.fromJson(Map<String, dynamic> map) {
    return User(login: map['login'], avatarUrl: map['avatar_url']);
  }
}
