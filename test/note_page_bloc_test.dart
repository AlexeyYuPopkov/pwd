// import 'package:bloc_test/bloc_test.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:pwd/data/model/note_data.dart';
// import 'package:pwd/data/model/note_item_data.dart';
// import 'package:pwd/domain/gateway.dart';
// import 'package:pwd/domain/model/note.dart';
// import 'package:pwd/domain/model/note_item.dart';
// import 'package:pwd/view/note/bloc/note_page_bloc.dart';

// class MockGateway extends Mock implements Gateway {}

// void main() {
//   group('NotePageBloc', () {
//     late Gateway gateway;
//     late NotePageBloc bloc;
//     late Stream<Note> noteStream;

//     // final initialState = NotePageState.common(
//     //   data: NotePageData.initial(),
//     // );

//     // final emptyNote = initialState.data.note;
//     const notEmptyNote = NoteData(
//       id: '_1',
//       notes: [
//         NoteItemData(
//           id: '1',
//           title: NoteItemValueData(
//             style: NoteItemStyle.header,
//             text: '',
//           ),
//           description: NoteItemValueData(
//             style: NoteItemStyle.body,
//             text: '',
//           ),
//           content: NoteItemValueData(
//             style: NoteItemStyle.body,
//             text: '',
//           ),
//           date: null,
//         ),
//         NoteItemData(
//           id: '2',
//           title: NoteItemValueData(
//             style: NoteItemStyle.header,
//             text: '',
//           ),
//           description: NoteItemValueData(
//             style: NoteItemStyle.body,
//             text: '',
//           ),
//           content: NoteItemValueData(
//             style: NoteItemStyle.body,
//             text: '',
//           ),
//           date: null,
//         ),
//       ],
//     );

//     const updatedNoteItem = NoteItemData(
//       id: '1',
//       title: NoteItemValueData(
//         style: NoteItemStyle.header,
//         text: 'text',
//       ),
//       description: NoteItemValueData(
//         style: NoteItemStyle.body,
//         text: '',
//       ),
//       content: NoteItemValueData(
//         style: NoteItemStyle.body,
//         text: '',
//       ),
//       date: null,
//     );

//     const updatedNote = NoteData(
//       id: '_1',
//       notes: [
//         updatedNoteItem,
//         NoteItemData(
//           id: '2',
//           title: NoteItemValueData(
//             style: NoteItemStyle.header,
//             text: '',
//           ),
//           description: NoteItemValueData(
//             style: NoteItemStyle.body,
//             text: '',
//           ),
//           content: NoteItemValueData(
//             style: NoteItemStyle.body,
//             text: '',
//           ),
//           date: null,
//         ),
//       ],
//     );

//     // final stream = PublishSubject<Note>();

//     setUp(() {
//       gateway = MockGateway();
//       noteStream = gateway.noteStream();
//       bloc = NotePageBloc(
//         gateway: gateway,
//         noteStream: noteStream,
//       );
//     });

//     test('NotePageBloc - test initial state', () {
//       expect(
//         bloc.state,
//         NotePageState.common(
//           data: NotePageData.initial(),
//         ),
//       );
//     });

//     blocTest<NotePageBloc, NotePageState>(
//       'NotePageBloc - appear stream event',
//       build: () {
//         when(
//           () => gateway.noteStream(),
//         ).thenAnswer(
//           (_) => Stream.value(notEmptyNote),
//         );

//         return bloc;
//       },
//       act: (bloc) {
//         bloc.add(
//           const NotePageEvent.newData(note: notEmptyNote),
//         );
//       },
//       expect: () {
//         final data = bloc.state.data;
//         return [
//           NotePageState.common(
//             data: data.copyWith(note: notEmptyNote),
//           )
//         ];
//       },
//     );
//   });
// }
//   //   blocTest<NotePageBloc, NotePageState>(
//   //     'NotePageBloc - 1',
//   //     build: () {
//   //       when(
//   //         () => gateway.updateNote(updatedNote),
//   //       ).thenAnswer(
//   //         (_) {
//   //           noteStream.sink.add(updatedNote);
//   //           return Future.value();
//   //         },
//   //       );

//   //       return bloc;
//   //     },
//   //     act: (bloc) {
//   //       bloc.add(
//   //         const NotePageEvent.shouldUpdateNote(noteItem: updatedNoteItem),
//   //       );
//   //     },
//   //     expect: () {
//   //       final data = bloc.state.data;
//   //       return [
//   //         NotePageState.common(
//   //           data: data.copyWith(note: updatedNote),
//   //         )
//   //       ];
//   //     },
//   //   );
//   // });

//   // class ShouldUpdateNoteItemEvent extends NotePageEvent {
//   // final NoteItem noteItem;
//   // const ShouldUpdateNoteItemEvent({required this.noteItem});
// // }

//   //   void _onShouldUpdateNoteItemEvent(
//   //   ShouldUpdateNoteItemEvent event,
//   //   Emitter<NotePageState> emit,
//   // ) async {
//   //   emit(NotePageState.loadingState(data: state.data));

//   //   final oldValue = state.data.note;

//   //   final id = oldValue is EmptyNote ? const Uuid().v1() : oldValue.id;

//   //   var notes = [...oldValue.notes];

//   //   notes.removeWhere(
//   //     (e) => e.id == event.noteItem.id,
//   //   );

//   //   notes.add(
//   //     event.noteItem,
//   //   );

//   //   final noteImpl = NoteImpl(id: id, notes: notes);
//   //   await gateway.updateNote(noteImpl);
//   // }
// // }
