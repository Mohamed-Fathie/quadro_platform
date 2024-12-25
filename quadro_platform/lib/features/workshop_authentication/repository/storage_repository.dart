import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageRepository {
  final storageRef = FirebaseStorage.instance.ref();

  // Function to upload image to Firebase Storage
  Future<String> uploadImageWithProgress({
    required XFile xFile,
    required String path,
    required Function(double) onProgressUpdate,
  }) async {
    // Reference to the specific file path in Firebase Storage
    final fileRef = storageRef.child(path);

    // Start the upload task
    final uploadTask = fileRef.putFile(File(xFile.path));

    // Listen to the upload progress
    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      double progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
      onProgressUpdate(progress); // Callback to update progress
    });

    // Wait for the upload to complete and return the download URL
    final snapshot = await uploadTask.whenComplete(() {});
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
