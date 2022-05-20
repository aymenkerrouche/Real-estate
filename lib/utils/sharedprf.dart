import 'dart:convert';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  getAuthToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    return localStorage.getString('token');
  }

  getCurrentUser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    return jsonDecode(localStorage.getString('user')!);
  }
}




class CustomCacheManager {
  static const key = 'customCacheKey';
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 10,
      repo: JsonCacheInfoRepository(databaseName: key),
      fileService: HttpFileService(),
      
    ),
  );
}