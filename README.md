<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

Emoji selector for Flutter

## Features

- Available on all platforms
- Categorized Emojis
- Search Emojis
- Double tap for skintone popup

<p align="center"><img src="https://github.com/Mufaddal1125/flutter-emoji-selector/blob/main/assets/emoji_selector.png?raw=true" height="700"></p>


## Search
<p align="center"><img src="https://github.com/Mufaddal1125/flutter-emoji-selector/blob/main/assets/search.png?raw=true" height="700"></p>

## Skin tone
<p align="center"><img src="https://raw.githubusercontent.com/Mufaddal1125/flutter-emoji-selector/main/assets/skintone.png" height="700"></p>

## Getting started

```yml
Flutter>=1.17.0
Dart >=2.17.6 <3.0.0
```
## Usage

```dart
import 'package:flutter/material.dart';
import 'package:flutter_emoji_selector/flutter_emoji_selector.dart';

EmojiSelector(
    onEmojiSelected: (emoji) {
        print(emoji.char); // prints the emoji
        print(emoji.name); // prints the emoji name
    },
)
```