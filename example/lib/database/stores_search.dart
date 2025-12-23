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

import 'package:equatable/equatable.dart';
import 'package:fiber_firebase_annotations/fiber_firebase_annotations.dart';

@DatabaseGen(
  databaseURL: "https://e72c8f8cd0b4f-0ee7-4181-bae4-7e3126a7ebc5.europe-west1.firebasedatabase.app",
  name: "stores_search",
)
class FirebaseStoresSearch extends Equatable {
  @Field(documentId: true, toMap: false, copyWith: false)
  final String storeId;
  final double lat;
  final double lng;
  final String updatedAt;
  final String geohash;

  const FirebaseStoresSearch({
    required this.storeId,
    required this.lat,
    required this.lng,
    required this.updatedAt,
    required this.geohash,
  });

  @override
  List<Object?> get props => [storeId, lat, lng, updatedAt, geohash];
}
