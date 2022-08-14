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

  /// different skins of emoji
  final List<Emoji>? modifiablEmojis;

  /// emoji
  final Emoji item;

  /// Callback for emoji selection
  final Function(Emoji emoji)? onEmojiSelected;

  @override
  State<EmojiWidget> createState() => _EmojiWidgetState();
}

class _EmojiWidgetState extends State<EmojiWidget> {
  /// whether to show popup
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
        portalFollower: LayoutBuilder(builder: (context, constraints) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Card(
              elevation: 3,
              child: Wrap(
                runAlignment: WrapAlignment.center,
                alignment: WrapAlignment.center,
                children: [
                  for (var emoji in widget.modifiablEmojis!)
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: InkWell(
                        onTap: () {
                          widget.onEmojiSelected?.call(emoji);
                          setState(() => _pickingSkinTone = false);
                        },
                        child: Text(
                          emoji.char,
                          style: const TextStyle(fontSize: 30),
                        ),
                      ),
                    )
                ],
              ),
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
