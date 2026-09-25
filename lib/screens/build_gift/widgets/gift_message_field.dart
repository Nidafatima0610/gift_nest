import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Text field for adding an optional personal message to the custom gift box.
class GiftMessageField extends StatefulWidget {
  final String? initialMessage;
  final ValueChanged<String> onChanged;

  const GiftMessageField({
    super.key,
    this.initialMessage,
    required this.onChanged,
  });

  @override
  State<GiftMessageField> createState() => _GiftMessageFieldState();
}

class _GiftMessageFieldState extends State<GiftMessageField> {
  late TextEditingController _controller;
  static const int _maxLength = 200;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialMessage ?? '');
  }

  @override
  void didUpdateWidget(covariant GiftMessageField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialMessage != oldWidget.initialMessage &&
        widget.initialMessage != _controller.text) {
      _controller.text = widget.initialMessage ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Add a personal message 💌',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.mainText,
                ),
              ),
            ),
            const SizedBox(width: 8),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _controller,
              builder: (context, value, _) {
                final currentLength = value.text.length;
                return Text(
                  '$currentLength/$_maxLength',
                  key: const Key('message_character_count'),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: currentLength >= _maxLength
                        ? AppColors.error
                        : AppColors.secondaryText,
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Handwritten on our signature boutique gift card. (Optional)',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.secondaryText,
          ),
        ),
        const SizedBox(height: AppDimensions.sm),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: Border.all(color: AppColors.border),
          ),
          child: TextField(
            key: const Key('gift_message_input'),
            controller: _controller,
            maxLength: _maxLength,
            maxLines: 4,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.mainText,
              height: 1.4,
            ),
            decoration: const InputDecoration(
              hintText: 'Write something special...',
              hintStyle: TextStyle(
                color: AppColors.secondaryText,
                fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(AppDimensions.md),
              counterText: '', // Hide default counter; we show customized one above
            ),
            onChanged: widget.onChanged,
          ),
        ),
      ],
    );
  }
}
