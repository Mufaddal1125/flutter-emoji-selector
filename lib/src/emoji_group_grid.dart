import 'package:emojis/emoji.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji_selector/src/emoji_widget.dart';
import 'package:flutter_emoji_selector/src/extensions.dart';

class EmojiGroupGrid extends StatefulWidget {
  const EmojiGroupGrid({
    super.key,
    required List<Emoji> emojis,
    this.onEmojiSelected,
    this.emojiGroup,
  }) : _emojis = emojis;

  final EmojiGroup? emojiGroup;

  /// Callback for emoji selection
  final Function(Emoji)? onEmojiSelected;

  /// list of emojis for the group
  final List<Emoji> _emojis;

  @override
  State<EmojiGroupGrid> createState() => _EmojiGroupGridState();
}

class _EmojiGroupGridState extends State<EmojiGroupGrid> {
  // emojis for grid
  List<Emoji> _emojis = [];
  // emojis with different skins
  // key: normal emoji
  // value: List of skin variants for emoji
  Map<String, List<Emoji>> _modifiableEmojiMap = {};

  late Future<void> emojiFuture;

  @override
  void initState() {
    emojiFuture = popuplateEmojis();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: emojiFuture,
      builder: (context, data) {
        if (data.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        return GridView.extent(
          maxCrossAxisExtent: 50,
          children: [
            for (var item in _emojis)
              Builder(builder: (context) {
                var modifiables = _modifiableEmojiMap[item.char];
                return EmojiWidget(
                  item: item,
                  onEmojiSelected: widget.onEmojiSelected,
                  modifiablEmojis: modifiables,
                );
              }),
          ],
        );
      },
    );
  }

  Future<void> popuplateEmojis() async {
    var emojiGroup = widget.emojiGroup;
    if (emojiGroup?.index != null) {
      try {
        var group = EmojiGroup.values[widget.emojiGroup!.index];
        if (_ModifiableGroupCache.cache.containsKey(group.index)) {
          var data = _ModifiableGroupCache.cache[emojiGroup!.index]!;
          _emojis = data['_emojis'];
          _modifiableEmojiMap = data['_modifiableEmojiMap'];
          return;
        }
      } catch (e) {
        debugPrint('error getting cache $e');
      }
    }
    var data = await compute<List<Map<String, dynamic>>, Map<String, dynamic>>(
        (message) => calculateModifiableEmojis(
            message.map((e) => EmojiExtension.fromJson(e)).toList()),
        widget._emojis.map((e) => e.toJson()).toList());
    _emojis = data['_emojis'];
    _modifiableEmojiMap = data['_modifiableEmojiMap'];
    if (emojiGroup != null) {
      _ModifiableGroupCache.cache[emojiGroup.index] = data;
    }
  }
}

class _ModifiableGroupCache {
  static Map<int, Map<String, dynamic>> cache = {};
}

Map<String, dynamic> calculateModifiableEmojis(List<Emoji> emojis) {
  List<Emoji> evaluatedEmojis = [];
  final Map<String, List<Emoji>> modifiableEmojiMap = {};
  final Map<String, List<Emoji>> modifiableEmojiNameMap = {};
  for (var emoji in emojis) {
    if (emoji.modifiable) {
      var stabilize = Emoji.stabilize(emoji.char, gender: false);
      var noSkin = Emoji.byChar(stabilize);
      if (noSkin != null) {
        modifiableEmojiMap[noSkin.char] ??= [];
        modifiableEmojiMap[noSkin.char]!.add(emoji);
        continue;
      } else {
        var split = emoji.name.split(':');
        var emojiName = split.first;
        modifiableEmojiNameMap[emojiName] ??= [];
        modifiableEmojiNameMap[emojiName]!.add(emoji);
        continue;
      }
    }
    evaluatedEmojis.add(emoji);
  }
  for (var emoji in evaluatedEmojis) {
    if (Emoji.modify(emoji.char, fitzpatrick.light) != emoji.char) {
      var split = emoji.name.split(':');
      var emojiName = split.first;
      if (modifiableEmojiNameMap.containsKey(emojiName)) {
        modifiableEmojiMap[emoji.char] = modifiableEmojiNameMap[emojiName]!;
      }
    }
  }
  for (var element in modifiableEmojiMap.keys) {
    var emoji = Emoji.byChar(element);
    if (!evaluatedEmojis.contains(emoji)) evaluatedEmojis.add(emoji!);
  }
  var data = {
    '_emojis': evaluatedEmojis,
    '_modifiableEmojiMap': modifiableEmojiMap,
  };
  return data;
}
