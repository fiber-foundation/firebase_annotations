// Copyright (C) 2026 Fiber
//
// All rights reserved. This script, including its code and logic, is the
// exclusive property of Fiber. Redistribution, reproduction,
// or modification of any part of this script is strictly prohibited
// without prior written permission from Fiber.
//
// Conditions of use:
// - The code may not be copied, duplicated, or used, in whole or in part,
//   for any purpose without explicit authorization.
// - Redistribution of this code, with or without modification, is not
//   permitted unless expressly agreed upon by Fiber.
// - The name "Fiber" and any associated branding, logos, or
//   trademarks may not be used to endorse or promote derived products
//   or services without prior written approval.
//
// Disclaimer:
// THIS SCRIPT AND ITS CODE ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL
// FIBER BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING BUT NOT LIMITED TO LOSS OF USE,
// DATA, PROFITS, OR BUSINESS INTERRUPTION) ARISING OUT OF OR RELATED TO THE USE
// OR INABILITY TO USE THIS SCRIPT, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// Unauthorized copying or reproduction of this script, in whole or in part,
// is a violation of applicable intellectual property laws and will result
// in legal action.

/// {@template auth_gen}
/// Annotation used to declare a fully-defined authentication configuration
/// for automatic code generation within the Fiber ecosystem.
///
/// When applied to a class, this annotation instructs the generator to:
/// - Generate role-scoped authentication logic based on [AuthKind].
/// - Bind authentication to a specific Firestore collection.
/// - Configure the regional endpoint for Cloud Functions callables.
/// - Generate only the selected authentication [AuthModule] capabilities.
/// - Produce strongly-typed services, helpers, and guards.
///
/// The annotated class acts purely as a declarative configuration entry
/// point and typically contains no implementation details.
///
/// ### Example
/// ```dart
/// @AuthGen(
///   kind: AuthKind.user,
///   firestoreCollection: "__fbs__users",
///   callableRegion: "us-central1",
///   modules: [
///     AuthModule.signIn,
///     AuthModule.signUp,
///   ],
/// )
/// class UserAuthConfig {}
/// ```
///
/// The generator may then produce:
/// - Role-aware authentication services.
/// - Firestore-bound user access helpers.
/// - Region-configured callable integrations.
/// - Module-specific methods (e.g. `signIn()`, `signUp()`).
/// - Typed session state and guard utilities.
///
/// ### Notes
/// - [kind] defines the authentication domain.
/// - [firestoreCollection] specifies the associated user collection.
/// - [callableRegion] determines the Cloud Functions region.
/// - [modules] lists all authentication capabilities to generate.
/// - The annotated class serves only as a generation entry point.
///
/// {@endtemplate}
class AuthGen {
  /// Defines the authentication scope to generate.
  ///
  /// - [AuthKind.user] for standard end-user authentication.
  /// - [AuthKind.administrator] for privileged administrator authentication.
  final AuthKind kind;

  /// Defines the authentication flows that should be generated.
  ///
  /// Multiple flows can be specified to enable combined support
  /// (e.g. login + registration).
  ///
  /// Available options:
  /// - [AuthModule.session]
  /// - [AuthModule.signIn]
  /// - [AuthModule.signUp]
  /// - [AuthModule.forgotPassword]
  final List<AuthModule> modules;

  /// Defines the Firestore collection associated with this
  /// authentication domain.
  ///
  /// This collection typically represents the user store
  /// where authentication-related data is persisted
  /// (e.g. user profiles, roles, metadata, session flags).
  ///
  /// Example:
  /// ```dart
  /// firestoreCollection: "__fbs__users"
  /// ```
  ///
  /// The generator may use this value to:
  /// - Bind authentication logic to a specific Firestore collection
  /// - Generate typed document references
  /// - Produce role-aware data access helpers
  final String firestoreCollection;

  /// Defines the Firebase Cloud Functions region used for
  /// authentication callables.
  ///
  /// This value determines which regional endpoint is targeted
  /// when invoking authentication-related HTTPS callable functions.
  ///
  /// Example:
  /// ```dart
  /// callableRegion: "us-central1"
  /// ```
  ///
  /// The generator may use this value to:
  /// - Configure region-specific callable clients
  /// - Ensure alignment with deployed backend functions
  /// - Prevent cross-region invocation mismatches
  final String callableRegion;

  /// {@macro auth_gen}
  const AuthGen({
    required this.kind,
    required this.modules,
    required this.firestoreCollection,
    required this.callableRegion,
  });
}

/// {@template auth_kind}
/// Defines the supported authentication domains.
///
/// Each value represents a distinct authentication scope.
/// The selected [AuthKind] determines how authentication logic,
/// data bindings, and generated services are segmented.
///
/// This allows applications to isolate different authentication
/// contexts (e.g. end-users vs administrators) while maintaining
/// strongly-typed and role-aware infrastructure.
/// {@endtemplate}
enum AuthKind {
  /// Standard end-user authentication domain.
  ///
  /// Intended for regular application users interacting
  /// with the public-facing features of the system.
  user,

  /// Privileged administrator authentication domain.
  ///
  /// Intended for back-office or elevated accounts with
  /// higher access levels and restricted capabilities.
  administrator,
}

/// {@template auth_module}
/// Defines the available authentication modules that can be generated
/// for a given authentication configuration.
///
/// Each value represents a distinct authentication capability.
/// The selected modules determine which services, helpers, and
/// infrastructure bindings will be produced by the code generator.
///
/// Modules can be combined to enable multi-capability authentication
/// (e.g. session management + sign-in + password recovery).
/// {@endtemplate}
enum AuthModule {
  /// Generates authentication session support.
  ///
  /// This typically includes:
  /// - Session state helpers (e.g. `isConnected`)
  /// - Access to the authenticated user identifier
  /// - Token or metadata management utilities
  session,

  /// Generates user sign-in logic.
  ///
  /// Includes login helpers and related authentication handling.
  signIn,

  /// Generates user registration logic.
  ///
  /// Includes account creation helpers and associated validation flows.
  signUp,

  /// Generates password recovery logic.
  ///
  /// Includes helpers for initiating and handling password reset flows.
  forgotPassword,
}
