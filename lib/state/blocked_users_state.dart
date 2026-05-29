import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlockedUsersState {
  BlockedUsersState._();

  static const String _prefsKey = 'blocked_users';

  static final ValueNotifier<Set<String>> blockedEmails =
      ValueNotifier<Set<String>>(<String>{});

  static bool _initialized = false;

  static String _normalize(String email) => email.trim().toLowerCase();

  static Future<void> init({
    Set<String> defaultBlockedEmails = const <String>{},
  }) async {
    if (_initialized) return;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? savedEmails = prefs.getStringList(_prefsKey);

    final Set<String> fallbackEmails = defaultBlockedEmails
        .map(_normalize)
        .where((email) => email.isNotEmpty)
        .toSet();

    final Set<String> loadedEmails = (savedEmails ?? fallbackEmails.toList())
        .map(_normalize)
        .where((email) => email.isNotEmpty)
        .toSet();

    blockedEmails.value = Set<String>.unmodifiable(loadedEmails);

    if (savedEmails == null) {
      await _save(loadedEmails);
    }

    _initialized = true;
  }

  static Future<void> reload() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Set<String> loadedEmails =
        (prefs.getStringList(_prefsKey) ?? <String>[])
            .map(_normalize)
            .where((email) => email.isNotEmpty)
            .toSet();

    blockedEmails.value = Set<String>.unmodifiable(loadedEmails);
    _initialized = true;
  }

  static bool isBlocked(String email) {
    return blockedEmails.value.contains(_normalize(email));
  }

  static Future<void> toggle(String email) async {
    await setBlocked(email, !isBlocked(email));
  }

  static Future<void> setBlocked(String email, bool isBlocked) async {
    await init();

    final String normalizedEmail = _normalize(email);
    if (normalizedEmail.isEmpty) return;

    final Set<String> updatedEmails = Set<String>.from(blockedEmails.value);

    if (isBlocked) {
      updatedEmails.add(normalizedEmail);
    } else {
      updatedEmails.remove(normalizedEmail);
    }

    blockedEmails.value = Set<String>.unmodifiable(updatedEmails);
    await _save(updatedEmails);
  }

  static Future<void> _save(Set<String> emails) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> sortedEmails = emails.toList()..sort();
    await prefs.setStringList(_prefsKey, sortedEmails);
  }
}
