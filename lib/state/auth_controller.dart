import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ValueNotifier<bool> {
  AuthController._() : super(false);

  static final AuthController instance = AuthController._();

  static const _prefsKey = 'flowee_is_logged_in';

  // dipanggil sekali saat aplikasi baru dibuka (muncul splash screen),
  // fungsinya untuk membaca status login yang tersimpan dari sesi SEBELUMNYA
  Future<void> loadPresistedSession() async {
    final prefs = await SharedPreferences.getInstance();
    value = prefs.getBool(_prefsKey) ?? false; // tanda tanya 2 kali artinya defaul value
  }

  Future<void> login() async {
    value = true;
    final prefs = await SharedPreferences.getInstance(); // sharedpreferences untuk menyimpan sebuah value, apapun yang bisa disimpan ke local storage
    await prefs.setBool(_prefsKey, true);
  }

  Future<void> logout() async {
    value = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, false);
  }
}