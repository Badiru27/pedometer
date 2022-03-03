import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String todayStepKey = 'todayStep';
const String previousStepKey = 'previousStep';
final today = DateTime.now();
final todayKey = '${today.year}${today.month}${today.day}${today.hour}';
final yesterday = today.subtract(const Duration(days: 1));
final yesterdayKey = '${yesterday.year}${yesterday.month}${yesterday.day}${yesterday.hour}';


class LocalStorageService {
  static LocalStorageService? _instance;
  static SharedPreferences? _preferences;

  static Future<LocalStorageService> getInstance() async {
    _instance ??= LocalStorageService();

    if (_preferences == null) {
      WidgetsFlutterBinding.ensureInitialized();
      _preferences = await SharedPreferences.getInstance();
    }

    return _instance!;
  }

  Future<void> _saveToDisk<T>(String key, T content) async {
    if (content is String) {
      await _preferences!.setString(key, content);
    }
    if (content is bool) {
      await _preferences!.setBool(key, content);
    }
    if (content is int) {
      await _preferences!.setInt(key, content);
    }
    if (content is double) {
      await _preferences!.setDouble(key, content);
    }
    if (content is List<String>) {
      await _preferences!.setStringList(key, content);
    }
  }

  Object? _getFromDisk(String key) {
    final value = _preferences!.get(key);
    return value;
  }

  Future<bool> _removeFromDisk(String key) async {
    final value = await _preferences!.remove(key);
    return value;
  }

  Future<void> saveTodayStep({required int steps}) async {
    await _saveToDisk(todayStepKey, json.encode({'steps': steps}));
  }

  Future<int> getTodayStep() async{
    final response = await jsonDecode(_getFromDisk(todayStepKey).toString());

    if (response== null) {
      return 0;
    } else {
      return response['steps'];
    }
  }

  // Future<void> savePreviousStep({required int steps}) async {
  //   await _saveToDisk(previousStepKey, json.encode({'steps': steps}));
  // }

  Future<void> saveSteps({required int steps, required DateTime key}) async {
    await _saveToDisk('${key.year}${key.month}${key.day}${key.hour}',
        json.encode({'steps': steps}));
  }

  int getPreviousStep({DateTime? key }) {

    String storeKey = key == null? yesterdayKey: '${key.year}${key.month}${key.day}${key.hour}';
    final response =  jsonDecode(_getFromDisk(storeKey).toString());
    if(response == null){
      return 0;
    }else{
      return response['steps'];
    }
  }

  Stream<int> getSteps(){
    return Stream.periodic(const Duration(seconds: 1), (_) {
      return  getPreviousStep(key: DateTime.now());
    });
  }
}
