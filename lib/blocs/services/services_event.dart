import 'package:equatable/equatable.dart';

abstract class ServicesEvent extends Equatable {
  const ServicesEvent();

  @override
  List<Object?> get props => [];
}

class ServicesStatusRequested extends ServicesEvent {}

class ServiceConnectRequested extends ServicesEvent {
  final String service;

  const ServiceConnectRequested(this.service);

  @override
  List<Object> get props => [service];
}

class ServiceDisconnectRequested extends ServicesEvent {
  final String service;

  const ServiceDisconnectRequested(this.service);

  @override
  List<Object> get props => [service];
}

class ServiceAuthUrlRequested extends ServicesEvent {
  final String service;

  const ServiceAuthUrlRequested(this.service);

  @override
  List<Object> get props => [service];
}

class ServiceTokenSubmitted extends ServicesEvent {
  final String service;
  final String token;

  const ServiceTokenSubmitted({
    required this.service,
    required this.token,
  });

  @override
  List<Object> get props => [service, token];
}
