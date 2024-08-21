import 'package:flutter/material.dart';
import 'package:notes_app/screens/search_notes.dart';
import 'package:notes_app/utils/color_utils.dart';
import 'package:shimmer/shimmer.dart';

import '../database/database_services.dart';
import '../models/note_model.dart';
import '../utils/text_style_utils.dart';
import '../utils/time_convert_utils.dart';
import '../widgets/delete_note_dialog.dart';
import 'note_detail_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final DatabaseService _dbService = DatabaseService();
  late Future<List<Note>> _notesFuture;
  List<int> selectedNotes = [];
  List<Note> addedNotes = [];
  bool _isChecked = false;

  void _toggleCheckbox(bool? value) {
    setState(() {
      _isChecked = value ?? false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadNotes();
  }

  void _loadNotes() {
    _notesFuture = _dbService.getNotes();
  }

  @override
  Widget build(BuildContext context) {
    Widget emptyNoteScreen() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/images/addNote.png"),
          SizedBox(
            height: 5,
          ),
          Center(
              child: Text(
            "Create your first note",
            style: TextStyles.medium(fontSize: 20),
          ))
        ],
      );
    }

    Widget notesList(List<Note> notes) {
      return ListView.builder(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          itemCount: notes.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onLongPress: () {
                setState(() {
                  if (selectedNotes.contains(notes[index].id)) {
                    selectedNotes.remove(notes[index].id);
                  } else {
                    selectedNotes.add(notes[index].id ?? -1);
                  }
                });
              },
              onTap: () async {
                if (selectedNotes.isNotEmpty) {
                  setState(() {
                    if (selectedNotes.contains(notes[index].id)) {
                      selectedNotes.remove(notes[index].id);
                    } else {
                      selectedNotes.add(notes[index].id ?? -1);
                    }
                  });
                } else {
                  final result = await     Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NoteDetailPage(
                                note: notes[index],
                              )));

                  if (result == true) {

                    setState(() {
                      _loadNotes();
                    });
                  }
                }
              },
              child: Stack(children: [
                Container(
                  decoration: BoxDecoration(
                      color: notes[index].backgroundColor != null ? Color(notes[index].backgroundColor!) :ColorUtils.cardColors[index % 10],
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notes[index].title,
                                maxLines: 1,
                                style: TextStyles.medium(
                                    fontSize: 16.0, color: Colors.black),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                notes[index].description,
                                maxLines: 2,
                                style: TextStyles.regular(
                                    fontSize: 14.0,
                                    color: Colors.black.withOpacity(0.7)),
                              ),
                              SizedBox(height: 8.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(TimeConvertUtils.formatDateTime(notes[index].time),
                                      style: TextStyles.regular(
                                          fontSize: 12.0,
                                          color:
                                              Colors.black.withOpacity(0.4))),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  child: Visibility(
                    visible: selectedNotes.isEmpty ? false : true,
                    child: Checkbox(
                      activeColor: ColorUtils.primaryColor,
                      checkColor: Colors.white,
                      value: selectedNotes.contains(notes[index].id),
                      onChanged: _toggleCheckbox,
                    ),
                  ),
                ),

                (selectedNotes.isEmpty == true && notes[index].isPinned == true) ? Positioned(right: 10,top: 10,
                    child: Icon(Icons.push_pin, color: Colors.black, size: 20,)) : SizedBox()
              ]),
            );
          });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: selectedNotes.isEmpty
            ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Notes",
                    style: TextStyles.medium(fontSize: 25),
                  ),
                  Spacer(),
                  GestureDetector(onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SearchNotes()));
                  },
                    child: Container(
                        height: 40,
                        width: 40,
                        child: Center(
                          child: Icon(
                            Icons.search,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(10))),
                  )
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${selectedNotes.length} Selected",
                    style: TextStyles.medium(fontSize: 20),
                  ),
                  Spacer(),
                  GestureDetector(
                      child: Icon(
                        Icons.select_all,
                        color: Colors.black,
                        size: 25,
                      ),
                      onTap: () {
                        setState(() {
                          selectedNotes
                              .addAll(addedNotes.map((note) => note.id ?? -1));
                        });
                      }),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 25,
                    ),
                    onTap: () async {
                      _showDeleteDialog(context, selectedNotes, "");
                    },
                  ),
                ],
              ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // emptyNoteScreen()

              FutureBuilder<List<Note>>(
                future: _notesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: Container(height: MediaQuery.of(context).size.height * 0.7, width:  MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      itemCount: 7,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                      return Container(margin: EdgeInsets.only(bottom: 10),
                        height: 100,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white,),
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),);
                    })
                    ),);
                  }
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return emptyNoteScreen();
                  }

                  final notes = snapshot.data!;

                  addedNotes = notes;

                  return notesList(notes);
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteDetailPage(
                note: null,
                newNote: true,
              ),
            ),
          );
          if (result == true) {
            setState(() {
              _loadNotes();
            });
          }
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: ColorUtils.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 8, // Custom shadow
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat,
    );
  }

  void _showDeleteDialog(
      BuildContext context, List<int> noteIds, String noteTitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteNoteDialog(
          noteTitle: noteTitle,
          onDelete: () async {
            await DatabaseService().deleteNotes(noteIds);
            setState(() {
              _loadNotes();
              selectedNotes = selectedNotes
                  .where((note) => !noteIds.contains(note))
                  .toList();
            });
            Navigator.of(context).pop();
          },
          onCancel: () {
            setState(() {
              _loadNotes();
              selectedNotes = selectedNotes
                  .where((note) => !noteIds.contains(note))
                  .toList();
            });
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
