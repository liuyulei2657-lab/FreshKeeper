library;
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "theme/app_theme.dart";
import "router/app_router.dart";

class FreshKeeperApp extends ConsumerWidget {
  const FreshKeeperApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: "FreshKeeper",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
