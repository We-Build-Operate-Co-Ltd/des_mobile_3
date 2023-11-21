import 'package:image_picker/image_picker.dart';

class ImagePickerFrom {
  static Future<XFile?> camera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    return image;
  }

  static Future<XFile?> gallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image;
    // _upload();
  }

  // void _upload() async {
  //   if (_image == null) return;

  //   _uploadImage(_image!).then((res) {
  //     setState(() {
  //       _imageUrl = res;
  //     });
  //   }).catchError((err) {
  //     print(err);
  //   });
  // }
}
