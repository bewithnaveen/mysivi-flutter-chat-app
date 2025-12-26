import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../domain/entities/chat_history.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/chat/get_chat_history_usecase.dart';
import '../../domain/usecases/chat/get_chat_messages_usecase.dart';
import '../../domain/usecases/chat/send_message_usecase.dart';
import '../../domain/usecases/chat/update_chat_history_usecase.dart';
import '../../domain/usecases/chat/create_chat_history_usecase.dart';
import '../../domain/usecases/message/fetch_random_message_usecase.dart';

enum ChatViewState { initial, loading, loaded, error, sendingMessage }

class ChatController extends GetxController {
  final GetChatHistoryUseCase getChatHistoryUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final GetChatMessagesUseCase getChatMessagesUseCase;
  final UpdateChatHistoryUseCase updateChatHistoryUseCase;
  final CreateChatHistoryUseCase createChatHistoryUseCase;
  final FetchRandomMessageUseCase fetchRandomMessageUseCase;

  ChatController({
    required this.getChatHistoryUseCase,
    required this.sendMessageUseCase,
    required this.getChatMessagesUseCase,
    required this.updateChatHistoryUseCase,
    required this.createChatHistoryUseCase,
    required this.fetchRandomMessageUseCase,
  });

  final Rx<ChatViewState> state = ChatViewState.initial.obs;
  final RxList<ChatHistory> chatHistory = <ChatHistory>[].obs;
  final RxList<Message> currentChatMessages = <Message>[].obs;
  final Rx<String?> errorMessage = Rx<String?>(null);
  final Rx<String?> currentChatId = Rx<String?>(null);
  final Rx<User?> currentChatUser = Rx<User?>(null);

  Future<void> loadChatHistory() async {
    state.value = ChatViewState.loading;
    
    final result = await getChatHistoryUseCase();
    
    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        state.value = ChatViewState.error;
      },
      (history) {
        chatHistory.value = history;
        state.value = ChatViewState.loaded;
      },
    );
  }

  Future<void> loadChatMessages(String chatId, User user) async {
    currentChatId.value = chatId;
    currentChatUser.value = user;
    state.value = ChatViewState.loading;
    
    final result = await getChatMessagesUseCase(chatId);
    
    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        state.value = ChatViewState.error;
      },
      (messages) {
        currentChatMessages.value = messages;
        state.value = ChatViewState.loaded;
        
        if (messages.isNotEmpty) {
          _ensureChatHistoryExists();
        }
      },
    );
  }
  
  Future<void> _ensureChatHistoryExists() async {
    if (currentChatId.value == null || currentChatUser.value == null) return;
    
    final historyResult = await getChatHistoryUseCase();
    historyResult.fold(
      (failure) => null,
      (history) {
        final exists = history.any((chat) => chat.id == currentChatId.value);
        if (!exists && currentChatMessages.isNotEmpty) {
          final lastMsg = currentChatMessages.last;
          updateChatHistoryUseCase(
            chatId: currentChatId.value!,
            lastMessage: lastMsg.text,
            lastMessageTime: lastMsg.timestamp,
          );
        }
      },
    );
  }

  Future<bool> sendMessage(String text) async {
    if (currentChatId.value == null || currentChatUser.value == null) return false;
    
    state.value = ChatViewState.sendingMessage;
    
    final result = await sendMessageUseCase(
      chatId: currentChatId.value!,
      userId: currentChatUser.value!.id,
      text: text,
    );
    
    return await result.fold(
      (failure) async {
        errorMessage.value = failure.message;
        state.value = ChatViewState.error;
        return false;
      },
      (message) async {
        currentChatMessages.add(message);
        
        await _createOrUpdateChatHistory(text, message.timestamp);
        
        state.value = ChatViewState.loaded;
        
        Future.delayed(const Duration(milliseconds: 1500), () {
          _fetchAndSendReceiverMessage();
        });
        
        return true;
      },
    );
  }
  
  Future<void> _createOrUpdateChatHistory(String lastMessage, DateTime timestamp) async {
    if (currentChatId.value == null || currentChatUser.value == null) return;
    
    final historyResult = await getChatHistoryUseCase();
    await historyResult.fold(
      (failure) async => null,
      (history) async {
        final exists = history.any((chat) => chat.id == currentChatId.value);
        
        if (!exists) {
          await createChatHistoryUseCase(
            chatId: currentChatId.value!,
            user: currentChatUser.value!,
            lastMessage: lastMessage,
            lastMessageTime: timestamp,
          );
        } else {
          await updateChatHistoryUseCase(
            chatId: currentChatId.value!,
            lastMessage: lastMessage,
            lastMessageTime: timestamp,
          );
        }
      },
    );
    
    await loadChatHistory();
  }

  Future<void> _fetchAndSendReceiverMessage() async {
    if (currentChatId.value == null || currentChatUser.value == null) return;
    
    final result = await fetchRandomMessageUseCase();
    
    await result.fold(
      (failure) async {
        debugPrint('Failed to fetch receiver message: ${failure.message}');
      },
      (messageText) async {
        final receiverMessage = Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: messageText,
          type: MessageType.receiver,
          timestamp: DateTime.now(),
          userId: currentChatUser.value!.id,
          chatId: currentChatId.value!,
        );
        
        currentChatMessages.add(receiverMessage);
        
        await _createOrUpdateChatHistory(messageText, receiverMessage.timestamp);
      },
    );
  }

  void clearCurrentChat() {
    currentChatId.value = null;
    currentChatUser.value = null;
    currentChatMessages.clear();
  }
}
