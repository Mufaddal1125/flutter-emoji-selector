import 'package:easy_debounce/easy_debounce.dart';
import 'package:emojis/emoji.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji_selector/src/emoji_group_grid.dart';
import 'package:flutter_emoji_selector/src/extensions.dart';

class EmojiSelector extends StatefulWidget {
  const EmojiSelector({
    super.key,
    this.onEmojiSelected,
    this.showEmojiGroupName = false,
    this.showSearchField = true,
    this.autofocusSearchField = false,
    this.searchDelay = const Duration(milliseconds: 200),
    this.searchFieldDecoration,
  });

  /// Delay for search
  final Duration searchDelay;

  /// Callback for emoji selection
  final void Function(Emoji)? onEmojiSelected;

  /// Whether to show group name
  final bool showEmojiGroupName;

  /// Whether to show search field
  final bool showSearchField;

  /// Whether to auto focus on search
  final bool autofocusSearchField;

  /// search field decoration
  final InputDecoration? searchFieldDecoration;

  @override
  State<EmojiSelector> createState() => _EmojiSelectorState();
}

class _EmojiSelectorState extends State<EmojiSelector>
    with TickerProviderStateMixin {
  /// emojis grouped by emoji group
  final Map<EmojiGroup, List<Emoji>> _emojiGroupMap = {};

  /// all the emojis
  final List<Emoji> _emojis = Emoji.all();

  /// emoji group tab controller
  late TabController tabController;

  /// search controller
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
    return Column(
        children: [
          Visibility(
            visible: widget.showSearchField,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                autofocus: widget.autofocusSearchField,
                decoration: widget.searchFieldDecoration ??
                    InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: 'Search Emoji',
                      hintText: 'Search Emoji',
                      fillColor:
                          Theme.of(context).primaryColor.withOpacity(0.1),
                      filled: true,
                    ),
                controller: _searchController,
                onChanged: (val) {
                  EasyDebounce.debounce('search', widget.searchDelay, () {
                    setState(() {
                      var lowerVal = val.toLowerCase();
                      searchResults = _emojis
                          .where((element) =>
                              element.char.contains(lowerVal) ||
                              element.name.toLowerCase().contains(lowerVal) ||
                              element.shortName
                                  .toLowerCase()
                                  .contains(lowerVal) ||
                              element.emojiGroup.name
                                  .toLowerCase()
                                  .contains(lowerVal))
                          .toList();
                    });
                  });
                },
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            Expanded(
              child: EmojiGroupGrid(
                key: ValueKey(_searchController.text),
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
      );
  }
}
