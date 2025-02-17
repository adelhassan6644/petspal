import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zurex/components/loading_dialog.dart';
import 'package:zurex/navigation/custom_navigation.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_state.dart';

class ShareItemDetailsBloc extends Bloc<AppEvent, AppState> {
  ShareItemDetailsBloc() : super(Start()) {
    on<Click>(onClick);
  }

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    spinKitDialog();
    emit(Loading());
    String link = "https://ebrandblue_art.page.link/${event.arguments as int}";
    String shareLink = Uri.decodeFull(Uri.decodeComponent(link));
    CustomNavigator.pop();
    emit(Done());
    await Share.share(shareLink);
  }
}
