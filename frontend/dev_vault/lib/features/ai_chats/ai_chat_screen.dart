import 'package:dev_vault/features/ai_chats/widgets/message_bubble.dart';
import 'package:dev_vault/features/ai_chats/widgets/message_input.dart';
import 'package:dev_vault/features/ai_chats/widgets/typing_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dev_vault/core/theme/app_theme.dart';
import 'package:dev_vault/core/widgets/widgets.dart';
import 'cubit/ai_chat_cubit.dart';

class AiChatScreen extends StatelessWidget {
  const AiChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AiChatCubit()..loadMessages(),
      child: const _AiChatView(),
    );
  }
}

class _AiChatView extends StatefulWidget {
  const _AiChatView();

  @override
  State<_AiChatView> createState() => _AiChatViewState();
}

class _AiChatViewState extends State<_AiChatView> {
  final ScrollController _scrollController = ScrollController();

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

    return BlocConsumer<AiChatCubit, AiChatState>(
      listener: (context, state) {
        if (state.messages.isNotEmpty) {
          _scrollToBottom();
        }
      },
      builder: (context, state) {
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
                child: state.isInitialLoading
                    ? const _ChatLoadingSkeleton()
                    : state.messages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.smart_toy_outlined,
                              size: 70,
                              color: colorScheme.primary.withValues(
                                alpha: 0.75,
                              ),
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
                        itemCount: state.messages.length,
                        reverse: true,
                        itemBuilder: (_, index) {
                          return MessageBubble(message: state.messages[index]);
                        },
                      ),
              ),
              if (state.isLoading) const TypingIndicator(),
              MessageInput(
                isLoading: state.isLoading,
                onSend: (message) {
                  context.read<AiChatCubit>().sendMessage(message);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ChatLoadingSkeleton extends StatelessWidget {
  const _ChatLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHighest;

    Widget message({required bool alignRight, required double width}) {
      return Align(
        alignment: alignRight ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: width,
          height: 64,
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
        ),
      );
    }

    return ShimmerEffect(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          message(alignRight: false, width: 230),
          message(alignRight: true, width: 190),
          message(alignRight: false, width: 270),
        ],
      ),
    );
  }
}
