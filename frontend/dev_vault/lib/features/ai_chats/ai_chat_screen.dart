import 'package:dev_vault/data/services/ai_service.dart';
import 'package:dev_vault/features/ai_chats/widgets/message_bubble.dart';
import 'package:dev_vault/features/ai_chats/widgets/message_input.dart';
import 'package:dev_vault/features/ai_chats/widgets/typing_indicator.dart';
import 'package:flutter/material.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final AiService _service = AiService();

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _service.init(() {
      if (mounted) {
        setState(() {});
        _scrollToBottom();
      }
    });
    _service.loadMessages();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'DevVault AI',
          style:
              theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ) ??
              const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _service.isInitialLoading
                ? const Center(child: CircularProgressIndicator())
                : _service.messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.smart_toy_outlined,
                          size: 70,
                          color: colorScheme.primary.withValues(alpha: 0.75),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Start a conversation',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Ask anything to DevVault AI',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(top: 16),
                    itemCount: _service.messages.length,
                    reverse: true,
                    itemBuilder: (_, index) {
                      return MessageBubble(message: _service.messages[index]);
                    },
                  ),
          ),
          if (_service.isLoading) const TypingIndicator(),
          MessageInput(
            isLoading: _service.isLoading,
            onSend: (message) async {
              print('send ai messages');
              await _service.sendMessage(message);
            },
          ),
        ],
      ),
    );
  }
}
