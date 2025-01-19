import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/chat_home/chat_home_bloc.dart';
import '../../blocs/chat_home/chat_home_event.dart';
import '../../blocs/chat_home/chat_home_state.dart';
import '../widgets/loading_indicator.dart';
import 'channel_list_page.dart';
import 'user_list_page.dart';
import 'login_page.dart';

class ChatHomePage extends StatefulWidget {
  final String currentUsername;

  const ChatHomePage({
    Key? key,
    required this.currentUsername,
  }) : super(key: key);

  @override
  _ChatHomePageState createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatHomeBloc, ChatHomeState>(
      listener: (context, state) {
        if (state is ChatHomeFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.error}')),
          );
        }
      },
      builder: (context, state) {
        if (state is ChatHomeLoading) {
          return const Scaffold(
            body: Center(child: LoadingIndicator()),
          );
        }

        if (state is ChatHomeLoaded) {
          if (!state.isAuthenticated) {
            return const Scaffold(
              body: Center(
                child: Text('Please log in to access chat features'),
              ),
            );
          }

          return DefaultTabController(
            length: 2,
            initialIndex: state.currentTabIndex,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Chat'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      context
                          .read<ChatHomeBloc>()
                          .add(ChatHomeRefreshRequested());
                    },
                  ),
                ],
                bottom: TabBar(
                  onTap: (index) {
                    context.read<ChatHomeBloc>().add(ChatHomeTabChanged(index));
                  },
                  tabs: const [
                    Tab(text: 'Users'),
                    Tab(text: 'Channels'),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  UserListPage(currentUsername: state.username),
                  ChannelListPage(currentUsername: state.username),
                ],
              ),
            ),
          );
        }

        return const Scaffold(
          body: Center(
            child: Text('Something went wrong'),
          ),
        );
      },
    );
  }
}
