
import 'package:emojis/emoji.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji_selector/src/emoji_widget.dart';

class EmojiGroupGrid extends StatefulWidget {
  const EmojiGroupGrid({
    super.key,
    required List<Emoji> emojis,
    this.onEmojiSelected,
  }) : _emojis = emojis;
  final Function(Emoji)? onEmojiSelected;
  final List<Emoji> _emojis;

  @override
  State<EmojiGroupGrid> createState() => _EmojiGroupGridState();
}

class _EmojiGroupGridState extends State<EmojiGroupGrid> {
  final List<Emoji> _emojis = [];
  final Map<Emoji, List<Emoji>> _modifiableEmojiMap = {};
  final Map<String, List<Emoji>> l = {};

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
          l[emojiName] ??= [];
          l[emojiName]!.add(emoji);
        }
        continue;
      }
      _emojis.add(emoji);
    }
    for (var emoji in widget._emojis) {
      if (Emoji.modify(emoji.char, fitzpatrick.light) != emoji.char) {
        var split = emoji.name.split(':');
        var emojiName = split.first;
        if (l.containsKey(emojiName)) {
          _modifiableEmojiMap[emoji] = l[emojiName]!;
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
