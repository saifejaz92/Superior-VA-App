import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stability_image_generation/stability_image_generation.dart';
import 'package:superior_va_app/utils/custom_btn.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:permission_handler/permission_handler.dart';

class AiTextToImageGenerator extends StatefulWidget {
  const AiTextToImageGenerator({super.key});
  @override
  State<AiTextToImageGenerator> createState() => _AiTextToImageGeneratorState();
}

class _AiTextToImageGeneratorState extends State<AiTextToImageGenerator> {
  final TextEditingController _queryController = TextEditingController();
  final StabilityAI _ai = StabilityAI();
  final String apiKey = 'sk-4a9nongbJApr7Hhtbcq7os3v2AG49YO6uvTDw92L5Y3QmKb3';
  final ImageAIStyle imageAIStyle = ImageAIStyle.studioPhoto;
  bool isItems = false;
  Uint8List? _generatedImage; // Store the generated image

  Future<Uint8List> _generate(String query) async {
    Uint8List image = await _ai.generateImage(
      apiKey: apiKey,
      imageAIStyle: imageAIStyle,
      prompt: query,
    );
    setState(() {
      _generatedImage = image; // Store the generated image
    });
    return image;
  }

  // Function to save image to gallery
  Future<void> _saveImage() async {
    if (_generatedImage == null) return;

    // Request storage permission
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Storage permission denied')),
      );
      return;
    }

    try {
      // Get temporary directory
      final directory = await getTemporaryDirectory();
      // Create file
      final file = File(
        '${directory.path}/generated_image_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(_generatedImage!);

      // Save to gallery
      await SaverGallery.saveImage(
        Uint8List.fromList(_generatedImage!),
        quality: 100,
        fileName: 'generated_image_${DateTime.now().millisecondsSinceEpoch}',
        skipIfExists: true,
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Image saved to gallery!')));
    } catch (e) {
      if (kDebugMode) {
        print('Error saving image: $e');
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save image: $e')));
    }
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                const Text(
                  "Text to Image Generator",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      controller: _queryController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your prompt',
                        border: InputBorder.none,
                      ),
                      maxLines: 5,
                      minLines: 3,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                isItems
                    ? FutureBuilder<Uint8List>(
                      future: _generate(_queryController.text),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasData) {
                          return Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.memory(snapshot.data!),
                              ),
                              const SizedBox(height: 20),
                            ],
                          );
                        } else {
                          return Container();
                        }
                      },
                    )
                    : const Center(
                      child: Text(
                        'No image generated yet',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: GradientButton(
                          onPressed: () {
                            String query = _queryController.text;
                            if (query.isNotEmpty) {
                              setState(() {
                                isItems = true;
                              });
                            } else {
                              if (kDebugMode) {
                                print('Query is empty !!');
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter a prompt'),
                                ),
                              );
                            }
                          },
                          text: "Generate Image",
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Download button (visible only when image is generated)
                    if (_generatedImage != null)
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            onPressed: _saveImage,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.download, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'Download Image',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
