library flutter_emoji_selector;

import 'package:flutter/material.dart';
import 'package:emojis/emoji.dart';
import 'package:flutter_portal/flutter_portal.dart';
export 'package:emojis/emoji.dart'; // to use Emoji utilities

class EmojiSelector extends StatefulWidget {
  const EmojiSelector(
      {super.key, this.onEmojiSelected, this.showEmojiGroupName = false});
  final void Function(Emoji)? onEmojiSelected;
  final bool showEmojiGroupName;

  @override
  State<EmojiSelector> createState() => _EmojiSelectorState();
}

class _EmojiSelectorState extends State<EmojiSelector>
    with TickerProviderStateMixin {
  final Map<EmojiGroup, List<Emoji>> _emojiGroupMap = {};
  final List<Emoji> _emojis = Emoji.all();
  late TabController tabController;

  final _searchController = TextEditingController();

  List<Emoji> searchResults = [];

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
    return Portal(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              autofocus: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                labelText: 'Search Emoji',
                hintText: 'Search Emoji',
                fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                filled: true,
              ),
              controller: _searchController,
              onChanged: (val) {
                setState(() {
                  searchResults = _emojis.where((element) {
                    var val2 = val.toLowerCase();
                    return element.char.contains(val) ||
                        element.name.toLowerCase().contains(val2) ||
                        element.shortName.toLowerCase().contains(val2) ||
                        element.emojiGroup.name.toLowerCase().contains(val2);
                  }).toList();
                });
              },
            ),
          ),
          if (_searchController.text.isNotEmpty)
            Expanded(
              child: EmojiGroupGrid(
                emojis: searchResults,
                onEmojiSelected: widget.onEmojiSelected,
              ),
            )
          else ...[
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
                          if (widget.showEmojiGroupName) ...[
                            const SizedBox(width: 8),
                            Text(
                              group.value,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ],
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Builder(builder: (context) {
                return TabBarView(
                  controller: tabController,
                  children: [
                    for (var group in _emojiGroupMap.keys)
                      EmojiGroupGrid(
                        emojis: _emojiGroupMap[group]!,
                        onEmojiSelected: widget.onEmojiSelected,
                      ),
                  ],
                );
              }),
            ),
          ]
        ],
      ),
    );
  }
}

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
            backup: Aligned(
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
