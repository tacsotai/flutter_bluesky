# flutter_bluesky

This plugin provides a client for [bluesky](https://bsky.app/) or other PDS of [atproto](https://github.com/bluesky-social/atproto).
This plugin use API client by [myConsciousness/atproto.dart](https://github.com/myConsciousness/atproto.dart).
> [atproto](https://github.com/myConsciousness/atproto.dart/tree/main/packages/atproto) and [bluesky](https://github.com/myConsciousness/atproto.dart/tree/main/packages/bluesky) (Dart)

- Caution
It is **not completed** to invoke all APIs.
I will make it little by little.
It may change by spec change of atproto.

## Getting Started
```
cd flutter_bluesky/example
flutter pub get
flutter run 
```

Enjoy!!

## DB 
The ATProtocol designs that the client must store data in case a PDS the client connectted is crashed.
### Structure (under construction)
Account Entity is not for atproto but flutter_bluesky to manage session with each provider and the user. 
```
└── tables
    ├── account.dart
    └── app_view
        ├── post.dart
        :
```
