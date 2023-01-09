import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<bool> saveTheme(String theme) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool result = await sharedPreferences.setString("theme", theme);
    return result;
  }

  static Future<String?> getTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? currenTheme = sharedPreferences.getString("theme");
    return currenTheme;
  }

  static Future<bool> addFavourite(String id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    List<String> favourites =
        sharedPreferences.getStringList("favourites") ?? [];
    favourites.add(id);

    return await sharedPreferences.setStringList("favourites", favourites);
  }

  static Future<bool> removeFavourite(String id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    List<String> favourites =
        sharedPreferences.getStringList("favourites") ?? [];
    favourites.remove(id);

    return await sharedPreferences.setStringList("favourites", favourites);
  }

  static Future<List<String>> fetchFavourites() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getStringList("favourites") ?? [];
  }
}
