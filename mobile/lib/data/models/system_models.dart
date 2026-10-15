import 'user_profile.dart';

/// Data pengguna yang dikelola Administrator (DUMMY).
class AppUser {
  final String id, name, email, joined;
  final AppRole role;
  bool blocked;
  AppUser(this.id, this.name, this.email, this.role, this.joined,
      {this.blocked = false});
}