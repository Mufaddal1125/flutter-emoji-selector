import 'package:emojis/emoji.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji_selector/src/emoji_group_grid.dart';
import 'package:flutter_emoji_selector/src/extensions.dart';
import 'package:flutter_portal/flutter_portal.dart';

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
