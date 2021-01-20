import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_stream_product/models/note.dart';
import 'package:flutter_stream_product/contracts/disposable.dart';

class NoteBloc implements Disposable {
  List<Note> notes;
  final StreamController<List<Note>> _notesController =
      StreamController<List<Note>>();
  Stream<List<Note>> get notesStream => _notesController.stream;
  StreamSink<List<Note>> get notesSink => _notesController.sink;

  final StreamController<Note> _notecontroller = StreamController();
  StreamSink<Note> get addNewNote => _notecontroller.sink;
  final StreamController<Note> _removenotecontroller = StreamController();
  StreamSink<Note> get removeNote => _removenotecontroller.sink;
  NoteBloc() {
    notes = [];
    _notesController.add(notes);
    _notecontroller.stream.listen(_addNote);
    _removenotecontroller.stream.listen(_removeNote);
  }
  void _addNote(Note note) {
    notes.add(note);
    notesSink.add(notes);
  }

  void _removeNote(Note note) {
    notes.remove(note);
    notesSink.add(notes);
  }

  @override
  void dispose() {
    _notesController.close();
    _notecontroller.close();
    _removenotecontroller.close();
  }
}
