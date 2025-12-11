import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'data/local/database.dart';
import 'data/remote/api_client.dart';
import 'data/services/gen_ai_service.dart';
import 'data/services/work_service.dart';
import 'domain/repositories/auth_repository.dart'; // 1. Import AuthRepository
import 'domain/repositories/chat_repository.dart';
import 'domain/repositories/work_repository.dart';
import 'logic/blocs/camera/camera_bloc.dart';
import 'logic/blocs/chat/chat_bloc.dart';
import 'logic/blocs/work/work_bloc.dart';
import 'presentation/router/router.dart';
import 'core/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterGemma.initialize(
    huggingFaceToken: AppConstants.huggingFaceToken,
    maxDownloadRetries: 10,
  );

  // --- Create instances of all repositories ---
  final db = AppDatabase();
  final genAIService = GenAIService();
  final workService = WorkService();

  final authRepo = AuthRepository(); // 2. Create an instance of AuthRepository
  final workRepo = WorkRepository( workService, db);
  final chatRepo = ChatRepository(genAIService);

  runApp(
    MultiRepositoryProvider(
      providers: [
        // 3. Add AuthRepository to the list of providers
        RepositoryProvider(create: (_) => authRepo),
        RepositoryProvider(create: (_) => workRepo),
        RepositoryProvider(create: (_) => chatRepo),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => WorkBloc(workRepo)),
          BlocProvider(create: (_) => ChatBloc(chatRepo)),
          BlocProvider(create: (_) => CameraBloc()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Demo Gemma3',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
