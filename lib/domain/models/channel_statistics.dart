import 'package:equatable/equatable.dart';

class ChannelStatistics extends Equatable {
  final int totalMessages;
  final int totalMembers;
  final int activeMembers;
  final int messagesLastDay;
  final int messagesLastWeek;
  final int messagesLastMonth;
  final Map<String, int> messagesByHour;
  final Map<String, int> messagesByDay;
  final Map<String, int> messagesByUser;

  const ChannelStatistics({
    required this.totalMessages,
    required this.totalMembers,
    required this.activeMembers,
    required this.messagesLastDay,
    required this.messagesLastWeek,
    required this.messagesLastMonth,
    required this.messagesByHour,
    required this.messagesByDay,
    required this.messagesByUser,
  });

  factory ChannelStatistics.fromJson(Map<String, dynamic> json) {
    return ChannelStatistics(
      totalMessages: json['totalMessages'] as int,
      totalMembers: json['totalMembers'] as int,
      activeMembers: json['activeMembers'] as int,
      messagesLastDay: json['messagesLastDay'] as int,
      messagesLastWeek: json['messagesLastWeek'] as int,
      messagesLastMonth: json['messagesLastMonth'] as int,
      messagesByHour: Map<String, int>.from(json['messagesByHour'] as Map),
      messagesByDay: Map<String, int>.from(json['messagesByDay'] as Map),
      messagesByUser: Map<String, int>.from(json['messagesByUser'] as Map),
    );
  }

  Map<String, dynamic> toJson() => {
        'totalMessages': totalMessages,
        'totalMembers': totalMembers,
        'activeMembers': activeMembers,
        'messagesLastDay': messagesLastDay,
        'messagesLastWeek': messagesLastWeek,
        'messagesLastMonth': messagesLastMonth,
        'messagesByHour': messagesByHour,
        'messagesByDay': messagesByDay,
        'messagesByUser': messagesByUser,
      };

  @override
  List<Object?> get props => [
        totalMessages,
        totalMembers,
        activeMembers,
        messagesLastDay,
        messagesLastWeek,
        messagesLastMonth,
        messagesByHour,
        messagesByDay,
        messagesByUser,
      ];
}
