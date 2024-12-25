import 'package:image_picker/image_picker.dart';

abstract class ImagePickerService {
  Future<XFile?> pickImage();
}

class DefaultImagePickerService implements ImagePickerService {
  final ImagePicker _imagePicker;

  DefaultImagePickerService({ImagePicker? imagePicker})
      : _imagePicker = imagePicker ?? ImagePicker();

  @override
  Future<XFile?> pickImage() {
    return _imagePicker.pickImage(source: ImageSource.gallery);
  }
}
