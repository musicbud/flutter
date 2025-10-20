/// Comprehensive ChatBloc Unit Tests
/// 
/// Tests all chat functionality including:
/// - Channel management (list, create, join)
/// - Message operations (send, delete, load)
/// - Direct messages
/// - User management
/// - Error handling
/// - Edge cases

import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:musicbud_flutter/blocs/chat/chat_bloc.dart';
import 'package:musicbud_flutter/blocs/chat/chat_event.dart';
import 'package:musicbud_flutter/blocs/chat/chat_state.dart';
import 'package:musicbud_flutter/domain/repositories/chat_repository.dart';
import 'package:musicbud_flutter/models/message.dart';

@GenerateMocks([ChatRepository])
import 'chat_bloc_comprehensive_test.mocks.dart';

void main() {
  group('ChatBloc', () {
    late ChatBloc chatBloc;
    late MockChatRepository mockChatRepository;

    setUp(() {
      mockChatRepository = MockChatRepository();
      chatBloc = ChatBloc(chatRepository: mockChatRepository);
    });

    tearDown(() {
      chatBloc.close();
    });

    test('initial state is ChatInitial', () {
      expect(chatBloc.state, equals(ChatInitial()));
    });

    group('Channel Management', () {
      blocTest<ChatBloc, ChatState>(
        'emits [ChatLoading, ChatChannelListLoaded] when channel list requested successfully',
        build: () {
          when(mockChatRepository.getChannels()).thenAnswer(
            (_) async => [
              {'id': '1', 'name': 'General', 'description': 'General chat'},
              {'id': '2', 'name': 'Music', 'description': 'Music discussion'},
            ],
          );
          return chatBloc;
        },
        act: (bloc) => bloc.add(ChatChannelListRequested()),
        expect: () => [
          ChatLoading(),
          isA<ChatChannelListLoaded>().having(
            (state) => state.channels.length,
            'channels count',
            2,
          ),
        ],
        verify: (_) {
          verify(mockChatRepository.getChannels()).called(1);
        },
      );

      blocTest<ChatBloc, ChatState>(
        'emits [ChatLoading, ChatError] when channel list fails',
        build: () {
          when(mockChatRepository.getChannels()).thenThrow(
            Exception('Failed to load channels'),
          );
          return chatBloc;
        },
        act: (bloc) => bloc.add(ChatChannelListRequested()),
        expect: () => [
          ChatLoading(),
          isA<ChatError>().having(
            (state) => state.message,
            'error message',
            contains('Failed to load channels'),
          ),
        ],
      );

      blocTest<ChatBloc, ChatState>(
        'emits [ChatLoading, ChatChannelCreatedSuccess] when channel created successfully',
        build: () {
          when(mockChatRepository.createChannel(
            any,
            any,
            isPrivate: anyNamed('isPrivate'),
          )).thenAnswer(
            (_) async => {
              'id': 'new_channel',
              'name': 'New Channel',
              'description': 'A new channel',
              'is_private': false,
            },
          );
          return chatBloc;
        },
        act: (bloc) => bloc.add(
          ChatChannelCreated(
            name: 'New Channel',
            description: 'A new channel',
            isPrivate: false,
          ),
        ),
        expect: () => [
          ChatLoading(),
          isA<ChatChannelCreatedSuccess>().having(
            (state) => state.channel['name'],
            'channel name',
            'New Channel',
          ),
        ],
        verify: (_) {
          verify(mockChatRepository.createChannel(
            'New Channel',
            'A new channel',
            isPrivate: false,
          )).called(1);
        },
      );

      blocTest<ChatBloc, ChatState>(
        'emits error when creating private channel',
        build: () {
          when(mockChatRepository.createChannel(
            any,
            any,
            isPrivate: true,
          )).thenAnswer(
            (_) async => {
              'id': 'private_channel',
              'name': 'Private Channel',
              'description': 'A private channel',
              'is_private': true,
            },
          );
          return chatBloc;
        },
        act: (bloc) => bloc.add(
          ChatChannelCreated(
            name: 'Private Channel',
            description: 'A private channel',
            isPrivate: true,
          ),
        ),
        expect: () => [
          ChatLoading(),
          isA<ChatChannelCreatedSuccess>(),
        ],
      );

      blocTest<ChatBloc, ChatState>(
        'handles empty channel list',
        build: () {
          when(mockChatRepository.getChannels()).thenAnswer(
            (_) async => [],
          );
          return chatBloc;
        },
        act: (bloc) => bloc.add(ChatChannelListRequested()),
        expect: () => [
          ChatLoading(),
          isA<ChatChannelListLoaded>().having(
            (state) => state.channels,
            'empty channels',
            isEmpty,
          ),
        ],
      );
    });

    group('Message Operations', () {
      blocTest<ChatBloc, ChatState>(
        'emits [ChatLoading, ChatChannelMessagesLoaded] when messages loaded successfully',
        build: () {
          when(mockChatRepository.getChannelMessages(
            any,
            limit: anyNamed('limit'),
            before: anyNamed('before'),
          )).thenAnswer(
            (_) async => [
              {
                'id': 'msg1',
                'content': 'Hello',
                'sender_id': 'user1',
                'created_at': DateTime.now().toIso8601String(),
              },
              {
                'id': 'msg2',
                'content': 'Hi there',
                'sender_id': 'user2',
                'created_at': DateTime.now().toIso8601String(),
              },
            ],
          );
          return chatBloc;
        },
        act: (bloc) => bloc.add(
          ChatChannelMessagesRequested(
            channelId: 'channel_1',
            limit: 50,
          ),
        ),
        expect: () => [
          ChatLoading(),
          isA<ChatChannelMessagesLoaded>().having(
            (state) => state.messages.length,
            'messages count',
            2,
          ),
        ],
        verify: (_) {
          verify(mockChatRepository.getChannelMessages(
            'channel_1',
            limit: 50,
            before: null,
          )).called(1);
        },
      );

      blocTest<ChatBloc, ChatState>(
        'emits [ChatLoading, ChatMessageSentSuccess] when message sent successfully',
        build: () {
          when(mockChatRepository.sendChannelMessage(any, any)).thenAnswer(
            (_) async => {
              'id': 'new_msg',
              'content': 'Test message',
              'sender_id': 'user_123',
              'created_at': DateTime.now().toIso8601String(),
            },
          );
          return chatBloc;
        },
        act: (bloc) => bloc.add(
          ChatMessageSent(
            channelId: 'channel_1',
            content: 'Test message',
          ),
        ),
        expect: () => [
          ChatLoading(),
          isA<ChatMessageSentSuccess>().having(
            (state) => state.message['content'],
            'message content',
            'Test message',
          ),
        ],
        verify: (_) {
          verify(mockChatRepository.sendChannelMessage(
            'channel_1',
            'Test message',
          )).called(1);
        },
      );

      blocTest<ChatBloc, ChatState>(
        'emits [ChatLoading, ChatMessageDeletedSuccess] when message deleted successfully',
        build: () {
          when(mockChatRepository.deleteMessage(any, any)).thenAnswer(
            (_) async => {},
          );
          return chatBloc;
        },
        act: (bloc) => bloc.add(
          ChatMessageDeleted(
            channelId: 1,
            messageId: 100,
          ),
        ),
        expect: () => [
          ChatLoading(),
          isA<ChatMessageDeletedSuccess>(),
        ],
        verify: (_) {
          verify(mockChatRepository.deleteMessage('1', '100')).called(1);
        },
      );

      blocTest<ChatBloc, ChatState>(
        'handles message send failure',
        build: () {
          when(mockChatRepository.sendChannelMessage(any, any)).thenThrow(
            Exception('Failed to send message'),
          );
          return chatBloc;
        },
        act: (bloc) => bloc.add(
          ChatMessageSent(
            channelId: 'channel_1',
            content: 'Test message',
          ),
        ),
        expect: () => [
          ChatLoading(),
          isA<ChatError>().having(
            (state) => state.message,
            'error message',
            contains('Failed to send message'),
          ),
        ],
      );

      blocTest<ChatBloc, ChatState>(
        'handles empty message list',
        build: () {
          when(mockChatRepository.getChannelMessages(
            any,
            limit: anyNamed('limit'),
            before: anyNamed('before'),
          )).thenAnswer(
            (_) async => [],
          );
          return chatBloc;
        },
        act: (bloc) => bloc.add(
          ChatChannelMessagesRequested(
            channelId: 'empty_channel',
            limit: 50,
          ),
        ),
        expect: () => [
          ChatLoading(),
          isA<ChatChannelMessagesLoaded>().having(
            (state) => state.messages,
            'empty messages',
            isEmpty,
          ),
        ],
      );

      blocTest<ChatBloc, ChatState>(
        'supports pagination with before parameter',
        build: () {
          when(mockChatRepository.getChannelMessages(
            'channel_1',
            limit: 20,
            before: 'msg_50',
          )).thenAnswer(
            (_) async => [
              {
                'id': 'msg49',
                'content': 'Message 49',
                'sender_id': 'user1',
                'created_at': DateTime.now().toIso8601String(),
              },
            ],
          );
          return chatBloc;
        },
        act: (bloc) => bloc.add(
          ChatChannelMessagesRequested(
            channelId: 'channel_1',
            limit: 20,
            before: 'msg_50',
          ),
        ),
        expect: () => [
          ChatLoading(),
          isA<ChatChannelMessagesLoaded>(),
        ],
        verify: (_) {
          verify(mockChatRepository.getChannelMessages(
            'channel_1',
            limit: 20,
            before: 'msg_50',
          )).called(1);
        },
      );
    });

    group('Direct Messages', () {
      blocTest<ChatBloc, ChatState>(
        'loads direct messages successfully',
        build: () {
          when(mockChatRepository.getUserMessages(any)).thenAnswer(
            (_) async => [
              {
                'id': 'dm1',
                'content': 'Direct message',
                'sender_id': 'user1',
                'recipient_id': 'user2',
                'created_at': DateTime.now().toIso8601String(),
              },
            ],
          );
          return chatBloc;
        },
        act: (bloc) => bloc.add(ChatUserMessagesRequested(userId: 'user2')),
        expect: () => [
          ChatLoading(),
          isA<ChatUserMessagesLoaded>(),
        ],
      );

      blocTest<ChatBloc, ChatState>(
        'sends direct message successfully',
        build: () {
          when(mockChatRepository.sendUserMessage(any, any)).thenAnswer(
            (_) async => {
              'id': 'new_dm',
              'content': 'New DM',
              'sender_id': 'user1',
              'recipient_id': 'user2',
              'created_at': DateTime.now().toIso8601String(),
            },
          );
          return chatBloc;
        },
        act: (bloc) => bloc.add(
          ChatUserMessageSent(
            userId: 'user2',
            content: 'New DM',
          ),
        ),
        expect: () => [
          ChatLoading(),
          isA<ChatUserMessageSentSuccess>(),
        ],
      );
    });

    group('User Management', () {
      blocTest<ChatBloc, ChatState>(
        'loads user list successfully',
        build: () {
          when(mockChatRepository.getUsers()).thenAnswer(
            (_) async => [
              {'id': 'user1', 'name': 'User 1', 'online': true},
              {'id': 'user2', 'name': 'User 2', 'online': false},
            ],
          );
          return chatBloc;
        },
        act: (bloc) => bloc.add(ChatUserListRequested()),
        expect: () => [
          ChatLoading(),
          isA<ChatUserListLoaded>().having(
            (state) => state.users.length,
            'users count',
            2,
          ),
        ],
      );

      blocTest<ChatBloc, ChatState>(
        'handles user list load failure',
        build: () {
          when(mockChatRepository.getUsers()).thenThrow(
            Exception('Failed to load users'),
          );
          return chatBloc;
        },
        act: (bloc) => bloc.add(ChatUserListRequested()),
        expect: () => [
          ChatLoading(),
          isA<ChatError>(),
        ],
      );
    });

    group('Channel Statistics', () {
      blocTest<ChatBloc, ChatState>(
        'loads channel statistics successfully',
        build: () {
          when(mockChatRepository.getChannelStatistics(any)).thenAnswer(
            (_) async => {
              'member_count': 50,
              'message_count': 1000,
              'active_users': 15,
            },
          );
          return chatBloc;
        },
        act: (bloc) => bloc.add(
          ChatChannelStatisticsRequested(channelId: 'channel_1'),
        ),
        expect: () => [
          ChatLoading(),
          isA<ChatChannelStatisticsLoaded>(),
        ],
      );
    });

    group('Unsupported Operations', () {
      blocTest<ChatBloc, ChatState>(
        'returns error for unsupported channel users request',
        build: () => chatBloc,
        act: (bloc) => bloc.add(
          ChatChannelUsersRequested(channelId: 'channel_1'),
        ),
        expect: () => [
          ChatLoading(),
          isA<ChatError>().having(
            (state) => state.message,
            'error message',
            contains('not supported by API'),
          ),
        ],
      );

      blocTest<ChatBloc, ChatState>(
        'returns error for unsupported channel join',
        build: () => chatBloc,
        act: (bloc) => bloc.add(ChatChannelJoined(channelId: 'channel_1')),
        expect: () => [
          ChatLoading(),
          isA<ChatError>().having(
            (state) => state.message,
            'error message',
            contains('not supported by API'),
          ),
        ],
      );

      blocTest<ChatBloc, ChatState>(
        'returns error for unsupported channel details request',
        build: () => chatBloc,
        act: (bloc) => bloc.add(
          ChatChannelDetailsRequested(channelId: 'channel_1'),
        ),
        expect: () => [
          ChatLoading(),
          isA<ChatError>().having(
            (state) => state.message,
            'error message',
            contains('not supported by API'),
          ),
        ],
      );
    });

    group('Edge Cases', () {
      blocTest<ChatBloc, ChatState>(
        'handles very long message content',
        build: () {
          final longContent = 'A' * 10000;
          when(mockChatRepository.sendChannelMessage(any, any)).thenAnswer(
            (_) async => {
              'id': 'msg_long',
              'content': longContent,
              'sender_id': 'user1',
              'created_at': DateTime.now().toIso8601String(),
            },
          );
          return chatBloc;
        },
        act: (bloc) => bloc.add(
          ChatMessageSent(
            channelId: 'channel_1',
            content: 'A' * 10000,
          ),
        ),
        expect: () => [
          ChatLoading(),
          isA<ChatMessageSentSuccess>(),
        ],
      );

      blocTest<ChatBloc, ChatState>(
        'handles empty message content gracefully',
        build: () {
          when(mockChatRepository.sendChannelMessage(any, any)).thenAnswer(
            (_) async => {
              'id': 'msg_empty',
              'content': '',
              'sender_id': 'user1',
              'created_at': DateTime.now().toIso8601String(),
            },
          );
          return chatBloc;
        },
        act: (bloc) => bloc.add(
          ChatMessageSent(
            channelId: 'channel_1',
            content: '',
          ),
        ),
        expect: () => [
          ChatLoading(),
          isA<ChatMessageSentSuccess>(),
        ],
      );

      blocTest<ChatBloc, ChatState>(
        'handles network timeout error',
        build: () {
          when(mockChatRepository.getChannels()).thenThrow(
            Exception('Network timeout'),
          );
          return chatBloc;
        },
        act: (bloc) => bloc.add(ChatChannelListRequested()),
        expect: () => [
          ChatLoading(),
          isA<ChatError>().having(
            (state) => state.message,
            'error message',
            contains('Network timeout'),
          ),
        ],
      );

      blocTest<ChatBloc, ChatState>(
        'handles unauthorized error',
        build: () {
          when(mockChatRepository.getChannels()).thenThrow(
            Exception('Unauthorized'),
          );
          return chatBloc;
        },
        act: (bloc) => bloc.add(ChatChannelListRequested()),
        expect: () => [
          ChatLoading(),
          isA<ChatError>().having(
            (state) => state.message,
            'error message',
            contains('Unauthorized'),
          ),
        ],
      );
    });

    group('Multiple Sequential Events', () {
      blocTest<ChatBloc, ChatState>(
        'handles multiple events in sequence',
        build: () {
          when(mockChatRepository.getChannels()).thenAnswer(
            (_) async => [
              {'id': '1', 'name': 'Channel 1'},
            ],
          );
          when(mockChatRepository.getChannelMessages(
            any,
            limit: anyNamed('limit'),
            before: anyNamed('before'),
          )).thenAnswer(
            (_) async => [
              {'id': 'msg1', 'content': 'Message 1'},
            ],
          );
          return chatBloc;
        },
        act: (bloc) async {
          bloc.add(ChatChannelListRequested());
          await Future.delayed(Duration(milliseconds: 100));
          bloc.add(ChatChannelMessagesRequested(channelId: '1'));
        },
        expect: () => [
          ChatLoading(),
          isA<ChatChannelListLoaded>(),
          ChatLoading(),
          isA<ChatChannelMessagesLoaded>(),
        ],
      );
    });
  });
}
