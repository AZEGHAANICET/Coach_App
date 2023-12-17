class Session {
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;

  Session(this.name, this.description, this.startDate, this.endDate);

  tojson() {
    return {
      'name': this.name,
      'description': description,
      'startDate': startDate,
      'endDate': endDate
    };
  }
}
