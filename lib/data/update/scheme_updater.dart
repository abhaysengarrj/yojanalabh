import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/scheme.dart';

class SchemeUpdater {
  static const String _owner = 'abhaysengarrj';
  static const String _repo = 'yojanalabh';
  static const String _versionUrl =
      'https://raw.githubusercontent.com/$_owner/$_repo/main/version.txt';
  static const String _schemesUrl =
      'https://raw.githubusercontent.com/$_owner/$_repo/main/assets/schemes/schemes_v1.json';

  static const String _lastCheckKey = 'last_update_check';
  static const int _checkIntervalDays = 7;

  Future<bool> shouldCheckForUpdates() async {
    final prefs = await SharedPreferences.getInstance();
    final lastCheck = prefs.getInt(_lastCheckKey);
    if (lastCheck == null) return true;
    final diff = DateTime.now().millisecondsSinceEpoch - lastCheck;
    return diff > _checkIntervalDays * 24 * 60 * 60 * 1000;
  }

  Future<void> markCheckDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      _lastCheckKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<SchemeUpdatePayload?> checkForUpdates() async {
    try {
      final versionResponse = await http.get(
        Uri.parse(_versionUrl),
      ).timeout(const Duration(seconds: 10));
      if (versionResponse.statusCode != 200) return null;

      final remoteVersion = int.tryParse(versionResponse.body.trim());
      if (remoteVersion == null) return null;

      final prefs = await SharedPreferences.getInstance();
      final localVersion = prefs.getInt('scheme_version') ?? 1;
      if (remoteVersion <= localVersion) return null;

      final schemesResponse = await http.get(
        Uri.parse(_schemesUrl),
      ).timeout(const Duration(seconds: 30));
      if (schemesResponse.statusCode != 200) return null;

      final jsonData = json.decode(schemesResponse.body)
          as Map<String, dynamic>;
      await prefs.setInt('scheme_version', remoteVersion);
      return SchemeUpdatePayload.fromJson(jsonData);
    } catch (_) {
      return null;
    }
  }
}
