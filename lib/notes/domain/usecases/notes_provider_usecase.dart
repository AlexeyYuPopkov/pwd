import 'dart:isolate';
import 'package:rxdart/rxdart.dart';

import 'package:pwd/common/domain/pin_repository.dart';
import 'package:pwd/common/domain/errors/app_error.dart';
import 'package:pwd/common/domain/usecases/hash_usecase.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:pwd/notes/domain/notes_repository.dart';

abstract class NotesProviderUsecase {
  Stream<List<NoteItem>> get noteStream;

  List<NoteItem> get notes;

  Future<void> readNotes();

  Future<void> updateNoteItem(NoteItem noteItem);

  Future<void> deleteNoteItem(NoteItem noteItem);
}

class NotesProviderUsecaseImpl implements NotesProviderUsecase {
  final NotesRepository repository;
  final HashUsecase hashUsecase;
  final PinRepository pinRepository;

  NotesProviderUsecaseImpl({
    required this.repository,
    required this.hashUsecase,
    required this.pinRepository,
  });

  late final _noteStream = BehaviorSubject<List<NoteItem>>();

  @override
  Stream<List<NoteItem>> get noteStream => _noteStream
      .asyncMap(
        (items) async {
          final pin = pinRepository.getPin();
          final port = ReceivePort();

          final isolate = await Isolate.spawn<List<dynamic>>(
            _parse,
            [
              port.sendPort,
              hashUsecase,
              items,
              pin,
            ],
          );

          final result = await port.first as List<NoteItem>;
          isolate.kill(priority: Isolate.immediate);

          return result;
        },
      )
      .doOnData(
        (e) => notes = e,
      )
      .asBroadcastStream();

  @override
  List<NoteItem> notes = [];

  @override
  Future<void> readNotes() async {
    try {
      final notes = await repository.readNotes();
      _noteStream.add(notes);
    } catch (e) {
      throw NotesProviderError.read(parentError: e);
    }
  }

  @override
  Future<void> updateNoteItem(NoteItem noteItem) async {
    try {
      final pin = pinRepository.getPin();
      final encoded = NoteItem.updatedItem(
        id: noteItem.id,
        title: hashUsecase.encode(noteItem.title, pin),
        description: hashUsecase.encode(noteItem.description, pin),
        content: hashUsecase.encode(noteItem.content, pin),
      );
      await repository.updateNote(encoded);
      readNotes();
    } catch (e) {
      throw NotesProviderError.updated(parentError: e);
    }
  }

  @override
  Future<void> deleteNoteItem(NoteItem noteItem) async {
    try {
      final id = noteItem.id;
      if (id.isNotEmpty) {
        await repository.delete(id);
        readNotes();
      }
    } catch (e) {
      throw NotesProviderError.updated(parentError: e);
    }
  }

  static void _parse(List parameters) {
    SendPort sendPort = parameters[0];
    final hashUsecase = parameters[1];
    final items = parameters[2];
    final pin = parameters[3];

    NoteItem decryptedOrRaw(NoteItem item) {
      final title = hashUsecase.tryDecode(item.title, pin);
      final description = hashUsecase.tryDecode(item.description, pin);
      final content = hashUsecase.tryDecode(item.content, pin);

      if (title == null || description == null || content == null) {
        return NoteItem(
          id: item.id,
          title: item.title,
          description: item.description,
          content: item.content,
          timestamp: item.timestamp,
        );
      } else {
        return NoteItem.decrypted(
          id: item.id,
          title: title,
          description: description,
          content: content,
          timestamp: item.timestamp,
        );
      }
    }

    final result = [
      for (final item in items) decryptedOrRaw(item),
    ];

    sendPort.send(result);
  }
}

// Errors
abstract class NotesProviderError extends AppError {
  const NotesProviderError({
    required super.message,
    super.parentError,
  });

  factory NotesProviderError.read({required Object? parentError}) =
      ReadNotesError;

  factory NotesProviderError.updated({required Object? parentError}) =
      UpdatetNoteError;
}

class ReadNotesError extends NotesProviderError {
  const ReadNotesError({required super.parentError}) : super(message: '');
}

class UpdatetNoteError extends NotesProviderError {
  const UpdatetNoteError({required super.parentError}) : super(message: '');
}
