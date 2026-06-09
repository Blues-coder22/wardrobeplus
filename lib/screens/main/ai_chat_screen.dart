import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      text: 'Hello! Ask me anything from your virtual layout collections. I can mix & match outfits, suggest what to wear today, or help you build your personal style!',
      isAi: true,
      timestamp: '9:00 AM',
    ),
    const _ChatMessage(
      text: 'What goes well with my Beige Trench coat?',
      isAi: false,
      timestamp: '9:01 AM',
    ),
    const _ChatMessage(
      text: '🔥 Great choice! Your Beige Trench Coat pairs beautifully with:\n\n• Black slim jeans + white tee (classic combo)\n• Khaki chinos + navy crewneck\n• Dark wash jeans + turtleneck sweater\n\nFor Nairobi\'s current cool weather, I\'d go with the black jeans + white tee combo — it\'s elevated but comfortable!',
      isAi: true,
      timestamp: '9:01 AM',
    ),
  ];

  final List<String> _suggestions = [
    '🌤️ Outfit for today\'s weather',
    '✨ Style a casual Friday look',
    '💼 Interview outfit ideas',
    '🎉 Event night outfit',
  ];

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(text: text, isAi: false, timestamp: _timeNow()));
      _isTyping = true;
    });
    _inputController.clear();
    _scrollToBottom();

    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _isTyping = false;
        _messages.add(_ChatMessage(
          text: 'Great question! Based on your wardrobe, I\'d suggest pairing that with your Khaki Chinos and a white linen shirt. Very Nairobi chic! Want me to log this as today\'s outfit?',
          isAi: true,
          timestamp: _timeNow(),
        ));
      });
      _scrollToBottom();
    }
  }

  String _timeNow() {
    final now = DateTime.now();
    return '${now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}';
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFF2A2A4A), width: 0.5)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [AppColors.primary, AppColors.gradientEnd]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('AI Stylist Chat Room', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                        Row(
                          children: [
                            CircleAvatar(radius: 4, backgroundColor: AppColors.success),
                            SizedBox(width: 6),
                            Text('Online · Powered by AI', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Messages
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: _messages.length + (_isTyping ? 1 : 0) + 1,
                itemBuilder: (context, i) {
                  if (i == 0) {
                    return _buildSuggestions();
                  }
                  if (i <= _messages.length) {
                    return _ChatBubble(message: _messages[i - 1]);
                  }
                  return _TypingIndicator();
                },
              ),
            ),

            // Input
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: Color(0xFF2A2A4A), width: 0.5)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Ask your fashion termina...',
                        hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
                        filled: true,
                        fillColor: AppColors.surfaceLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        prefixIcon: const Icon(Icons.auto_awesome_outlined, color: AppColors.textMuted, size: 18),
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _sendMessage(_inputController.text),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [AppColors.primary, AppColors.gradientEnd]),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestions() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Quick suggestions', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _suggestions.map((s) => GestureDetector(
              onTap: () => _sendMessage(s),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF2A2A4A)),
                ),
                child: Text(s, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final _ChatMessage message;
  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: message.isAi ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (message.isAi) ...[
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.primary, AppColors.gradientEnd]),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 14),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: message.isAi ? AppColors.cardBg : AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(message.isAi ? 4 : 16),
                  bottomRight: Radius.circular(message.isAi ? 16 : 4),
                ),
                border: message.isAi ? Border.all(color: const Color(0xFF2A2A4A)) : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message.timestamp,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatefulWidget {
  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.primary, AppColors.gradientEnd]),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 14),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
              ),
              border: Border.all(color: const Color(0xFF2A2A4A)),
            ),
            child: Row(
              children: List.generate(3, (i) {
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    return Container(
                      margin: EdgeInsets.only(right: i < 2 ? 4 : 0),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.3 + (_controller.value * 0.7)),
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String text, timestamp;
  final bool isAi;
  const _ChatMessage({required this.text, required this.timestamp, required this.isAi});
}
