class Todo {
  final int? done;
  final String? name;
  final String? description;

  const Todo({
    this.done,
    this.name = " ",
    this.description = "",
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'done': done,
      'name': name,
      'description': description,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Todo{done:$done,name: $name, age: $description}';
  }
}
