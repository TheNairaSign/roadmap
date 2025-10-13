
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:roadmap/models/roadmap_model.dart';
import 'package:roadmap/repositories/roadmap_repository.dart';

part 'template_event.dart';
part 'template_state.dart';

class TemplateBloc extends Bloc<TemplateEvent, TemplateState> {
  final RoadmapRepository _roadmapRepository;
  final String _userId;
  StreamSubscription? _templatesSubscription;

  TemplateBloc({
    required RoadmapRepository roadmapRepository,
    required String userId,
  })  : _roadmapRepository = roadmapRepository,
        _userId = userId,
        super(TemplateInitial()) {
    on<LoadTemplates>(_onLoadTemplates);
    on<TemplatesUpdated>(_onTemplatesUpdated);
    on<ImportTemplate>(_onImportTemplate);
  }

  void _onLoadTemplates(LoadTemplates event, Emitter<TemplateState> emit) {
    emit(TemplateLoading());
    _templatesSubscription?.cancel();
    _templatesSubscription = _roadmapRepository.getTemplates().listen(
          (templates) => add(TemplatesUpdated(templates)),
          onError: (error) => emit(TemplateError(error.toString())),
        );
  }

  void _onTemplatesUpdated(TemplatesUpdated event, Emitter<TemplateState> emit) {
    emit(TemplateLoaded(event.templates));
  }

  void _onImportTemplate(ImportTemplate event, Emitter<TemplateState> emit) async {
    emit(TemplateImporting());
    try {
      await _roadmapRepository.importTemplate(_userId, event.template);
      emit(TemplateImported());
    } catch (e) {
      emit(TemplateError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _templatesSubscription?.cancel();
    return super.close();
  }
}
