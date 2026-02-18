import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class KeyManager {
  static const String _keyParams = 'lifetrack_master_key';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  encrypt.Key? _cachedKey;

  /// Retrieves the master encryption key, creating one if it doesn't exist.
  Future<encrypt.Key> getMasterKey() async {
    if (_cachedKey != null) return _cachedKey!;

    String? encodedKey = await _storage.read(key: _keyParams);
    
    if (encodedKey == null) {
      // Generate a new 32-byte key (256 bits)
      final key = encrypt.Key.fromSecureRandom(32);
      encodedKey = base64Url.encode(key.bytes);
      await _storage.write(key: _keyParams, value: encodedKey);
      _cachedKey = key;
    } else {
      _cachedKey = encrypt.Key(base64Url.decode(encodedKey));
    }
    
    return _cachedKey!;
  }
}
