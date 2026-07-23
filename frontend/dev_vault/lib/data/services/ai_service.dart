import 'dart:convert';

import 'package:dev_vault/data/constant_urls.dart';
import 'package:dev_vault/data/services/local_storage_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/chat_message_model.dart';

class AiService {
  final List<ChatMessageModel> messages = [];
  static final Dio dio = Dio();
  bool isLoading = false;
  static Map<String, dynamic> _getAuthHeaders() {
    final token = LocalStorageService.getToken();
    return {'Authorization': token != null ? 'Bearer $token' : ''};
  }


  bool isInitialLoading = false; // Loading chat history
  /// UI Refresh Callback
  VoidCallback? onUpdate;

  void init(VoidCallback callback) {
    onUpdate = callback;
  }

  void _refresh() {
    if (onUpdate != null) {
      onUpdate!();
    }
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    print("==================================");
    print("User Message : $message");

    messages.add(
      ChatMessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: message,
        isUser: true,
        createdAt: DateTime.now(),
      ),
    );

    isLoading = true;
    _refresh();

    try {
      final aiResponse = await _callApi(message);

      print("AI Response : $aiResponse");

      messages.add(
        ChatMessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          message: aiResponse,
          isUser: false,
          createdAt: DateTime.now(),
        ),
      );
    } catch (e) {
      print("Send Message Error : $e");

      messages.add(
        ChatMessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          message: "Something went wrong.\nPlease try again.",
          isUser: false,
          createdAt: DateTime.now(),
        ),
      );
    }

    isLoading = false;
    _refresh();
  }

  Future<String> _callApi(String message) async {
    print("========== AI API REQUEST ==========");
    print("URL: $sendAiChatMsgUrl");
    print("Message: $message");

    try {
      final response = await dio.post(
        sendAiChatMsgUrl,
        data: {"message": message},
        options: Options(headers: _getAuthHeaders()),
      );

      print("========== AI API RESPONSE ==========");
      print("Status Code: ${response.statusCode}");
      print("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        final json = response.data;

        final answer = json["answer"]["answer"] ?? "";

        print("AI Answer: $answer");

        return answer;
      }

      throw Exception("Unexpected Status Code: ${response.statusCode}");
    } on DioException catch (e) {
      print("========== DIO ERROR ==========");
      print("Message: ${e.message}");
      print("Status Code: ${e.response?.statusCode}");
      print("Response: ${e.response?.data}");

      rethrow;
    } catch (e, stackTrace) {
      print("========== UNKNOWN ERROR ==========");
      print(e);
      print(stackTrace);

      rethrow;
    }
  }

  void clearChat() {
    messages.clear();
    _refresh();
  }

  Future<void> loadMessages() async {
    isLoading = true;
    _refresh();

    try {
      print("========== LOAD CHAT ==========");
      print("URL: $getAiChatMsgUrl");

      final response = await dio.get(
        getAiChatMsgUrl,
        options: Options(headers: _getAuthHeaders()),
      );

      print("========== CHAT RESPONSE ==========");
      print(response.data);

      if (response.statusCode == 201) {
        print("====== 01 ");
        messages.clear();
        print("====== 02 ");
        final List<dynamic> data = response.data["data"];
        print("====== 03 ");
        messages.addAll(
          data.map(
            (e) => ChatMessageModel(
              id: e["messageId"],
              message: e["message"],
              isUser: e["role"] == "user",
              createdAt: DateTime.parse(e["createdAt"]),
            ),
          ),
        );

        print("Loaded ${messages.length} messages");
      }
    } on DioException catch (e) {
      print("========== LOAD ERROR ==========");
      print(e.response?.data);
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      _refresh();
    }
  }
}
