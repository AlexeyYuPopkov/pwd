// import 'dart:isolate';
// import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
// import 'package:pwd/notes/domain/model/note_item_content.dart';
// import 'package:pwd/notes/domain/usecases/notes_provider_usecase.dart';
// import 'package:rxdart/rxdart.dart';

// import 'package:pwd/common/domain/pin_repository.dart';
// import 'package:pwd/common/domain/errors/app_error.dart';
// import 'package:pwd/common/domain/usecases/hash_usecase.dart';
// import 'package:pwd/notes/domain/model/note_item.dart';
// import 'package:pwd/notes/domain/notes_repository.dart';

// final class GitNotesProviderUsecase implements NotesProviderUsecase {
//   final NotesRepository repository;
//   final HashUsecase hashUsecase;
//   final PinRepository pinRepository;

//   GitNotesProviderUsecase({
//     required this.repository,
//     required this.hashUsecase,
//     required this.pinRepository,
//   });

//   late final _noteStream = BehaviorSubject<List<NoteItem>>();

//   @override
//   Stream<List<NoteItem>> get noteStream => _noteStream.asyncMap(
//         (items) async {
//           final pin = pinRepository.getPin();
//           final port = ReceivePort();

//           final isolate = await Isolate.spawn<List<dynamic>>(
//             _parse,
//             [
//               port.sendPort,
//               hashUsecase,
//               items,
//               pin,
//             ],
//           );

//           final result = await port.first as List<NoteItem>;
//           isolate.kill(priority: Isolate.immediate);

//           return result;
//         },
//       ).asBroadcastStream();

//   @override
//   Future<List<NoteItem>> readNotes({
//     required RemoteConfiguration configuration,
//   }) async {
//     try {
//       final notes = await repository.readNotes();
//       _noteStream.add(notes);
//       return notes;
//     } catch (e) {
//       throw NotesProviderError.read(parentError: e);
//     }
//   }

//   @override
//   Future<void> updateNoteItem(
//     NoteItem noteItem, {
//     required RemoteConfiguration configuration,
//   }) async {
//     try {
//       final pin = pinRepository.getPin();
//       final encoded = NoteItem.updatedItem(
//         id: noteItem.id,
//         title: hashUsecase.encode(noteItem.title, pin),
//         description: hashUsecase.encode(noteItem.description, pin),
//         content: NoteStringContent(
//           str: hashUsecase.encode(noteItem.content.str, pin),
//         ),
//       );
//       await repository.updateNote(encoded);
//       readNotes(configuration: configuration);
//     } catch (e) {
//       throw NotesProviderError.updated(parentError: e);
//     }
//   }

//   @override
//   Future<void> deleteNoteItem(
//     NoteItem noteItem, {
//     required RemoteConfiguration configuration,
//   }) async {
//     try {
//       final id = noteItem.id;
//       if (id.isNotEmpty) {
//         await repository.delete(id);
//         readNotes(configuration: configuration);
//       }
//     } catch (e) {
//       throw NotesProviderError.updated(parentError: e);
//     }
//   }

//   static void _parse(List parameters) {
//     SendPort sendPort = parameters[0];
//     final hashUsecase = parameters[1];
//     final items = parameters[2];
//     final pin = parameters[3];

//     NoteItem decryptedOrRaw(NoteItem item) {
//       final title = hashUsecase.tryDecode(item.title, pin);
//       final description = hashUsecase.tryDecode(item.description, pin);
//       final content = hashUsecase.tryDecode(item.content.str, pin);

//       final isDecrypted =
//           title != null && description != null && content != null;

//       return isDecrypted
//           ? NoteItem(
//               id: item.id,
//               title: title,
//               description: description,
//               content: NoteStringContent(str: content),
//               timestamp: item.timestamp,
//               isDecrypted: isDecrypted,
//             )
//           : item.copyWith();
//     }

//     final result = [
//       for (final item in items) decryptedOrRaw(item),
//     ];

//     sendPort.send(result);
//   }
// }

// // Errors
// abstract class NotesProviderError extends AppError {
//   const NotesProviderError({
//     required super.message,
//     super.parentError,
//   });

//   factory NotesProviderError.read({required Object? parentError}) =
//       ReadNotesError;

//   factory NotesProviderError.updated({required Object? parentError}) =
//       UpdatetNoteError;
// }

// class ReadNotesError extends NotesProviderError {
//   const ReadNotesError({required super.parentError}) : super(message: '');
// }

// class UpdatetNoteError extends NotesProviderError {
//   const UpdatetNoteError({required super.parentError}) : super(message: '');
// }
