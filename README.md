<p align="center">
  <img src="https://fiberstudio.app/assets/images/fiber.png" alt="Fiber Logo" width="160" />
</p>

# fiber_firebase_annotation

`fiber_firebase_annotation` is a Dart annotation package designed to power a Firebase-oriented code generation system.
It allows you to define typed, declarative, and consistent data models for Firestore, Database, Storage, without embedding any Firebase-specific logic into application code.
This package does not generate any code by itself.
It only provides the annotations consumed by Fiber code generators.

## Goals

- Define your data structure once
- Automatically generate:
  - Firestore / Database models
  - Typed Storage access helpers
  - Typed constants
  - fromMap / toMap mappings
- Decouple business logic from Firebase infrastructure
- Enable future backend migration (Firebase → another backend)

## Installation

```yaml
dependencies:
  fiber_firebase_annotation: ^1.0.9
```

To be used in conjunction with Fiber code generation packages (`fiber_*_gen`).

## Annotation Overview

Domain | Primary Annotation |
--- | ---
Firestore | @FirestoreCollectionGen(...), @FirestoreSubCollectionGen(...) |
Database | @DatabaseGen(...) |
Storage | @StorageNode(...) |
Authentication | @AuthGen(...)

## Firebase Firestore

Use @FirestoreCollectionGen(...) to define a root Firestore collection.

```dart
@FirestoreCollectionGen(collection: "__fbs__users")
class User {
  // fields...
}
```

This annotation is intended for models that represent top-level Firestore collections, such as:

- users
- projects
- stores
- threads

The generator can use this information to produce:

- collection name constants
-  typed collection references
-  helper methods for queries and document access

Use @FirestoreSubCollectionGen(...) to define a subcollection inside a Firestore document.

```dart
@FirestoreSubCollectionGen(parent: "__fbs__chats", collection: "__fbs__messages")
class Message {
  // fields...
}
```

This is useful for modeling hierarchical relationships such as:

- users/{userId}/notifications
- chats/{chatId}/messages
- projects/{projectId}/tasks

## Realtime Database

The @DatabaseGen(...) annotation is used to declare a Firebase Realtime Database schema in a declarative way, enabling automatic code generation within the Fiber ecosystem.

It defines entry points for Realtime Database instances, without embedding any runtime Firebase logic or serialization code in the application layer.

```dart
@DatabaseGen(databaseURL: "https://myapp-users.firebaseio.com", name: "usersDB")
class UserDatabaseModel {
  // fields...
}
```

This annotation allows the build system to:
- generate strongly typed database accessors
- produce models aligned with the underlying JSON structure
- centralize database configuration (URL and logical name)
- remove boilerplate for serialization and deserialization

## Firebase Storage

The @StorageGen(...) annotation is used to declaratively define the structure of a Firebase Storage bucket, enabling automatic generation of strongly typed storage accessors and path helpers.

Instead of manually concatenating string paths, storage hierarchies are described once and transformed into a type-safe, IDE-completable API by Fiber generators.

```dart
@StorageGen(
  root: [
    StorageNode(
      name: "users",
      children: [
        StorageNode(name: "avatars"),
        StorageNode(
          name: "documents",
          children: [
            StorageNode(name: "contracts"),
            StorageNode(name: "invoices"),
          ],
        ),
      ],
    ),
    StorageNode(name: "projects"),
  ],
)
class Storage {}
```

This annotation describes the entire storage tree, including nested folders and dynamic segments.