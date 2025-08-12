import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jh_aplicacion/features/auth/login_screen.dart';
import 'package:jh_aplicacion/features/personas/personas_form_screen.dart';
import 'package:jh_aplicacion/features/personas/personas_list_screen.dart';

final authTokenProvider = StateProvider<String?>((ref) => null);

void main() {
  runApp(ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final router = GoRouter(
      initialLocation: '/', 
      routes: [
        GoRoute(path: '/', builder: (_, __) => LoginScreen()),
        GoRoute(path: '/login', builder: (_, __) => LoginScreen()),
        GoRoute(path: '/personas', builder: (_, __) => PersonasListScreen()),
        GoRoute(path: '/personas/nuevo', builder: (_, __) => PersonasFormScreen()),

        GoRoute(
          path: '/personas/editar/:tipoDocumento/:numeroDocumento',
          builder: (context, state) {
            final tipoDocumento = state.pathParameters['tipoDocumento']!;
            final numeroDocumento = state.pathParameters['numeroDocumento']!;
            return PersonasFormScreen(
              tipoDocumento: tipoDocumento,
              numeroDocumento: numeroDocumento,
            );
          },
        ),
      ],
      redirect: (context, state) {
        final token = ref.read(authTokenProvider);
        if (state.path != '/login' && (token == null || token.isEmpty)) {
          return '/login';
        }
        return null;
      },
    );

    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: 'Clinica App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
