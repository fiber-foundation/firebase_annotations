// Copyright (C) 2025 Fiber
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

/// {@template field_annotation}
/// Annotation used to customize the code generation behavior of a model field.
///
/// You can use this annotation to exclude a field from specific
/// generated methods like `fromMap`, `toMap`, or `copyWith`, or to
/// indicate that the field represents the document ID in Firestore.
///
/// Example usage:
/// ```dart
/// @Field(isDocumentId: true, fromMap: true)
/// final String userId;
/// ```
/// {@endtemplate}
class Field {
  /// {@template field_annotation.key}
  /// Optional override for the serialized field key used in generated methods.
  ///
  /// When `null`, the code generator assigns an automatic key based on the
  /// field name (e.g. `__fbs__<fieldName>`).
  ///
  /// When provided, this value replaces the default key and is used wherever
  /// the field is referenced in generated code (e.g. `fromMap`, `toMap`,
  /// query helpers, or filter definitions).
  ///
  /// This is useful when the stored key differs from the Dart field name,
  /// or when maintaining backward compatibility with an existing schema.
  /// {@endtemplate}
  final String? key;

  /// {@template field_annotation.is_document_id}
  /// Indicates that this field holds the document ID of the Firestore document.
  ///
  /// When `true`, the field is treated as the document ID (e.g. `documentId`)
  /// and can be excluded from the serialized map if necessary.
  /// {@endtemplate}
  final bool documentId;

  /// {@template field_annotation.skip_copy_with}
  /// Whether the field should be skipped in the generated `copyWith` method.
  ///
  /// If `true`, the field will not be included as a named parameter in `copyWith`.
  /// {@endtemplate}
  final bool copyWith;

  /// {@template field_annotation.skip_from_map}
  /// Whether the field should be skipped in the generated `fromMap` method.
  ///
  /// If `true`, the field will not be initialized from the input map.
  /// Useful when the value is injected externally (e.g. the document ID).
  /// {@endtemplate}
  final FromMap fromMap;

  /// {@template field_annotation.skip_to_map}
  /// Whether the field should be skipped in the generated `toMap` method.
  ///
  /// If `true`, the field will not be serialized in the output map.
  /// {@endtemplate}
  final bool toMap;

  const Field({
    this.key,
    this.documentId = false,
    this.fromMap = const FromMap(fromMap: true),
    this.copyWith = true,
    this.toMap = true,
  });
}

/// {@template from_map_annotation}
/// Annotation helper used to configure how a field is handled
/// during `fromMap` code generation.
///
/// This class allows you to:
/// - Enable or disable mapping from a source map.
/// - Optionally provide a default value to use when the key is missing.
///
/// ### Example
/// ```dart
/// @Field(fromMap: FromMap(fromMap: true, defaultValue: '"default string"'))
/// final String name;
/// ```
///
/// Note: `defaultValue` must be provided as a valid Dart expression in `String` form,
/// such as `"true"`, `"0"`, `"\"unknown\""` or even `"MyEnum.defaultValue.name"`.
/// {@endtemplate}
class FromMap {
  /// {@template from_map_annotation.has_from_map}
  /// Whether this field should be included in the `fromMap` generation.
  ///
  /// If `false`, the field will not be parsed from the source map.
  /// Useful when the field is injected manually or derived elsewhere.
  /// {@endtemplate}
  final bool fromMap;

  /// {@template from_map_annotation.default_value}
  /// Defines the default value to use when the field is missing from the
  /// source map during `fromMap` generation.
  ///
  /// This value must be provided as a [`DefaultValue`], which encapsulates:
  /// - a raw Dart expression (`value`)
  /// - its semantic kind (`kind`)
  ///
  /// The expression contained inside the [`DefaultValue`] instance is
  /// inserted **verbatim** into the generated `fromMap` method. It must
  /// therefore represent a **valid Dart literal or constructor expression**.
  ///
  /// Examples:
  /// ```dart
  /// DefaultValue.int_(0)
  /// DefaultValue.boolean_(false)
  /// DefaultValue.string_("anonymous")
  /// DefaultValue.enumeration_(MyEnum.value)
  /// DefaultValue.object_(Store(id: "123", title: "Test"))
  /// ```
  ///
  /// If `null`, no default value is injected and the field is left untouched
  /// when absent from the source map.
  /// {@endtemplate}
  final DefaultValue? defaultValue;

  /// Creates a new [FromMap] configuration.
  ///
  /// Defaults to including the field (`fromMap = true`) and no default value.
  const FromMap({this.fromMap = true, this.defaultValue});
}

/// {@template default_value_kind}
/// Enumerates the different kinds of default values that can be assigned
/// to a field during code generation.
///
/// Each value represents the semantic category of the provided default,
/// allowing the generator to handle serialization and literal injection
/// correctly based on type.
///
/// Available kinds:
/// - `string`        → A string literal
/// - `double`        → A double literal
/// - `integer`       → An integer literal
/// - `boolean`       → A boolean literal
/// - `nil`           → A `null` literal
/// - `enumeration`   → An enum value literal (e.g. `MyEnum.value`)
/// - `object`        → A Dart object literal implementing `Literalizable`
/// {@endtemplate}
enum DefaultValueKind { string, double, integer, boolean, nil, enumeration, object }

