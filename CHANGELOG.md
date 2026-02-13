# 1.1.2

- Updated README to reflect authentication support and session-based flows.
- Improved project description to cover Firestore, Database, Storage, and Authentication.
- Clarified package goals and infrastructure scope.
- Added dedicated Authentication section with usage examples.
- Updated installation version reference.

# 1.1.1

- Renamed `AuthFlow.user` to `AuthFlow.session`.
- Clarified semantic meaning of session-related authentication state (isConnected, userId, tokens, etc.).
- Improved inline documentation for authentication flow definitions.

# 1.1.0

- Introduced `DefaultValueKind` enum to classify default value semantics (string, double, integer, boolean, nil, enumeration, object).
- Refactored `DefaultValue` to include a `kind` property for stronger semantic typing.
- Added `DefaultValue.raw(String value, DefaultValueKind kind)` factory for advanced and internal reconstruction use cases.
- Improved documentation for `DefaultValue`, `DefaultValueKind`, and `Literalizable`.
- Enhanced default value system to better support typed code generation scenarios.

# 1.0.9

- Added `AuthGen` annotation for authentication code generation.
- Introduced `AuthKind` enum to define authentication scope (user, administrator).
- Introduced `AuthFlow` enum to configure supported flows (signIn, signUp, forgotPassword).
- Added support for multiple authentication flows via `List<AuthFlow>`.
- Added detailed documentation for authentication configuration.

# 1.0.8

- Added a README file to the `example/` directory to document and link available examples.

# 1.0.7

- Added usage examples in the `example/` directory to demonstrate how to apply the provided annotations.
- Fixed and improved README documentation.

# 1.0.6

- Added comprehensive README documentation explaining how to use the package annotations.

# 1.0.5

# 1.0.4

# 1.0.3

# 1.0.2

# 1.0.1

# 1.0.0