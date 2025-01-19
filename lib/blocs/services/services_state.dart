import 'package:equatable/equatable.dart';

abstract class ServicesState extends Equatable {
  const ServicesState();

  @override
  List<Object?> get props => [];
}

class ServicesInitial extends ServicesState {}

class ServicesLoading extends ServicesState {}

class ServicesStatusLoaded extends ServicesState {
  final List<Map<String, dynamic>> services;

  const ServicesStatusLoaded(this.services);

  @override
  List<Object?> get props => [services];
}

class ServiceAuthUrlLoaded extends ServicesState {
  final String url;
  final String service;

  const ServiceAuthUrlLoaded({
    required this.url,
    required this.service,
  });

  @override
  List<Object> get props => [url, service];
}

class ServiceConnected extends ServicesState {
  final String service;
  final Map<String, dynamic> data;

  const ServiceConnected({
    required this.service,
    required this.data,
  });

  @override
  List<Object> get props => [service, data];
}

class ServiceDisconnected extends ServicesState {
  final String service;

  const ServiceDisconnected(this.service);

  @override
  List<Object?> get props => [service];
}

class ServicesFailure extends ServicesState {
  final String error;

  const ServicesFailure(this.error);

  @override
  List<Object?> get props => [error];
}
