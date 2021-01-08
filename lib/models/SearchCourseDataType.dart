///搜索课程时的数据类型
class SearchCourseDataType {
  ///导航id
  int pid;

  ///搜索的内容
  String searchValue;

  ///是否是按标签搜索
  bool isTags;

  SearchCourseDataType({
    this.pid,
    this.searchValue,
    this.isTags,
  });
}
