
part of 'template_bloc.dart';

abstract class TemplateEvent extends Equatable {
  const TemplateEvent();

  @override
  List<Object> get props => [];
}

class LoadTemplates extends TemplateEvent {}

class TemplatesUpdated extends TemplateEvent {
  final List<RoadmapModel> templates;

  const TemplatesUpdated(this.templates);

  @override
  List<Object> get props => [templates];
}

class ImportTemplate extends TemplateEvent {
  final RoadmapModel template;

  const ImportTemplate(this.template);

  @override
  List<Object> get props => [template];
}
