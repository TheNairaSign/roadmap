
part of 'template_bloc.dart';

abstract class TemplateState extends Equatable {
  const TemplateState();

  @override
  List<Object> get props => [];
}

class TemplateInitial extends TemplateState {}

class TemplateLoading extends TemplateState {}

class TemplateLoaded extends TemplateState {
  final List<RoadmapModel> templates;

  const TemplateLoaded(this.templates);

  @override
  List<Object> get props => [templates];
}

class TemplateError extends TemplateState {
  final String message;

  const TemplateError(this.message);

  @override
  List<Object> get props => [message];
}

class TemplateImporting extends TemplateState {}

class TemplateImported extends TemplateState {}
