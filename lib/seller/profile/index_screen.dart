import 'package:flutter/material.dart';
import 'package:flutter_application_1/api/user_api.dart';
import 'package:flutter_application_1/model/user_model.dart';

class IndexProfileScreen extends StatefulWidget {
  const IndexProfileScreen({super.key});

  @override
  _IndexCategoryState createState() => _IndexCategoryState();
}

class _IndexCategoryState extends State<IndexProfileScreen> {
  late UserApi userApi;
  late Future<User?> futureUser;

  @override
  void initState() {
    super.initState();
    userApi = UserApi();
    futureUser = UserApi().getUser();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<User?>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('User not found.'));
          } else {
            // Data tersedia
            final user = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('images/pink.png'), // Ganti dengan path gambar profil Anda
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(text: user.name),
                    decoration: const InputDecoration(
                      labelText: "Nama",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(text: user.email),
                    decoration: const InputDecoration(
                      labelText: "E-Mail",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(text: user.address ?? ""),
                    decoration: const InputDecoration(
                      labelText: "Alamat",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

}
