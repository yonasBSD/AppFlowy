import 'package:appflowy/mobile/application/page_style/document_page_style_bloc.dart';
import 'package:appflowy/plugins/document/application/document_listener.dart';
import 'package:appflowy/plugins/document/presentation/editor_plugins/plugins.dart';
import 'package:appflowy/workspace/application/view/prelude.dart';
import 'package:appflowy/workspace/application/view/view_ext.dart';
import 'package:appflowy_backend/protobuf/flowy-folder/view.pb.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../shared/icon_emoji_picker/flowy_icon_emoji_picker.dart';

part 'recent_view_bloc.freezed.dart';

class RecentViewBloc extends Bloc<RecentViewEvent, RecentViewState> {
  RecentViewBloc({
    required this.view,
  })  : _documentListener = DocumentListener(id: view.id),
        _viewListener = ViewListener(viewId: view.id),
        super(RecentViewState.initial()) {
    on<RecentViewEvent>(
      (event, emit) async {
        await event.when(
          initial: () async {
            _documentListener.start(
              onDocEventUpdate: (docEvent) async {
                if (state.coverTypeV2 != null) {
                  return;
                }
                final (coverType, coverValue) = await getCoverV1();
                add(
                  RecentViewEvent.updateCover(
                    coverType,
                    null,
                    coverValue,
                  ),
                );
              },
            );
            _viewListener.start(
              onViewUpdated: (view) {
                add(
                  RecentViewEvent.updateNameOrIcon(
                    view.name,
                    view.icon.toEmojiIconData(),
                  ),
                );

                if (view.extra.isNotEmpty) {
                  final cover = view.cover;
                  add(
                    RecentViewEvent.updateCover(
                      CoverType.none,
                      cover?.type,
                      cover?.value,
                    ),
                  );
                }
              },
            );

            // only document supports the cover
            if (view.layout != ViewLayoutPB.Document) {
              emit(
                state.copyWith(
                  name: view.name,
                  icon: view.icon.toEmojiIconData(),
                ),
              );
            }

            final cover = getCoverV2();

            if (cover != null) {
              emit(
                state.copyWith(
                  name: view.name,
                  icon: view.icon.toEmojiIconData(),
                  coverTypeV2: cover.type,
                  coverValue: cover.value,
                ),
              );
            } else {
              final (coverTypeV1, coverValue) = await getCoverV1();
              emit(
                state.copyWith(
                  name: view.name,
                  icon: view.icon.toEmojiIconData(),
                  coverTypeV1: coverTypeV1,
                  coverValue: coverValue,
                ),
              );
            }
          },
          updateNameOrIcon: (name, icon) {
            emit(
              state.copyWith(
                name: name,
                icon: icon,
              ),
            );
          },
          updateCover: (coverTypeV1, coverTypeV2, coverValue) {
            emit(
              state.copyWith(
                coverTypeV1: coverTypeV1,
                coverTypeV2: coverTypeV2,
                coverValue: coverValue,
              ),
            );
          },
        );
      },
    );
  }

  final ViewPB view;
  final DocumentListener _documentListener;
  final ViewListener _viewListener;

  PageStyleCover? getCoverV2() {
    return view.cover;
  }

  // for the version under 0.5.5
  Future<(CoverType, String?)> getCoverV1() async {
    return (CoverType.none, null);
  }

  @override
  Future<void> close() async {
    await _documentListener.stop();
    await _viewListener.stop();
    return super.close();
  }
}

@freezed
class RecentViewEvent with _$RecentViewEvent {
  const factory RecentViewEvent.initial() = Initial;

  const factory RecentViewEvent.updateCover(
    CoverType coverTypeV1,
    // for the version under 0.5.5, including 0.5.5
    PageStyleCoverImageType? coverTypeV2, // for the version above 0.5.5
    String? coverValue,
  ) = UpdateCover;

  const factory RecentViewEvent.updateNameOrIcon(
    String name,
    EmojiIconData icon,
  ) = UpdateNameOrIcon;
}

@freezed
class RecentViewState with _$RecentViewState {
  const factory RecentViewState({
    required String name,
    required EmojiIconData icon,
    @Default(CoverType.none) CoverType coverTypeV1,
    PageStyleCoverImageType? coverTypeV2,
    @Default(null) String? coverValue,
  }) = _RecentViewState;

  factory RecentViewState.initial() =>
      RecentViewState(name: '', icon: EmojiIconData.none());
}
