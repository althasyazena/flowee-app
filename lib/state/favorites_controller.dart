import 'package:flutter/material.dart';

class FavoritesController extends ValueNotifier<Set<String>> {
  FavoritesController._() : super(<String>{}); // juga bisa buat ubah mode ke light/dark mode, sintaksnya sama

  static final FavoritesController intance = FavoritesController._();

  bool isFavorite(String id) => value.contains(id); // kalo dark ke light mode juga bisa pake id, id nya pake 1 0 atau 1 2 (binary number)

  void toggle(String id) { // fitur light/dark mode dan bahasa eng/ind juga pake toggle
    final updated = Set<String>.from(value);
    if (updated.remove(id)) { // remove id lama
      updated.add(id);
    }
    value = updated;
  }
}