import 'package:flutter/material.dart';

import 'app/app.dart';
import 'data/services/local_storage_service.dart';
import 'data/services/auth_service.dart';

export 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Local Storage
  print('🔧 Initializing LocalStorageService...');
  await LocalStorageService.init();
  print('✅ LocalStorageService initialized successfully');

  // Initialize Dio with stored token (if user is already logged in)
  print('🔧 Initializing AuthService (Dio client)...');
  AuthService.initializeDio();
  print('✅ AuthService initialized successfully');

  // Check if user is logged in
  if (LocalStorageService.isLoggedIn()) {
    print('👤 User is already logged in');
    print('   User ID: ${LocalStorageService.getUserId()}');
    print('   User Email: ${LocalStorageService.getUserEmail()}');
  } else {
    print('🔓 No user logged in yet');
  }

  runApp(const DevVaultApp());
}
