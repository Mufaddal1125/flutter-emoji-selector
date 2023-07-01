import 'package:emojis/emoji.dart';
import 'package:flutter/material.dart';

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

extension EmojiExtension on Emoji {
  Map<String, dynamic> toJson() => {
        'name': name,
        'char': char,
        'keywords': keywords,
        'emojiGroup': emojiGroup.index,
        'modifiable': modifiable,
        'shortName': shortName,
        'emojiSubgroup': emojiSubgroup.index,
        
      };

  static Emoji fromJson(Map<String, dynamic> json) => Emoji(
        name: json['name'] as String,
        char: json['char'] as String,
        keywords: json['keywords'] as List<String>,
        emojiGroup: EmojiGroup.values[json['emojiGroup'] as int],
        modifiable: json['modifiable'] as bool,
        shortName: json['shortName'] as String,
        emojiSubgroup: EmojiSubgroup.values[json['emojiSubgroup'] as int],
      );
}
