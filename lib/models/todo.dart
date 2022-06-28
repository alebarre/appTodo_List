class Todo{

  Todo ({required this.title, required this.dateTime});

  Todo.fromJson(Map<String, dynamic> json):
        title = json['title'],
        dateTime = DateTime.parse(json['dateTime']);

  String title;
  DateTime dateTime;

  //Poe os dados do todo em formato JSON, dentro de uma lista com chave STRING e o dado DYNAMIC
  Map<String, dynamic> toJson(){
    return{
      'title': title,
      'dateTime': dateTime.toIso8601String()
    };
  }

}