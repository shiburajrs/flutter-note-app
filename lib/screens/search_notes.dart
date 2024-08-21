import 'package:flutter/material.dart';
import '../database/database_services.dart';
import '../models/note_model.dart';
import '../utils/text_style_utils.dart';
import 'note_detail_page.dart';

class SearchNotes extends StatefulWidget {
  const SearchNotes({super.key});

  @override
  State<SearchNotes> createState() => _SearchNotesState();
}

class _SearchNotesState extends State<SearchNotes> {
  late Future<List<Note>> _notesFuture;
  final DatabaseService _dbService = DatabaseService();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _notesFuture = Future.value([]);
  }

  void _searchNotes(String query) {
    setState(() {
      _notesFuture = _dbService.searchNotes(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget searchResults(List<Note> notes) {
      return ListView.builder(
        itemCount: notes.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final note = notes[index];
          return GestureDetector(onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NoteDetailPage(
                  note: note,
                  newNote: false,
                ),
              ),
            );
          },
            child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
            color: Color(note.backgroundColor?? Colors.grey.value).withOpacity(0.3),),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(bottom: 10),
              child: Column(mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(note.title, style: TextStyles.medium(fontSize: 16)),
              SizedBox(height: 3,),
              Text(note.description, style: TextStyles.regular(fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
            ],),),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 45,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _searchNotes,
                style: TextStyles.regular(fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: TextStyles.regular(fontSize: 14),
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.search, color: Colors.grey), // Search icon
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Adjust vertical padding
                ),
              ),
            ),

            SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<Note>>(
                future: _notesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No notes found.', style: TextStyles.regular(fontSize: 14)));
                  }

                  final notes = snapshot.data!;
                  return searchResults(notes);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
