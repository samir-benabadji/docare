import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class FirebaseStorageService {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> uploadUserImage(String uid, File file) async {
    try {
      String fileName = path.basename(file.path);
      SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');
      Reference ref = storage.ref().child('user_images/$uid/$fileName');
      UploadTask uploadTask = ref.putFile(file, metadata);
      await uploadTask;

      String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading user image to Firebase Storage: $e');
      return '';
    }
  }
}
