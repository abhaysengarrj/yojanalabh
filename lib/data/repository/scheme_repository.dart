import 'dart:convert';
import 'package:flutter/services.dart';
import '../database/app_database.dart';
import '../../models/scheme.dart';

class SchemeRepository {
  final AppDatabase _db = AppDatabase();

  Future<void> loadSeedData() async {
    final db = await _db.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM schemes');
    final count = result.first['count'] as int? ?? 0;
    if (count > 0) return;

    final jsonString = await rootBundle.loadString(
      'assets/schemes/schemes_v1.json',
    );
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;
    final schemes = (jsonData['schemes'] as List)
        .map((e) => Scheme.fromJson(e as Map<String, dynamic>))
        .toList();

    final batch = db.batch();
    for (final scheme in schemes) {
      batch.insert('schemes', scheme.toDbMap());
    }
    await batch.commit(noResult: true);
  }

  Future<List<Scheme>> getAllSchemes() async {
    final db = await _db.database;
    final rows = await db.query('schemes');
    return rows.map((row) => _rowToScheme(row)).toList();
  }

  Future<List<Scheme>> getSchemesByCategory(String category) async {
    final db = await _db.database;
    final rows = await db.query(
      'schemes',
      where: 'category = ?',
      whereArgs: [category],
    );
    return rows.map((row) => _rowToScheme(row)).toList();
  }

  Future<Scheme?> getSchemeById(int id) async {
    final db = await _db.database;
    final rows = await db.query('schemes', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return _rowToScheme(rows.first);
  }

  Future<void> replaceAllSchemes(List<Scheme> schemes) async {
    final db = await _db.database;
    await db.transaction((txn) async {
      await txn.delete('schemes');
      final batch = txn.batch();
      for (final scheme in schemes) {
        batch.insert('schemes', scheme.toDbMap());
      }
      await batch.commit(noResult: true);
    });
  }

  Scheme _rowToScheme(Map<String, dynamic> row) {
    return Scheme(
      id: row['id'] as int,
      name: row['name'] as String,
      description: row['description'] as String,
      ministry: row['ministry'] as String,
      applyLink: row['applyLink'] as String,
      category: row['category'] as String,
      eligibility: _parseEligibilityJson(row['eligibilityJson'] as String),
      version: row['version'] as int? ?? 1,
    );
  }

  EligibilityRules _parseEligibilityJson(String jsonString) {
    try {
      final map = json.decode(jsonString) as Map<String, dynamic>;
      return EligibilityRules.fromJson(map);
    } catch (_) {
      final map = _parseSimpleMap(jsonString);
      return EligibilityRules.fromJson(map);
    }
  }

  Map<String, dynamic> _parseSimpleMap(String str) {
    final map = <String, dynamic>{};
    final cleaned = str.replaceAll('{', '').replaceAll('}', '');
    for (final pair in cleaned.split(', ')) {
      final parts = pair.split(': ');
      if (parts.length == 2) {
        final key = parts[0].trim();
        var value = parts[1].trim();
        if (value == 'true') {
          map[key] = true;
        } else if (value == 'false') {
          map[key] = false;
        } else {
          final numVal = num.tryParse(value);
          if (numVal != null) {
            map[key] = numVal;
          } else {
            map[key] = value;
          }
        }
      }
    }
    return map;
  }
}
