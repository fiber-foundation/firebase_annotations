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
/// Annotation used to declare an **authentication configuration**
/// for automatic code generation.
///
/// When applied to a class, this annotation instructs the generator to:
/// - Create role-specific authentication logic based on [AuthKind].
/// - Generate only the selected authentication [AuthFlow] entries.
/// - Produce strongly-typed helpers for each enabled flow.
/// - Scope authentication services to a defined domain.
///
/// The annotated class acts purely as a declarative marker and
/// typically contains no implementation details.
///
/// ### Example
/// ```dart
/// @AuthGen(
///   kind: AuthKind.user,
///   flows: [
///     AuthFlow.signIn,
///     AuthFlow.signUp,
///   ],
/// )
/// class UserAuthConfig {}
/// ```
///
/// The generator may then produce:
/// - Role-aware authentication services.
/// - Flow-specific methods (e.g. `signIn()`, `signUp()`).
/// - Typed session and guard helpers.
///
/// ### Notes
/// - [kind] defines the authentication domain.
/// - [flows] lists all authentication flows that should be generated.
/// - Providing multiple flows enables multi-capability generation.
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
  /// - [AuthFlow.session]
  /// - [AuthFlow.signIn]
  /// - [AuthFlow.signUp]
  /// - [AuthFlow.forgotPassword]
  final List<AuthFlow> flows;

  /// Creates a new authentication annotation for code generation.
  const AuthGen({required this.kind, required this.flows});
}

/// Defines the supported authentication domains.
enum AuthKind {
  /// Standard application user authentication.
  user,

  /// Privileged administrator authentication.
  administrator,
}

/// Defines the available authentication flows.
enum AuthFlow {
  /// Authentication session state
  session,

  /// User login flow.
  signIn,

  /// User registration flow.
  signUp,

  /// Password recovery flow.
  forgotPassword,
}
