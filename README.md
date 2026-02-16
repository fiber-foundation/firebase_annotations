<p align="center">
  <img src="https://fiberstudio.app/assets/images/fiber.png" alt="Fiber Logo" width="160" />
</p>

# fiber_firebase_annotation

`fiber_firebase_annotation` is a Dart annotation package that provides the declarative foundation for the Fiber Firebase code generation ecosystem.

It enables you to define strongly-typed, consistent, and infrastructure-aware configurations for:

- Firestore collections and subcollections
- Realtime Database schemas
- Firebase Storage hierarchies
- Authentication domains and flows

All without embedding any Firebase-specific runtime logic into your application layer.

This package does not generate code by itself.
It only exposes annotations that are consumed by Fiber generator packages, ensuring a strict separation between infrastructure definitions and business logic.

## Goals

- Define your Firebase infrastructure declaratively in one place
- Automatically generate:
  - Authentication services (session and flows)
  - Firestore collection and subcollection accessors
  - Realtime Database bindings
  - Strongly-typed Storage path helpers
  - Typed constants and helpers
  - `fromMap` / `toMap` mappings with typed default values
- Enforce consistency across your data and authentication layers
- Keep business logic fully decoupled from Firebase runtime APIs
- Make backend evolution possible (Firebase → another backend) without rewriting your application layer

## Installation

```yaml
dependencies:
  fiber_firebase_annotation: ^1.1.2
```

To be used in conjunction with Fiber code generation packages (`fiber_*_gen`).

## Annotation Overview

Domain | Primary Annotation |
--- | ---
Authentication | @AuthGen(...)
Firestore | @FirestoreCollectionGen(...), @FirestoreSubCollectionGen(...) |
Database | @DatabaseGen(...) |
Storage | @StorageNode(...) |

## Authentication

Use @AuthGen(...) to declaratively define an authentication domain and its enabled flows.

```dart
@AuthGen(
  firestoreCollection: "__fbs__users",
  region: FirebaseFunctionsRegion.us_central1,
  passwordPolicy: PasswordPolicy(
    min: 8,
    requireUppercase: true,
    requireDigits: true,
  ),
  signIn: SignInModule(
    requireEmailVerification: true,
  ),
  signUp: SignUpModule(
    requireEmailVerification: false,
    autoSignInAfterSignUp: true,
  ),
)
class User {
  final String firstname;
  final String lastname;
  ...
}
```

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