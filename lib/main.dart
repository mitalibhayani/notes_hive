import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox<Note>('notes');

  runApp(MyApp(
  ));
}

@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String content;

  Note({
    required this.title,
    required this.content,
  });
}

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final int typeId = 0;

  @override
  Note read(BinaryReader reader) {
    return Note(
      title: reader.readString(),
      content: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer.writeString(obj.title);
    writer.writeString(obj.content);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hive Note',
      color: Colors.black,
      // theme: ThemeData(

      // primarySwatch: Colors.blue,
      //),
      home: NoteList(),
    );
  }
}

class NoteList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey.shade900,
      body: ValueListenableBuilder<Box<Note>>(
        valueListenable: Hive.box<Note>('notes').listenable(),
        builder: (context, box, _) {
          return GridView.builder(itemCount: box.length,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 6,crossAxisSpacing: 6),
              itemBuilder: (context, index) {
                final note= box.getAt(index)!;
                SizedBox(height: 40,);

                return Container(
                  margin: EdgeInsets.only(top: 20),
                  height: 100,
                  width: 100,
                  alignment: Alignment.center,

                  decoration: BoxDecoration(border: Border.all(width: 1,color: Colors.white),borderRadius: BorderRadius.circular(15)),
                  child: Column(
                   children: [
                     Container(
                       margin: EdgeInsets.all(10),
                       child: Text(note.title,style: TextStyle(color: Colors.white,fontSize: 17),),
                       alignment: Alignment.center,

                     ),
                     Container(
                       // margin: EdgeInsets.all(10),
                       child: Text(note.content,style: TextStyle(color: Colors.white,fontSize: 17),),
                       alignment: Alignment.center,
                     ),
                     Row(mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                        IconButton(onPressed: () {
                          box.deleteAt(index);
                        }, icon: Icon(Icons.delete,color: Colors.white)),
                         IconButton(onPressed: () {
                           Navigator.push(context, MaterialPageRoute(builder: (context) {
                             return EditNoteScreen(note: note);
                             // return edit();
                           },));
                         }, icon: Icon(Icons.edit,color: Colors.white))
                       ],
                     )
                   ],
                 ),
                );
              },);
          },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddNoteScreen()),
          );
        },
        child: Icon(Icons.add,color: Colors.black,),
      ),
    );
  }
}

class AddNoteScreen extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Note'),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.grey.shade900,
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: 'Title',border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: contentController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: 'Content',border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  maxLines: null,
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    final title = titleController.text.trim();
                    final content = contentController.text.trim();
                    if (title.isNotEmpty && content.isNotEmpty) {
                      final noteBox = Hive.box<Note>('notes');
                      noteBox.add(Note(
                        title: title,
                        content: content,
                      ));
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Save Data '),
                ),
              ],
            ),
          ),
        );
    }
}

class EditNoteScreen extends StatefulWidget {
  final Note note;
  const EditNoteScreen({required this.note});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey.shade900,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: 'Content',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              maxLines: null,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final title = _titleController.text.trim();
                final content = _contentController.text.trim();
                if (title.isNotEmpty && content.isNotEmpty) {
                  final noteBox = Hive.box<Note>('notes');
                  noteBox.putAt(
                    noteBox.values.toList().indexOf(widget.note),
                    Note(
                      title: title,
                      content: content,
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}


