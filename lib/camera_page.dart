import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:test_drive/foodcaloriedetail_page.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  List<Map<String, dynamic>> _foodData = [];
  File _image = File('assets/imagenotfound.png');

  // Future<FoodInfo?> fetchFoodInfo() async {
  //   try {
  //     final response =
  //         await http.get(Uri.parse('http://10.0.2.2:5000/identify-food'));
  //     if (response.statusCode == 200) {
  //       final parsedJson = jsonDecode(response.body);
  //       final foodDataList = parsedJson['food_data'] as List;
  //       if (foodDataList.isNotEmpty) {
  //         final foodInfo = foodDataList[0];
  //         return FoodInfo(
  //           name: foodInfo['name'] as String,
  //           calories: foodInfo['calories'] as int,
  //           carbs: foodInfo['carbs'] as int,
  //           fat: foodInfo['fat'] as int,
  //           protein: foodInfo['protein'] as int,
  //         );
  //       } else {
  //         print('No food information found in response.');
  //         return null;
  //       }
  //     } else {
  //       print(
  //           'Failed to fetch food information (status code: ${response.statusCode})');
  //       return null;
  //     }
  //   } catch (error) {
  //     print('Error fetching food information: $error');
  //     return null;
  //   }
  // }

  Future<void> _takePhoto() async {
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.camera);

      setState(() {
        if (pickedImage != null) {
          _image = File(pickedImage.path);
          _sendImageToServer(_image);
        } else {
          print('No image selected.');
        }
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        _image = File('');
      });
    }
  }

  Future<void> _sendImageToServer(File image) async {
    final request = http.MultipartRequest(
        'POST', Uri.parse('http://10.0.2.2:5000/identify-food'));
    request.files.add(await http.MultipartFile.fromPath('image', image.path));
    final response = await request.send();
    if (response.statusCode == 200) {
      print('Image uploaded successfully');
      // Parse the response body
      final responseBody = await response.stream.bytesToString();
      final foodData = (jsonDecode(responseBody)['food_data'] as List)
          .map((item) => item as Map<String, dynamic>)
          .toList();
      // Now you can use foodData in your UI
      setState(() {
        _foodData = foodData;
      });
    } else {
      print('Image upload failed');
    }
  }

  Future<void> confirmPhoto() async {
    if (_image != null) {
      await _sendImageToServer(_image);
      print(_foodData);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FoodCalorieDetailPage(foodData: _foodData),
        ),
      );
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null
                ? Image.file(
                    _image,
                    height: 400,
                  )
                : const Text(
                    'No photo',
                    style: TextStyle(fontSize: 20),
                  ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _takePhoto();
                  },
                  child: const Text('Take Photo'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    confirmPhoto();
                  },
                  child: const Text('Confirm Photo'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
