library flutter_emoji_selector;

import 'package:flutter/material.dart';
import 'package:emojis/emoji.dart';

export 'package:emojis/emoji.dart'; // to use Emoji utilities

class EmojiSelector extends StatefulWidget {
  const EmojiSelector({super.key, this.onEmojiSelected});
  final void Function(Emoji)? onEmojiSelected;
  @override
  State<EmojiSelector> createState() => _EmojiSelectorState();
}

class _EmojiSelectorState extends State<EmojiSelector>
    with TickerProviderStateMixin {
  final Map<EmojiGroup, List<Emoji>> _emojiGroupMap = {};
  final List<Emoji> _emojis = Emoji.all();
  late TabController tabController;

  @override
  void initState() {
    initParser();
    tabController = TabController(
      length: _emojiGroupMap.keys.length,
      vsync: this,
    );
    super.initState();
  }

  Future<void> initParser() async {
    setState(() {
      for (var element in _emojis) {
        _emojiGroupMap[element.emojiGroup] ??= [];
        _emojiGroupMap[element.emojiGroup]!.add(element);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var pages = [
      for (var group in _emojiGroupMap.keys)
        EmojiGroupGrid(
          emojis: _emojiGroupMap[group]!,
          onEmojiSelected: widget.onEmojiSelected,
        ),
    ];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TabBar(
            isScrollable: true,
            controller: tabController,
            onTap: (value) {
              tabController.animateTo(value);
            },
            tabs: [
              for (var group in _emojiGroupMap.keys)
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Theme(
                        data: Theme.of(context)
                            .copyWith(primaryColor: Colors.black),
                        child: group.icon,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        group.value,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: pages,
          ),
        ),
      ],
    );
  }
}

class EmojiGroupGrid extends StatelessWidget {
  const EmojiGroupGrid({
    super.key,
    required List<Emoji> emojis,
    this.onEmojiSelected,
  }) : _emojis = emojis;
  final Function(Emoji)? onEmojiSelected;
  final List<Emoji> _emojis;

  @override
  Widget build(BuildContext context) {
    return GridView.extent(
      maxCrossAxisExtent: 50,
      children: [
        for (var item in _emojis)
          TextButton(
            child: Text(
              item.char,
              style: const TextStyle(fontSize: 32),
            ),
            onPressed: () => onEmojiSelected?.call(item),
          ),
      ],
    );
  }
}

extension EmojiGroupExtension on EmojiGroup {
  String get value => name.camelCaseToSpaces;

  Widget get icon {
    switch (this) {
      case EmojiGroup.smileysEmotion:
        return const Icon(Icons.sentiment_very_satisfied);
      case EmojiGroup.activities:
        return const Icon(Icons.directions_run);
      case EmojiGroup.peopleBody:
        return const Icon(Icons.people);
      case EmojiGroup.objects:
        return const Icon(Icons.local_florist);
      case EmojiGroup.travelPlaces:
        return const Icon(Icons.airplanemode_active);
      case EmojiGroup.component:
        return const Icon(Icons.apps);
      case EmojiGroup.animalsNature:
        return const Icon(Icons.pets);
      case EmojiGroup.foodDrink:
        return const Icon(Icons.fastfood);
      case EmojiGroup.symbols:
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
          ),
          child: const Icon(Icons.numbers_rounded),
        );
      case EmojiGroup.flags:
        return const Icon(Icons.flag);
    }
  }
}

extension StringExtensions on String {
  String get camelCaseToSpaces =>
      replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}')
          .capitalizeWordsInitial;
  String get capitalizeWordsInitial => replaceAllMapped(
        RegExp(r'(\w)(\w+)'),
        (match) => '${match.group(1)!.toUpperCase()}${match.group(2)}',
      );
}