/// {@template default_value}
/// Represents a strongly-typed default value used during code generation.
///
/// This class stores:
/// - a raw Dart expression as a string (`value`)
/// - its semantic category (`kind`)
///
/// It allows the generator to safely inject valid Dart literals inside
/// synthesized methods such as `fromMap`, `toMap`, or constructors.
///
/// Instances must always represent **valid Dart expressions**, since the
/// string is inserted directly into generated code without transformation.
/// {@endtemplate}
class DefaultValue {
  /// {@template default_value.value}
  /// The raw Dart expression for the default value.
  ///
  /// Examples:
  /// - `0`
  /// - `false`
  /// - `MyEnum.defaultValue`
  /// - `Store(id: "123", title: "Test")`
  ///
  /// This expression is inserted verbatim into generated Dart code.
  /// {@endtemplate}
  final String value;

  /// {@template default_value.kind}
  /// The semantic category of the default value.
  ///
  /// Used by the generator to determine how the literal should be treated
  /// or validated when injecting it into generated output.
  /// {@endtemplate}
  final DefaultValueKind kind;

  /// {@template default_value.private_ctor}
  /// Internal constructor used by factory helpers to create a typed
  /// default value. Not intended for direct external construction.
  /// {@endtemplate}
  DefaultValue._(this.value, this.kind);

  /// {@template default_value.string}
  /// Creates a string default value literal.
  ///
  /// Example:
  /// ```dart
  /// DefaultValue.string_("hello");
  /// ```
  /// {@endtemplate}
  static string_(String value) => DefaultValue._(value, DefaultValueKind.string);

  /// {@template default_value.double}
  /// Creates a double default value literal.
  ///
  /// Example:
  /// ```dart
  /// DefaultValue.double_(3.14);
  /// ```
  /// {@endtemplate}
  static double_(double value) => DefaultValue._("$value", DefaultValueKind.double);

  /// {@template default_value.integer}
  /// Creates an integer default value literal.
  ///
  /// Example:
  /// ```dart
  /// DefaultValue.int_(42);
  /// ```
  /// {@endtemplate}
  static int_(int value) => DefaultValue._("$value", DefaultValueKind.integer);

  /// {@template default_value.boolean}
  /// Creates a boolean default value literal.
  ///
  /// Example:
  /// ```dart
  /// DefaultValue.boolean_(true);
  /// ```
  /// {@endtemplate}
  static boolean_(bool value) => DefaultValue._("$value", DefaultValueKind.boolean);

  /// {@template default_value.null}
  /// Creates a `null` literal default value.
  ///
  /// Example:
  /// ```dart
  /// DefaultValue.null_();
  /// ```
  /// {@endtemplate}
  static null_() => DefaultValue._("null", DefaultValueKind.nil);

  /// {@template default_value.enumeration}
  /// Creates an enum default value literal.
  ///
  /// The provided enum instance must not override `toString()`, since its
  /// Dart literal form is reconstructed from the enum's `toString()` output.
  ///
  /// Example:
  /// ```dart
  /// DefaultValue.enumeration_(MyEnum.value);
  /// // produces "MyEnum.value"
  /// ```
  /// {@endtemplate}
  static enumeration_(Enum value) => DefaultValue._("$value", DefaultValueKind.enumeration);

  /// {@template default_value.object}
  /// Creates a default value literal from an object that implements
  /// [Literalizable].
  ///
  /// The object's `toLiteral()` method must return a valid Dart expression
  /// representing a constructor call or static reference.
  ///
  /// Example:
  /// ```dart
  /// class Store implements Literalizable {
  ///   final String id;
  ///   const Store(this.id);
  ///
  ///   @override
  ///   String toLiteral() => 'Store("$id")';
  /// }
  ///
  /// DefaultValue.object_(Store("123"));
  /// // produces 'Store("123")'
  /// ```
  /// {@endtemplate}
  static object_(Literalizable value) => DefaultValue._(value.toLiteral(), DefaultValueKind.object);

  /// {@template default_value.raw}
  /// Creates a [DefaultValue] from a raw Dart expression and its
  /// associated [DefaultValueKind].
  ///
  /// This factory is intended for advanced or internal usage where a
  /// default value must be reconstructed dynamically.
  ///
  /// The provided [value] must be a **valid Dart expression**, as it will be
  /// injected verbatim into generated source code without modification.
  ///
  /// Example:
  /// ```dart
  /// DefaultValue.raw("MyEnum.defaultValue", DefaultValueKind.enumeration);
  /// ```
  ///
  /// Unlike other factory helpers (`string_`, `int_`, etc.), this method
  /// does not perform type validation and assumes the caller guarantees
  /// semantic correctness.
  /// {@endtemplate}
  static raw_(String value, DefaultValueKind kind) => DefaultValue._(value, kind);
}

/// {@template literalizable}
/// Contract for objects that can convert themselves into a valid Dart
/// literal representation.
///
/// Implementations must return a string containing a Dart expression that
/// can be inserted directly into generated code.
///
/// Typical use-cases:
/// - code generation
/// - static default object values
///
/// Example:
/// ```dart
/// class Store implements Literalizable {
///   final String id;
///   final String title;
///
///   const Store({required this.id, required this.title});
///
///   @override
///   String toLiteral() =>
///       'Store(id: "$id", title: "$title")';
/// }
/// ```
/// {@endtemplate}
abstract class Literalizable {
  /// {@template literalizable.to_literal}
  /// Converts the current instance into a Dart literal string representation.
  ///
  /// The returned string must be a **valid Dart expression**, as it will be
  /// inserted directly into generated code without escaping or quoting.
  /// {@endtemplate}
  String toLiteral();
}
