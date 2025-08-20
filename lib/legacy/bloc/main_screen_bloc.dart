import 'package:flutter_bloc/flutter_bloc.dart';

abstract class MainScreenEvent {}

abstract class MainScreenState {}

class MainScreenInitial extends MainScreenState {}

class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {
  MainScreenBloc() : super(MainScreenInitial());
}
