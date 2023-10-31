import 'package:flutter/material.dart';
import 'package:github_api_demo/api/github_api.dart';
import 'package:github_api_demo/models/user.dart';

class FollowingPage extends StatefulWidget {
  final User user;
  const FollowingPage(this.user);

  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  late Future<List<User>> futureUser;

  @override
  void initState() {
    futureUser = GithubApi().getFollowing(widget.user.login);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Following"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Colors.blue,
                    backgroundImage: NetworkImage(widget.user.avatarUrl),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  widget.user.login,
                  style: const TextStyle(fontSize: 22),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: FutureBuilder<List<User>>(
              future: futureUser,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Erro'));
                  } else {
                    final users = snapshot.data ?? [];
                    return ListView.separated(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: ((context) =>
                                    FollowingPage(users[index])),
                              ),
                            );
                          },
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(users[index].avatarUrl),
                          ),
                          title: Text(users[index].login),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                    );
                  }
                }
                return Container();
              },
            ),
          ),
        ]),
      ),
    );
  }
}
