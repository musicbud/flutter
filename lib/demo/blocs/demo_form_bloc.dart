import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class DemoFormEvent {}

class SubmitDemoForm extends DemoFormEvent {
  final String name;
  final String email;
  final String message;

  SubmitDemoForm({
    required this.name,
    required this.email,
    required this.message,
  });
}

// States
abstract class DemoFormState {}

class DemoFormInitial extends DemoFormState {}

class DemoFormLoading extends DemoFormState {}

class DemoFormSuccess extends DemoFormState {
  final String message;
  DemoFormSuccess({required this.message});
}

class DemoFormError extends DemoFormState {
  final String message;
  DemoFormError({required this.message});
}

// BLoC
class DemoFormBloc extends Bloc<DemoFormEvent, DemoFormState> {
  DemoFormBloc() : super(DemoFormInitial()) {
    on<SubmitDemoForm>(_onSubmitDemoForm);
  }

  Future<void> _onSubmitDemoForm(
    SubmitDemoForm event,
    Emitter<DemoFormState> emit,
  ) async {
    emit(DemoFormLoading());

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // Simulate random success/failure for demo purposes
    final random = DateTime.now().second % 3;
    
    if (random == 0) {
      emit(DemoFormError(
        message: 'Demo error: Network timeout. Try again!',
      ));
    } else {
      emit(DemoFormSuccess(
        message: 'Form submitted successfully! Name: ${event.name}',
      ));
    }
  }
}
