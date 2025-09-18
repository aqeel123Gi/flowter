class ScrollingPagination<T>{


  final List<T> data;

  int currentPage;
  int totalPages;

  ScrollingPagination({required this.totalPages, this.currentPage=1, required this.data});


  bool get hasNextPage{
    return currentPage<totalPages;
  }

  int get getNextPage{
    if(currentPage==totalPages) throw Exception("No more pages");
    return currentPage+1;
  }

  void newPage(List<T> newData){
    data.addAll(newData);
    currentPage++;
  }



}