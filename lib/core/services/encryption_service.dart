
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:lifetrack/core/services/key_manager.dart';

class EncryptionService {
  final KeyManager _keyManager;

  EncryptionService(this._keyManager);

  /// Encrypts a plain text string
  Future<String> encryptData(String plainText) async {
    final key = await _keyManager.getMasterKey();
    final iv = encrypt.IV.fromSecureRandom(16); // Generate random IV
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final encrypted = encrypter.encrypt(plainText, iv: iv);
    
    // Return combined IV and Encrypted details encoded
    // Format: iv_base64:encrypted_base64
    return '${iv.base64}:${encrypted.base64}';
  }

  /// Decrypts an encrypted string (iv:formatted)
  Future<String> decryptData(String encryptedText) async {
    final parts = encryptedText.split(':');
    if (parts.length != 2) {
      throw FormatException('Invalid encrypted data format');
    }

    final iv = encrypt.IV.fromBase64(parts[0]);
    final encrypted = encrypt.Encrypted.fromBase64(parts[1]);
    
    final key = await _keyManager.getMasterKey();
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    return encrypter.decrypt(encrypted, iv: iv);
  }
}
