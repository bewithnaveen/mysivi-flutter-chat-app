import 'package:get/get.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/user/add_user_usecase.dart';
import '../../domain/usecases/user/get_users_usecase.dart';

enum UserViewState { initial, loading, loaded, error }

class UserController extends GetxController {
  final AddUserUseCase addUserUseCase;
  final GetUsersUseCase getUsersUseCase;

  UserController({
    required this.addUserUseCase,
    required this.getUsersUseCase,
  });

  final Rx<UserViewState> state = UserViewState.initial.obs;
  final RxList<User> users = <User>[].obs;
  final Rx<String?> errorMessage = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    loadUsers();
  }

  Future<void> loadUsers() async {
    state.value = UserViewState.loading;
    
    final result = await getUsersUseCase();
    
    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        state.value = UserViewState.error;
      },
      (usersList) {
        users.value = usersList;
        state.value = UserViewState.loaded;
      },
    );
  }

  Future<bool> addUser(String name) async {
    final result = await addUserUseCase(name);
    
    return result.fold(
      (failure) {
        errorMessage.value = failure.message;
        return false;
      },
      (user) {
        users.add(user);
        return true;
      },
    );
  }
}
