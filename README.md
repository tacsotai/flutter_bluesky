# flutter_bluesky

This plugin provides a client for [bluesky](https://bsky.app/) or other PDS of [atproto](https://github.com/bluesky-social/atproto).
But UI is not provided, make it by yourself although the [example](#getting-started) is provided.

## Getting Started
```
cd flutter_bluesky/example
flutter pub get
flutter run 
```

## DB
### [isar](https://pub.dev/packages/isar)
Account Entity is not for atproto but flutter_bluesky to manage session with each provider and the user. 
```
└── tables
    ├── account.dart
    ├── account.g.dart
    └── app_view
        ├── post.dart
        ├── post.g.dart
```
- example Entity: Post
```
import 'package:isar/isar.dart';
part 'post.g.dart';

@collection
class Post {
  // isar ruled ID
  Id id = Isar.autoIncrement;

  // pds provider
  @Index(type: IndexType.value)
  late String provider;

  // user id
  @Index(type: IndexType.value)
  late String did;
  :
}
```