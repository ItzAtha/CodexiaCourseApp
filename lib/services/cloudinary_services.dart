import 'dart:io';

import 'package:cloudinary_api/uploader/cloudinary_uploader.dart';
import 'package:cloudinary_api/src/request/model/uploader_params.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:cloudinary_url_gen/config/cloud_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CloudinaryServices {
  final String _cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? "";
  final String _apiKey = dotenv.env['CLOUDINARY_API_KEY'] ?? "";
  final String _apiSecret = dotenv.env['CLOUDINARY_API_SECRET'] ?? "";
  final String _uploadPreset = "codexia_user_avatar";

  late Cloudinary cloudinary;

  CloudinaryServices() {
    cloudinary = Cloudinary.fromCloudName(cloudName: _cloudName);
    cloudinary.config.cloudConfig = CloudConfig(_cloudName, _apiKey, _apiSecret);
  }

  Future<(String?, String?)?> uploadImage(String path) async {
    final file = File(path);

    try {
      final response = await cloudinary.uploader().upload(
        file,
        params: UploadParams(folder: "codexia_user_avatar", uploadPreset: _uploadPreset),
      );

      return (response?.data?.publicId, response?.data?.url);
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  Future<bool> deleteImage(String publicId) async {
    try {
      final response = await cloudinary.uploader().destroy(
        DestroyParams(publicId: publicId, invalidate: true),
      );

      if (response.responseCode == 200) {
        return true;
      }
    } catch (e) {
      print("Error deleting image: $e");
    }
    return false;
  }
}
