import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roadmap/firebase_options.dart';
import 'package:roadmap/repositories/auth_repository.dart';
import 'package:roadmap/repositories/roadmap_repository.dart';
import 'package:roadmap/screens/auth/bloc/auth_bloc.dart';
import 'package:roadmap/services/notification_service.dart';
import 'package:roadmap/utils/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => RoadmapRepository()),
      ],
      child: BlocProvider(
        create: (context) => AuthBloc(
          authRepository: context.read<AuthRepository>(),
        ),
        child: Builder(
          builder: (context) {
            final authBloc = context.watch<AuthBloc>();
            final router = AppRouter(authBloc).router;
            return MaterialApp.router(
              title: 'Roadmap App',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                textTheme: GoogleFonts.latoTextTheme(
                  Theme.of(context).textTheme,
                ),
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              routerConfig: router,
            );
          },
        ),
      ),
    );
  }
}