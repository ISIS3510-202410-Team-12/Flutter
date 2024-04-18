import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unischedule/models/models.dart';
import 'package:unischedule/constants/constants.dart';
import 'package:unischedule/services/services.dart';

part 'friends_repository.g.dart';

abstract class FriendsRepository {
  // TODO add here all use cases for friends
  Future<List<FriendModel>> fetchFriends();
}

class FriendsRepositoryImpl extends FriendsRepository {

  final DioApiService client;
  final HiveBoxService<FriendModel> boxService;
  final Ref ref;

  FriendsRepositoryImpl({
    required this.ref,
    required this.client,
    required this.boxService,
  });

  @override
  Future<List<FriendModel>> fetchFriends() async {
    List<FriendModel> friends = await client.getRequest("user/0MebgXs8fBYREjDKMlwq/friends") // TODO change endpoint
      .then((response) => response.map<FriendModel>((json) => FriendModel.fromJson(json)).toList())
      .catchError((error) => boxService.getAll());
    return friends;
  }
  // TODO add onDispose method to save the state of the friends
}

@riverpod
FriendsRepositoryImpl friendsRepository(FriendsRepositoryRef ref) {
  return FriendsRepositoryImpl(
    ref: ref,
    client: DioApiServiceFactory.getService(HTTPConstants.FRIENDS_BASE_URL),
    boxService: HiveBoxServiceFactory.getService(LocalStorageConstants.friendBox) as HiveBoxService<FriendModel>,
  );
}