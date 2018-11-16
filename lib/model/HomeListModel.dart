

//list moxing
class HomeListModel {
//  String nums;
//
//  HomeListModel(this.nums);


  String head_portrait_url;//头像url
  String nick_name;//昵称
  String commodity_content;//商品内容
  List<String> listUrls;//商品图片url集合
  String releaseDate;//发布日期
  String shareDate;

  HomeListModel(this.head_portrait_url, this.nick_name, this.commodity_content,
      this.listUrls, this.releaseDate, this.shareDate); //分享日期
}