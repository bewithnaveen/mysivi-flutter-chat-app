import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/local/user_local_datasource.dart';
import '../../data/datasources/local/chat_local_datasource.dart';
import '../../data/datasources/remote/message_remote_datasource.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../data/repositories/message_repository_impl.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/repositories/message_repository.dart';
import '../../domain/usecases/user/add_user_usecase.dart';
import '../../domain/usecases/user/get_users_usecase.dart';
import '../../domain/usecases/chat/get_chat_history_usecase.dart';
import '../../domain/usecases/chat/send_message_usecase.dart';
import '../../domain/usecases/chat/get_chat_messages_usecase.dart';
import '../../domain/usecases/chat/update_chat_history_usecase.dart';
import '../../domain/usecases/chat/create_chat_history_usecase.dart';
import '../../domain/usecases/message/fetch_random_message_usecase.dart';
import '../../presentation/controllers/user_controller.dart';
import '../../presentation/controllers/chat_controller.dart';

final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  getIt.registerSingleton<http.Client>(http.Client());
  
  // Data Sources
  getIt.registerSingleton<UserLocalDataSource>(
    UserLocalDataSourceImpl(getIt()),
  );
  getIt.registerSingleton<ChatLocalDataSource>(
    ChatLocalDataSourceImpl(getIt()),
  );
  getIt.registerSingleton<MessageRemoteDataSource>(
    MessageRemoteDataSourceImpl(getIt()),
  );
  
  // Repositories
  getIt.registerSingleton<UserRepository>(
    UserRepositoryImpl(getIt()),
  );
  getIt.registerSingleton<ChatRepository>(
    ChatRepositoryImpl(getIt()),
  );
  getIt.registerSingleton<MessageRepository>(
    MessageRepositoryImpl(getIt()),
  );
  
  // Use Cases - Users
  getIt.registerSingleton<AddUserUseCase>(
    AddUserUseCase(getIt()),
  );
  getIt.registerSingleton<GetUsersUseCase>(
    GetUsersUseCase(getIt()),
  );
  
  // Use Cases - Chat
  getIt.registerSingleton<GetChatHistoryUseCase>(
    GetChatHistoryUseCase(getIt()),
  );
  getIt.registerSingleton<SendMessageUseCase>(
    SendMessageUseCase(getIt()),
  );
  getIt.registerSingleton<GetChatMessagesUseCase>(
    GetChatMessagesUseCase(getIt()),
  );
  getIt.registerSingleton<UpdateChatHistoryUseCase>(
    UpdateChatHistoryUseCase(getIt()),
  );
  getIt.registerSingleton<CreateChatHistoryUseCase>(
    CreateChatHistoryUseCase(getIt()),
  );
  
  // Use Cases - Messages
  getIt.registerSingleton<FetchRandomMessageUseCase>(
    FetchRandomMessageUseCase(getIt()),
  );
  
  // Controllers (GetX)
  getIt.registerFactory<UserController>(
    () => UserController(
      addUserUseCase: getIt(),
      getUsersUseCase: getIt(),
    ),
  );
  getIt.registerFactory<ChatController>(
    () => ChatController(
      getChatHistoryUseCase: getIt(),
      sendMessageUseCase: getIt(),
      getChatMessagesUseCase: getIt(),
      updateChatHistoryUseCase: getIt(),
      createChatHistoryUseCase: getIt(),
      fetchRandomMessageUseCase: getIt(),
    ),
  );
}
