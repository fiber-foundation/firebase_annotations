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
  /// {@template field_annotation.is_document_id}
  /// Indicates that this field holds the document ID of the Firestore document.
  ///
  /// When `true`, the field is treated as the document ID (e.g. `documentId`)
  /// and can be excluded from the serialized map if necessary.
  /// {@endtemplate}
  final bool documentId;

  /// {@template field_annotation.skip_from_map}
  /// Whether the field should be skipped in the generated `fromMap` method.
  ///
  /// If `true`, the field will not be initialized from the input map.
  /// Useful when the value is injected externally (e.g. the document ID).
  /// {@endtemplate}
  final FromMap fromMap;

  /// {@template field_annotation.skip_copy_with}
  /// Whether the field should be skipped in the generated `copyWith` method.
  ///
  /// If `true`, the field will not be included as a named parameter in `copyWith`.
  /// {@endtemplate}
  final bool copyWith;

  /// {@template field_annotation.skip_to_map}
  /// Whether the field should be skipped in the generated `toMap` method.
  ///
  /// If `true`, the field will not be serialized in the output map.
  /// {@endtemplate}
  final bool toMap;

  const Field({
    this.documentId = false,
    this.fromMap = const FromMap(fromMap: true),
    this.copyWith = true,
    this.toMap = true,
  });
}

/// {@template geo_field_annotation}
/// Annotation applied to a model class or field to indicate that it participates
/// in the geospatial indexing system.
///
/// This annotation is used to mark a model as containing geolocation data.
/// It enables the code generator to automatically detect fields annotated
/// with [GeoLocationField] and [GeoHashField], and to generate the required
/// helpers for geo-queries (geohash extraction, distance computation, etc.).
///
/// ### Usage
/// ```dart
/// @GeoField()
/// class StoreLocation {
///   @GeoLocationField()
///   final Location coordinates;
///
///   @GeoHashField()
///   final String geohash;
/// }
/// ```
/// {@endtemplate}
class GeoField {
  const GeoField();
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
  /// The default value to use if the field is not present in the source map.
  ///
  /// Must be a Dart expression written as a string. This is injected directly
  /// into the generated `fromMap` code.
  ///
  /// Example: `"0"`, `"false"`, `"\"anonymous\""`
  /// {@endtemplate}
  final String? defaultValue;

  /// Creates a new [FromMap] configuration.
  ///
  /// Defaults to including the field (`fromMap = true`) and no default value.
  const FromMap({this.fromMap = true, this.defaultValue});
}
