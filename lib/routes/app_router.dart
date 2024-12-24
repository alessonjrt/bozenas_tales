import 'package:bozenas_tales/features/stories/presentation/cubit/stories_cubit.dart';
import 'package:bozenas_tales/features/stories/presentation/pages/stories_page.dart';
import 'package:bozenas_tales/injection/injection_container.dart';
import 'package:bozenas_tales/routes/routes.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  late final GoRouter router;

  AppRouter() {
    router = GoRouter(
      routes: [
        GoRoute(
            path: Routes.storiesPages,
            name: 'storiesList',
            builder: (context, state) =>
                StoriesListPage(storiesCubit: getIt<StoriesCubit>())),
      ],
    );
  }
}
