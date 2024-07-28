import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:specialists_v2/registration_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://tswcrfxqqxyvxordvnrp.supabase.co', 
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRzd2NyZnhxcXh5dnhvcmR2bnJwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjEzMjM3OTQsImV4cCI6MjAzNjg5OTc5NH0.w2CyPUzHKF1rBk-DvOvz_6NL9JN_4PMRR6sEH0qiPmE',
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RegistrationPage(), 
    );
  }
}
