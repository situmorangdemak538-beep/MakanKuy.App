import 'package:flutter/material.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() =>
      _UserManagementScreenState();
}

class _UserManagementScreenState
    extends State<UserManagementScreen> {
  final users = <Map<String, String>>[
    {
      'name': 'Pelanggan Contoh',
      'email': 'customer@example.com',
      'role': 'Customer',
      'status': 'Aktif',
    },
    {
      'name': 'Admin Restoran',
      'email': 'admin@restoran.com',
      'role': 'Admin Restoran',
      'status': 'Aktif',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Pengguna'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text(user['name']!),
              subtitle: Text(
                '${user['email']}\n'
                '${user['role']} • ${user['status']}',
              ),
              isThreeLine: true,
              trailing: Switch(
                value: user['status'] == 'Aktif',
                onChanged: (value) {
                  setState(() {
                    user['status'] =
                        value ? 'Aktif' : 'Diblokir';
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}