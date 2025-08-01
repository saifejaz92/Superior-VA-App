import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:superior_va_app/utils/custom_btn.dart';

class PostGenerateScreen extends StatefulWidget {
  const PostGenerateScreen({super.key});

  @override
  State<PostGenerateScreen> createState() => _PostGenerateScreenState();
}

class _PostGenerateScreenState extends State<PostGenerateScreen> {
  File? _uploadedImage;
  String? _selectedBackground;
  final TextEditingController _textController = TextEditingController();

  final List<String> backgrounds = [
    'assets/img/bg1.jpg',
    'assets/img/bg2.jpg',
    'assets/img/bg3.jpg',
    'assets/img/bg4.jpg',
    'assets/img/bg5.jpg',
    'assets/img/bg6.jpg',
    'assets/img/bg7.jpg',
    'assets/img/bg8.jpg',
  ];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _uploadedImage = File(pickedFile.path);
      });
    }
  }

  Future<Uint8List> _removeBackground(File imageFile) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.remove.bg/v1.0/removebg'),
    );
    request.headers['X-Api-Key'] = 'GeEYsRn7dpwqQEMA8Sg24uRA';
    request.files.add(
      await http.MultipartFile.fromPath('image_file', imageFile.path),
    );
    request.fields['size'] = 'auto';

    final response = await request.send();

    if (response.statusCode != 200) {
      final resBody = await response.stream.bytesToString();
      throw Exception('Remove.bg API error: $resBody');
    }

    return await response.stream.toBytes();
  }

  Future<File> _compositeImages(
    Uint8List foregroundBytes,
    String backgroundAsset,
  ) async {
    // Load background image
    final bgData = await DefaultAssetBundle.of(context).load(backgroundAsset);
    final bgImage = img.decodeImage(bgData.buffer.asUint8List())!;

    // Load foreground image (with transparent background)
    final fgImage = img.decodeImage(foregroundBytes)!;

    // Resize background to match foreground dimensions
    final resizedBg = img.copyResize(
      bgImage,
      width: fgImage.width,
      height: fgImage.height,
    );

    // Create a new image to draw on
    final combined = img.Image(width: fgImage.width, height: fgImage.height);

    // First draw the background
    img.compositeImage(combined, resizedBg, dstX: 0, dstY: 0);

    // Then draw the foreground on top
    img.compositeImage(combined, fgImage, dstX: 0, dstY: 0);

    // Encode to PNG
    final resultBytes = Uint8List.fromList(img.encodePng(combined));

    // Save to temporary file
    final dir = await getTemporaryDirectory();
    final resultFile = File(
      '${dir.path}/final_${DateTime.now().millisecondsSinceEpoch}.png',
    );
    await resultFile.writeAsBytes(resultBytes);

    return resultFile;
  }

  void _generatePost() async {
    if (_uploadedImage == null || _selectedBackground == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload an image and select a background'),
        ),
      );
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Step 1: Remove background
      final noBgBytes = await _removeBackground(_uploadedImage!);

      // Step 2: Composite with selected background
      final resultFile = await _compositeImages(
        noBgBytes,
        _selectedBackground!,
      );

      // Hide loading
      Navigator.pop(context);

      // Show result
      if (!mounted) return;
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('Generated Image'),
              content: Image.file(resultFile),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
                TextButton(
                  onPressed: () async {
                    // Save to gallery would go here
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
      );
    } catch (e) {
      Navigator.pop(context);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            // Left: Backgrounds
            Container(
              width: 120,
              padding: const EdgeInsets.all(10),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Background',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: backgrounds.length,
                      itemBuilder: (context, index) {
                        final bg = backgrounds[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedBackground = bg;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    _selectedBackground == bg
                                        ? Colors.purple
                                        : Colors.transparent,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SizedBox(
                              height: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  bg,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Right: Upload, Text, Button
            Expanded(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Superior VA',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF861C85),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Post Generate',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade100,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child:
                            _uploadedImage != null
                                ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    _uploadedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                                : const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.camera_alt,
                                        size: 40,
                                        color: Colors.black54,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Upload Image',
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Text',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: GradientButton(
                        text: "Generate",
                        onPressed: _generatePost,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
