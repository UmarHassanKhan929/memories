import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memoryplaces/providers/great_places.dart';
import 'package:memoryplaces/widgets/location_input.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:provider/provider.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = '/add-place';

  const AddPlaceScreen({Key? key}) : super(key: key);
  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();
  final _descripController = TextEditingController();
  File? _storedImage;
  File? _pickedimage;

  Future<void> _takePicture() async {
    final ImagePicker _imagePicker = ImagePicker();
    final imageFile =
        await _imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);
    if (imageFile == null) {
      return;
    }
    setState(() {
      _storedImage = File(imageFile.path);
    });

    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage =
        await File(imageFile.path).copy('${appDir.path}/$fileName');

    _pickedimage = savedImage;
  }

  void _savePlace() {
    if (_titleController.text.isEmpty ||
        _descripController.text.isEmpty ||
        _storedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a title or  description'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    Provider.of<GreatPlaces>(context, listen: false).addPlace(
        _titleController.text, _descripController.text, _pickedimage!);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new Place'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: 150,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: _storedImage != null
                                ? Image.file(
                                    _storedImage!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  )
                                : const Text("no img"),
                          ),
                        ),
                        Expanded(
                          child: TextButton.icon(
                            onPressed: (() {
                              _takePicture();
                            }),
                            icon: const Icon(Icons.camera_alt),
                            label: const Text(
                              'Take picture',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const LocationInput(),
                      ],
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Title',
                      ),
                      controller: _titleController,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      controller: _descripController,
                      maxLines: 8,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(5),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Add Place'),
              onPressed: _savePlace,
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(10),
                  textStyle: const TextStyle(fontSize: 20)),
            ),
          ),
        ],
      ),
    );
  }
}
