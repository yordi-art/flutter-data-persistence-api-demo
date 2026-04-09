import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _nameKey = 'saved_name';
  static const String _noteFileName = 'saved_note.txt';

  // Save a name using SharedPreferences (key-value storage).
  static Future<void> saveName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
  }

  // Load the saved name from SharedPreferences.
  static Future<String> getSavedName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nameKey) ?? '';
  }

  // Get file path inside the app's documents directory.
  static Future<File> _getNoteFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_noteFileName');
  }

  // Save a note to a local text file.
  static Future<void> saveNoteToFile(String note) async {
    final file = await _getNoteFile();
    await file.writeAsString(note);
  }

  // Read the saved note from the local text file.
  static Future<String> readNoteFromFile() async {
    try {
      final file = await _getNoteFile();
      if (await file.exists()) {
        return await file.readAsString();
      }
      return '';
    } catch (_) {
      return '';
    }
  }
}
