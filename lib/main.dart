import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'data/models/movie.dart';
import 'data/services/tmdb_api_service.dart';
import 'data/services/local/hive_service.dart';
import 'data/services/local/prefs_service.dart';
import 'data/repositories/movie_repository.dart';
import 'presentation/viewmodels/home_viewmodel.dart';
import 'presentation/viewmodels/search_viewmodel.dart';
import 'presentation/viewmodels/detail_viewmodel.dart';
import 'presentation/viewmodels/favorites_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  await dotenv.load(fileName: '.env');
  await Hive.initFlutter();
  Hive.registerAdapter(MovieAdapter());
  await Hive.openBox<Movie>('favorites');

  final prefsService = PrefsService();
  await prefsService.init();

  runApp(CineFlutterApp(prefsService: prefsService));
}

class CineFlutterApp extends StatelessWidget {
  final PrefsService prefsService;
  const CineFlutterApp({super.key, required this.prefsService});

  @override
  Widget build(BuildContext context) {
    final apiService = TmdbApiService();
    final hiveService = HiveService();
    final repository = MovieRepository(apiService, hiveService);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel(repository)),
        ChangeNotifierProvider(create: (_) => SearchViewModel(repository)),
        ChangeNotifierProvider(create: (_) => DetailViewModel(repository)),
        ChangeNotifierProvider(create: (_) => FavoritesViewModel(repository)),
        ChangeNotifierProvider.value(value: prefsService),
      ],
      child: MaterialApp.router(
        title: 'CineFlutter',
        debugShowCheckedModeBanner: false,
        // UN SEUL theme fixe - pas de mode sombre/clair
        theme: AppTheme.darkTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}