import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:grocery_app/features/auth/data/datasources/auth_datasource.dart';
import 'package:grocery_app/features/auth/data/repo/auth_repository_impl.dart';
import 'package:grocery_app/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:grocery_app/features/auth/presentation/provider/auth_provider.dart'
    as my_auth;
import 'package:grocery_app/features/location/presentation/provider/location_provider.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Firebase
  final firebaseAuth = FirebaseAuth.instance;
  final AuthDatasource authDatasource = AuthDatasource();

  // Repositories
  getIt.registerLazySingleton<AuthRepositoryImpl>(
    () => AuthRepositoryImpl(firebaseAuth, authDatasource),
  );

  // UseCases
  getIt.registerLazySingleton<AuthUseCases>(
    () => AuthUseCases(getIt<AuthRepositoryImpl>()),
  );

  // Providers
  getIt.registerFactory<my_auth.AuthProvider>(
    () => my_auth.AuthProvider(getIt<AuthUseCases>()),
  );

  getIt.registerFactory<LocationProvider>(() => LocationProvider());
}
