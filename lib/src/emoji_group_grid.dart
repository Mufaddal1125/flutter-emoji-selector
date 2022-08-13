import 'package:emojis/emoji.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji_selector/src/emoji_widget.dart';

class EmojiGroupGrid extends StatefulWidget {
  const EmojiGroupGrid({
    super.key,
    required List<Emoji> emojis,
    this.onEmojiSelected,
  }) : _emojis = emojis;

  /// Callback for emoji selection
  final Function(Emoji)? onEmojiSelected;

  /// list of emojis for the group
  final List<Emoji> _emojis;

  @override
  State<EmojiGroupGrid> createState() => _EmojiGroupGridState();
}

class _EmojiGroupGridState extends State<EmojiGroupGrid> {
  // emojis for grid
  final List<Emoji> _emojis = [];
  // emojis with different skins
  // key: normal emoji
  // value: List of skin variants for emoji
  final Map<Emoji, List<Emoji>> _modifiableEmojiMap = {};

  /// same as [_modifiableEmojiMap] but the keys are emoji chars
  final Map<String, List<Emoji>> _modifiableEmojiCharMap = {};

  @override
  void initState() {
    populateEmojis();
    super.initState();
  }

  void populateEmojis() {
    for (var emoji in widget._emojis) {
      if (emoji.modifiable) {
        var stabilize = Emoji.stabilize(emoji.char, gender: false);
        var noSkin = Emoji.byChar(stabilize);
        if (noSkin != null) {
          _modifiableEmojiMap[noSkin] ??= [];
          _modifiableEmojiMap[noSkin]!.add(emoji);
        } else {
          var split = emoji.name.split(':');
          var emojiName = split.first;
          _modifiableEmojiCharMap[emojiName] ??= [];
          _modifiableEmojiCharMap[emojiName]!.add(emoji);
        }
        continue;
      }
      _emojis.add(emoji);
    }
    for (var emoji in widget._emojis) {
      if (Emoji.modify(emoji.char, fitzpatrick.light) != emoji.char) {
        var split = emoji.name.split(':');
        var emojiName = split.first;
        if (_modifiableEmojiCharMap.containsKey(emojiName)) {
          _modifiableEmojiMap[emoji] = _modifiableEmojiCharMap[emojiName]!;
        }
      }
    }
    _emojis.addAll(_modifiableEmojiMap.keys);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.extent(
      maxCrossAxisExtent: 50,
      children: [
        for (var item in _emojis)
          EmojiWidget(
            item: item,
            onEmojiSelected: widget.onEmojiSelected,
            modifiablEmojis: _modifiableEmojiMap[item],
          ),
      ],
    );
  }
}
