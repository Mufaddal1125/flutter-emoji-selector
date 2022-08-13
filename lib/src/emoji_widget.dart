import 'package:emojis/emoji.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';

class EmojiWidget extends StatefulWidget {
  const EmojiWidget({
    Key? key,
    required this.item,
    required this.onEmojiSelected,
    this.modifiablEmojis,
  }) : super(key: key);

  final List<Emoji>? modifiablEmojis;
  final Emoji item;
  final Function(Emoji emoji)? onEmojiSelected;

  @override
  State<EmojiWidget> createState() => _EmojiWidgetState();
}

class _EmojiWidgetState extends State<EmojiWidget> {
  bool _pickingSkinTone = false;

  @override
  Widget build(BuildContext context) {
    return PortalTarget(
      visible: _pickingSkinTone,
      portalFollower: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => setState(() => _pickingSkinTone = false),
      ),
      child: PortalTarget(
        anchor: const Aligned(
          follower: Alignment.bottomCenter,
          target: Alignment.topCenter,
          backup: Aligned(
            follower: Alignment.bottomLeft,
            target: Alignment.topRight,
            offset: Offset(-45.0, 0.0),
            backup: Aligned(
              offset: Offset(45.0, 0.0),
              follower: Alignment.bottomRight,
              target: Alignment.topLeft,
            ),
          ),
        ),
        visible: _pickingSkinTone,
        portalFollower: Builder(builder: (context) {
          return Card(
            elevation: 3,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var emoji in widget.modifiablEmojis!)
                  InkWell(
                    onTap: () {
                      widget.onEmojiSelected?.call(emoji);
                      setState(() => _pickingSkinTone = false);
                    },
                    child: Text(
                      emoji.char,
                      style: const TextStyle(fontSize: 30),
                    ),
                  )
              ],
            ),
          );
        }),
        child: Center(
          child: InkWell(
            onTap: () => widget.onEmojiSelected?.call(widget.item),
            onDoubleTap: () {
              if (widget.modifiablEmojis != null) {
                setState(() => _pickingSkinTone = !_pickingSkinTone);
              }
            },
            child: Tooltip(
              message: widget.item.shortName.replaceAll('_', ' '),
              child: Text(
                widget.item.char,
                style: const TextStyle(fontSize: 30),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
