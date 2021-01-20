import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stream_product/blocs/note_bloc.dart';
import 'package:flutter_stream_product/models/note.dart';

class NotesList extends StatefulWidget {
  @override
  _NotesListState createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  NoteBloc noteBloc = NoteBloc();
  TextEditingController _textEditingController = TextEditingController();
  @override
  void dispose() {
    noteBloc.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: noteBloc.notesStream,
        builder: (BuildContext context, AsyncSnapshot snapShot) {
          switch (snapShot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapShot.hasError) {
                return Text("error");
              } else {
                List<Note> notes = snapShot.data;
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Flexible(
                        child: ListView.builder(
                            itemCount: notes.length,
                            itemBuilder: (context, position) {
                              return Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ListTile(
                                    title: Text(notes[position].content),
                                  ),
                                  Row(
                                    children: [
                                      RaisedButton(
                                        child: Text("RemoveNote"),
                                        onPressed: () {
                                          noteBloc.removeNote
                                              .add(notes[position]);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }),
                      ),
                      TextFormField(
                        controller: _textEditingController,
                      ),
                      RaisedButton(
                        child: Text("Add New"),
                        onPressed: () {
                          String content = _textEditingController.text;
                          Note note = Note(content);
                          noteBloc.addNewNote.add(note);
                        },
                      ),
                    ],
                  ),
                );
              }
          }
        });
  }
}
