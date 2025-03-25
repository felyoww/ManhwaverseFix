import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manhwaverse',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
      ),
      home: const MyHomePage(title: 'Manhwaverse'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Map<String, dynamic>> _readingList = [];

  void _addBook(String title, String genre, String description, double rating, String imageUrl) {
    setState(() {
      _readingList.add({
        'title': title,
        'genre': genre,
        'description': description,
        'rating': rating,
        'imageUrl': imageUrl,
      });
    });
  }

  void _editBook(int index, String newTitle, String newGenre, String newDescription, double newRating, String newImageUrl) {
    setState(() {
      _readingList[index] = {
        'title': newTitle,
        'genre': newGenre,
        'description': newDescription,
        'rating': newRating,
        'imageUrl': newImageUrl,
      };
    });
  }

  void _deleteBook(int index) {
    setState(() {
      _readingList.removeAt(index);
    });
  }


  void _showActionsSheet(int index, Map<String, dynamic> book) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  _showEditBookDialog(index, book);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  _deleteBook(index);
                },
              ),
              ListTile(
                leading: const Icon(Icons.read_more, color: Colors.blue),
                title: const Text('Read More'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookDetailsPage(book: book)),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBookCard(int index, Map<String, dynamic> book) {
    return SizedBox(
      height: 350,
      child: Container(
        margin: const EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Image.network(
                    book['imageUrl'],
                    width: double.infinity,
                    height: 170, // Fixed image height
                    fit: BoxFit.cover,
                  ),
                ),
                // Book details section
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book['title'],
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Genre: ${book['genre']}',
                        style: const TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                      Text(
                        'Rating: ${book['rating']} ⭐',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        book['description'].length > 30
                            ? '${book['description'].substring(0, 30)}...'
                            : book['description'],
                        style: const TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // "More" button placed at the bottom right of the card
            Positioned(
              bottom: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () => _showActionsSheet(index, book),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build rows with two cards per row.
  Widget _buildBookRows() {
    int rowCount = (_readingList.length / 2).ceil();
    return ListView.builder(
      itemCount: rowCount,
      itemBuilder: (context, rowIndex) {
        int firstIndex = rowIndex * 2;
        int secondIndex = firstIndex + 1;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildBookCard(firstIndex, _readingList[firstIndex]),
            ),
            if (secondIndex < _readingList.length)
              Expanded(
                child: _buildBookCard(secondIndex, _readingList[secondIndex]),
              )
            else
              const Expanded(child: SizedBox()),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _readingList.isEmpty
            ? const Center(child: Text('No books added yet.'))
            : _buildBookRows(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddBookDialog,
        tooltip: 'Add Manhwa',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddBookDialog() {
    TextEditingController titleController = TextEditingController();
    TextEditingController genreController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController ratingController = TextEditingController();
    TextEditingController imageUrlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Book'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title')),
                TextField(
                    controller: genreController,
                    decoration: const InputDecoration(labelText: 'Genre')),
                TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Description')),
                TextField(
                  controller: ratingController,
                  decoration: const InputDecoration(labelText: 'Rating'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                    controller: imageUrlController,
                    decoration: const InputDecoration(labelText: 'Image URL')),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                _addBook(
                  titleController.text,
                  genreController.text,
                  descriptionController.text,
                  double.parse(ratingController.text),
                  imageUrlController.text,
                );
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditBookDialog(int index, Map<String, dynamic> book) {
    TextEditingController titleController =
    TextEditingController(text: book['title']);
    TextEditingController genreController =
    TextEditingController(text: book['genre']);
    TextEditingController descriptionController =
    TextEditingController(text: book['description']);
    TextEditingController ratingController =
    TextEditingController(text: book['rating'].toString());
    TextEditingController imageUrlController =
    TextEditingController(text: book['imageUrl']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Manhwa'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title')),
                TextField(
                    controller: genreController,
                    decoration: const InputDecoration(labelText: 'Genre')),
                TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Description')),
                TextField(
                  controller: ratingController,
                  decoration: const InputDecoration(labelText: 'Rating'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                    controller: imageUrlController,
                    decoration: const InputDecoration(labelText: 'Image URL')),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                _editBook(
                  index,
                  titleController.text,
                  genreController.text,
                  descriptionController.text,
                  double.parse(ratingController.text),
                  imageUrlController.text,
                );
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

class BookDetailsPage extends StatelessWidget {
  final Map<String, dynamic> book;

  const BookDetailsPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Back icon is automatically provided when using Navigator.push
        title: Text(book['title']),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    book['imageUrl'],
                    width: 250,
                    height: 350,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                book['title'],
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Genre: ${book['genre']}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54),
              ),
              const SizedBox(height: 8),
              Text(
                'Rating: ${book['rating']} ⭐',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              const SizedBox(height: 16),
              const Text(
                'Description:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                book['description'],
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
