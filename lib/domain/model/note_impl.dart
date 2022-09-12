// import 'package:pwd/domain/model/note.dart';
// import 'package:pwd/domain/model/note_item.dart';

// class NoteImpl implements Note {
//   final Map<String, NoteItem> data;

//   const NoteImpl({required this.data});

//   Note copyWithInsertion(NoteItem item) => NoteImpl(
//         data: data
//           ..addEntries(
//             [MapEntry(item.id, item)],
//           ),
//       );

//   Note copyWithDeletion(String itemId) => NoteImpl(
//         data: data..remove(itemId),
//       );

//   @override
//   List<NoteItem> get notes => throw UnimplementedError();
// }
