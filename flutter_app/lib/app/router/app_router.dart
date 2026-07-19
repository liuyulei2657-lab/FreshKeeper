library;
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:flutter_app/features/inventory/pages/inventory_page.dart";
import "package:flutter_app/features/food/pages/add/add_food_page.dart";
import "package:flutter_app/features/food/pages/detail/detail_page.dart";
import "package:flutter_app/features/settings/pages/settings_page.dart";

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: "/",
    routes: [
      GoRoute(path: "/", name: "inventory", builder: (context, state) => const InventoryPage()),
      GoRoute(path: "/add", name: "addFood", builder: (context, state) => const AddFoodPage()),
      GoRoute(
        path: "/detail/:id", name: "foodDetail",
        builder: (context, state) {
          final id = int.parse(state.pathParameters["id"]!);
          return DetailPage(foodId: id);
        },
      ),
      GoRoute(path: "/settings", name: "settings", builder: (context, state) => const SettingsPage()),
    ],
  );
});
