import 'package:flutter/material.dart';
import '../models/planner_entry_model.dart';

class PlannerProvider with ChangeNotifier {
  final List<PlannerEntryModel> _entries = [];
  List<PlannerEntryModel> get entries => _entries;

  void addEntry(PlannerEntryModel entry) {
    _entries.add(entry);
    notifyListeners();
  }
}
