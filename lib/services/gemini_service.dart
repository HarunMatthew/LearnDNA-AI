import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static const String apiKey = "AIzaSyA-Za9xbDSRGwpstAQdAOYXY1CxtSUBs84";

  static final GenerativeModel model = GenerativeModel(
    model: 'gemini-2.0-flash',
    apiKey: apiKey,
  );

  static Future<String> askAI(String prompt) async {
    try {
      final response = await model.generateContent([
        Content.text(prompt),
      ]);

      return response.text ?? "No response from AI";
    } catch (e) {
      return "Error: $e";
    }
  }
}