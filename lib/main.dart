import 'package:bozenas_tales/core/theme.dart';
import 'package:bozenas_tales/injection/injection_container.dart';
import 'package:bozenas_tales/routes/app_router.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(BozenasTales());
}

class BozenasTales extends StatelessWidget {
  final AppRouter _appRouter = AppRouter();

  BozenasTales({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Bozenas Tales',
      routerConfig: _appRouter.router,
      theme: BozenaTheme.theme,
      debugShowCheckedModeBanner: false,
    );
  }
}
