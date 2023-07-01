import 'package:emojis/emoji.dart';
import 'package:flutter/material.dart';

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
  final _popupKey = GlobalKey<PopupMenuButtonState>();

  @override
  Widget build(BuildContext context) {
    return _popupMenuWrapper(
      child: Center(
        child: InkWell(
          onTap: () => widget.onEmojiSelected?.call(widget.item),
          onDoubleTap: showSkinToneSelector,
          onLongPress: showSkinToneSelector,
          onSecondaryTap: showSkinToneSelector,
          child: Tooltip(
            message: widget.item.shortName.replaceAll('_', ' '),
            child: Text(
              widget.item.char,
              style: const TextStyle(fontSize: 30),
            ),
          ),
        ),
      ),
    );
  }

  void showSkinToneSelector() {
    if (widget.modifiablEmojis == null) return;
    _popupKey.currentState?.showButtonMenu();
  }

  void closeSkinToneSelector() {
    if (widget.modifiablEmojis == null) return;
    Navigator.of(context).pop();
  }

  Widget _buildSkinEmojis() {
    return PopupMenuTheme(
      data: const PopupMenuThemeData(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      child: Card(
        elevation: 0,
        child: Wrap(
          runAlignment: WrapAlignment.center,
          alignment: WrapAlignment.center,
          children: [
            for (var emoji in widget.modifiablEmojis!)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: InkWell(
                  onTap: () {
                    widget.onEmojiSelected?.call(emoji);
                    closeSkinToneSelector();
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
  }

  Widget _popupMenuWrapper({required Widget child}) {
    if (widget.modifiablEmojis == null) return child;
    return PopupMenuButton(
      key: _popupKey,
      enabled: false,
      itemBuilder: (context) =>
          [PopupMenuItem(enabled: false, child: _buildSkinEmojis())],
      child: child,
    );
  }
}
