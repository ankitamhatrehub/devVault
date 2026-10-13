import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/chat_message_model.dart';
import '../../../data/services/ai_service.dart';

class AiChatState {
  const AiChatState({
    this.messages = const [],
    this.isLoading = false,
    this.isInitialLoading = false,
    this.error,
  });

  final List<ChatMessageModel> messages;
  final bool isLoading;
  final bool isInitialLoading;
  final String? error;

  AiChatState copyWith({
    List<ChatMessageModel>? messages,
    bool? isLoading,
    bool? isInitialLoading,
    String? error,
  }) {
    return AiChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      error: error ?? this.error,
    );
  }
}

class AiChatCubit extends Cubit<AiChatState> {
  AiChatCubit() : super(const AiChatState()) {
    _service.init(() {
      emit(
        state.copyWith(
          messages: List<ChatMessageModel>.from(_service.messages),
          isLoading: _service.isLoading,
          isInitialLoading: _service.isInitialLoading,
        ),
      );
    });
  }

  final AiService _service = AiService();

  Future<void> loadMessages() async {
    emit(state.copyWith(isInitialLoading: true, error: null));

    try {
      await _service.loadMessages();
      emit(
        state.copyWith(
          messages: List<ChatMessageModel>.from(_service.messages),
          isLoading: _service.isLoading,
          isInitialLoading: _service.isInitialLoading,
          error: null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isInitialLoading: false, error: e.toString()));
    }
  }

  Future<void> sendMessage(String message) async {
    final trimmedMessage = message.trim();
    if (trimmedMessage.isEmpty) return;

    final newUserMessage = ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: trimmedMessage,
      isUser: true,
      createdAt: DateTime.now(),
    );

    final updatedMessages = [...state.messages, newUserMessage];
    emit(
      state.copyWith(messages: updatedMessages, isLoading: true, error: null),
    );

    try {
      await _service.sendMessage(trimmedMessage);
      emit(
        state.copyWith(
          messages: List<ChatMessageModel>.from(_service.messages),
          isLoading: _service.isLoading,
          isInitialLoading: _service.isInitialLoading,
          error: null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
