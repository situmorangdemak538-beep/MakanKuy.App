import 'package:flutter/material.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Pengguna')),
      body: ListView(
        children: const [
          ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text('Pelanggan MakanKuy'),
            subtitle: Text('Customer • Aktif'),
            trailing: Icon(Icons.toggle_on),
          ),
          ListTile(
            leading: CircleAvatar(child: Icon(Icons.store)),
            title: Text('Admin Restoran'),
            subtitle: Text('Admin Restoran • Aktif'),
            trailing: Icon(Icons.toggle_on),
          ),
        ],
      ),
    );
  }
}