part of 'interactive_tabs_paging.dart';

class InteractiveTabsPagingController{

  late InteractiveTabsController _tabsController;


  String? get currentTitle => _titles[_currentIndex];


  int _currentIndex = 0;
  final List<String?> _titles = List.generate(100, (_)=> null);
  final List<DateTime?> _dateTimes = List.generate(100, (_)=> DateTime(2000));
  final List<Widget> _pages = List.generate(100, (_)=> const SizedBox());


  int get currentIndex => _currentIndex;


  void nextPage({String? title, required Widget page}){
    _titles[_currentIndex+1] = title;
    _dateTimes[_currentIndex+1] = DateTime.now();
    _pages[_currentIndex+1] = page;
    _currentIndex = _currentIndex+1;
    _tabsController.toTab(_currentIndex);
  }


  void popPage(){
    _currentIndex = _currentIndex-1;
    _tabsController.toTab(_currentIndex);
  }


}