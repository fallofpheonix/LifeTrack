import 'dart:convert';
import 'encryption_service.dart';

class SecureSerializer {
  final EncryptionService _encryptionService;

  SecureSerializer(this._encryptionService);

  /// Encrypts a Map to a secure string.
  Future<String> encryptMap(Map<String, dynamic> data) async {
    final String jsonString = jsonEncode(data);
    return _encryptionService.encryptData(jsonString);
  }

  /// Decrypts a secure string back to a Map.
  Future<Map<String, dynamic>> decryptMap(String encryptedData) async {
    final String jsonString = await _encryptionService.decryptData(encryptedData);
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  /// Encrypts a raw string.
  Future<String> encryptString(String value) async {
    return _encryptionService.encryptData(value);
  }

  /// Decrypts a raw string.
  Future<String> decryptString(String encryptedValue) async {
    return _encryptionService.decryptData(encryptedValue);
  }

  /// Encrypts a List to a secure string.
  Future<String> encryptList(List<dynamic> list) async {
    final String jsonString = jsonEncode(list);
    return _encryptionService.encryptData(jsonString);
  }

  /// Decrypts a secure string back to a List.
  Future<List<dynamic>> decryptList(String encryptedData) async {
    final String jsonString = await _encryptionService.decryptData(encryptedData);
    return jsonDecode(jsonString) as List<dynamic>;
  }
}
