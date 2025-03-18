import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class AudioService {
  static final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  static bool _isRecording = false;

  static Future<void> startRecording() async {
    if (await _requestPermission()) {
      try {
        await _recorder.startRecorder(
          toFile: 'audio_record.wav',
          codec: Codec.pcm16WAV,
        );
        _isRecording = true;
        print('Recording started');
      } catch (e) {
        print('Error starting recording: $e');
      }
    } else {
      print('Microphone permission denied');
    }
  }

  static Future<void> stopRecording() async {
    if (_isRecording) {
      try {
        await _recorder.stopRecorder();
        _isRecording = false;
        print('Recording stopped');

        // Upload the WAV file
        await _uploadFile('audio_record.wav');
      } catch (e) {
        print('Error stopping recording: $e');
      }
    }
  }

  static Future<bool> _requestPermission() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      print('Microphone permission granted');
    } else {
      print('Microphone permission not granted');
    }
    return status.isGranted;
  }

  static Future<void> _uploadFile(String filePath) async {
    final uri = Uri.parse('http://localhost:3000/api/upload'); // Replace with your server URL
    final request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', filePath));

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        print('File uploaded successfully');
      } else {
        print('File upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading file: $e');
    }
  }
}