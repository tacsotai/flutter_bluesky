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
Account Entity is not for atproto but flutter_bluesky to manage session with each provider and the user. 
```
└── tables
    ├── account.dart
    ├── account.g.dart
    └── app_view
        ├── post.dart
        ├── post.g.dart
```
