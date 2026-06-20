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

  // Status bar transparente
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  await dotenv.load(fileName: '.env');
  await Hive.initFlutter();
  Hive.registerAdapter(MovieAdapter());
  await Hive.openBox<Movie>('favorites');

  runApp(const CineFlutterApp());
}

class CineFlutterApp extends StatelessWidget {
  const CineFlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = TmdbApiService();
    final hiveService = HiveService();
    final prefsService = PrefsService();
    final repository = MovieRepository(apiService, hiveService);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel(repository)),
        ChangeNotifierProvider(create: (_) => SearchViewModel(repository)),
        ChangeNotifierProvider(create: (_) => DetailViewModel(repository)),
        ChangeNotifierProvider(create: (_) => FavoritesViewModel(repository)),
        ChangeNotifierProvider(create: (_) => prefsService),
      ],
      child: MaterialApp.router(
        title: 'CineFlutter',
        debugShowCheckedModeBanner: false,
        // Rose et noir PARTOUT — thème forcé
        theme: AppTheme.darkTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        routerConfig: AppRouter.router,
      ),
    );
  }
}