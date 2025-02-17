import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/app_storage_keys.dart';
import '../../../data/config/di.dart';
import '../model/language_model.dart';
import '../repo/language_repo.dart';

class LanguageBloc extends Bloc<AppEvent, AppState> {
  final LocalizationRepo repo;

  LanguageBloc({required this.repo}) : super(Start()) {
    updateSelectIndex(0);
    on<Init>(onInit);
    on<Update>(onUpdate);
  }

  static LanguageBloc get instance => sl<LanguageBloc>();

  final selectIndex = BehaviorSubject<int>();
  Function(int) get updateSelectIndex => selectIndex.sink.add;
  Stream<int> get selectIndexStream => selectIndex.stream.asBroadcastStream();

  Locale? selectLocale;

  List<LanguageModel> _languages = [];
  List<LanguageModel> get languages => _languages;

  bool _isLtr = false;
  bool get isLtr => _isLtr;

  Future<void> onUpdate(Update event, Emitter<AppState> emit) async {
    selectLocale = Locale(_languages[selectIndex.value].languageCode ?? "",
        _languages[selectIndex.value].countryCode ?? "");
    if (selectLocale!.languageCode == 'ar') {
      _isLtr = false;
    } else {
      _isLtr = true;
    }
    await repo.updateLanguage(selectLocale!);
    emit(Done());
  }

  Future<void> onInit(Init event, Emitter<AppState> emit) async {
    _languages = AppStorageKey.languages;
    selectLocale = await repo.loadLanguage();

    _isLtr = selectLocale!.languageCode == 'en';
    if (selectLocale!.languageCode == 'en') {
      updateSelectIndex(0);
    } else {
      updateSelectIndex(1);
    }
    emit(Done());
  }
}
