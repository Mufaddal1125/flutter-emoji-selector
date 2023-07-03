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


<p>
The Emoji Selector package for Flutter is a comprehensive solution for incorporating Unicode 13.1 emojis into your Flutter applications. With its seamless compatibility across all platforms, this package ensures a consistent and delightful user experience. The emojis are thoughtfully categorized, allowing users to easily browse and select their desired expressions. Additionally, a powerful search functionality enables users to quickly find specific emojis. One of the standout features is the skintone popup, which can be accessed through a convenient double-tap gesture, providing users with even more customization options. Whether you're building a messaging app, social media platform, or any application where emojis play a significant role, this package offers a streamlined and user-friendly way to enhance your user interface and communication capabilities.
</p>


## Features

- Unicode 13.1 emojis
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