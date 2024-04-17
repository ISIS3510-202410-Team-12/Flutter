import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unischedule/models/models.dart';
import 'package:unischedule/repositories/repositories.dart';
import 'package:unischedule/services/network/friends_api_service.dart';

// Define el proveedor del servicio API
final friendsApiServiceProvider = Provider<FriendsApiService>((ref) {
  return FriendsApiService();
});

// Define el proveedor del repositorio
final friendsRepositoryProvider = Provider<FriendsRepository>((ref) {
  return FriendsRepository(ref.read(friendsApiServiceProvider));
});

// Define el proveedor para obtener amigos
final friendsProvider = FutureProvider.family<List<Friend>, String>((ref, userId) {
  final repository = ref.read(friendsRepositoryProvider);
  final searchQuery = ref.watch(friendsSearchQueryProvider);
  return repository.getFriends(userId, searchQuery);
});

// Proveedor para controlar el estado de la consulta de búsqueda
final friendsSearchQueryProvider = StateProvider<String>((ref) => "");
