import 'package:regwalls/model/categories_model.dart';

String apiKey = "01dV8NfN3Eve12VlKutbryGYulaFRbftOYYU5ev09mmG0JCSjD978reo";

List<CategoriesModel> getCategories() {
  List<CategoriesModel> categories = [];
  CategoriesModel categoryModel = CategoriesModel();

  categoryModel.categoryName = "Minimal";
  categories.add(categoryModel);
  categoryModel.imgUrl =
      "https://images.pexels.com/photos/4352247/pexels-photo-4352247.jpeg?auto=compress&cs=tinysrgb&w=700&h=700&dpr=2";
  categoryModel = CategoriesModel();

  categoryModel.categoryName = "Pastel";
  categories.add(categoryModel);
  categoryModel.imgUrl =
      "https://images.pexels.com/photos/6044255/pexels-photo-6044255.jpeg?auto=compress&cs=tinysrgb&w=700&h=700&dpr=2";
  categoryModel = CategoriesModel();

  categoryModel.categoryName = "Nature";
  categories.add(categoryModel);
  categoryModel.imgUrl =
      "https://images.pexels.com/photos/5850083/pexels-photo-5850083.jpeg?auto=compress&cs=tinysrgb&w=700&h=700&dpr=2";
  categoryModel = CategoriesModel();

  categoryModel.categoryName = "Dark";
  categories.add(categoryModel);
  categoryModel.imgUrl =
      "https://images.pexels.com/photos/3494648/pexels-photo-3494648.jpeg?auto=compress&cs=tinysrgb&w=700&h=700&dpr=2";
  categoryModel = CategoriesModel();

  categoryModel.categoryName = "Street Art";
  categories.add(categoryModel);
  categoryModel.imgUrl =
      "https://images.pexels.com/photos/162379/lost-places-pforphoto-leave-factory-162379.jpeg?auto=compress&cs=tinysrgb&w=700&h=700&dpr=2";
  categoryModel = CategoriesModel();

  categoryModel.categoryName = "City";
  categories.add(categoryModel);
  categoryModel.imgUrl =
      "https://images.pexels.com/photos/1123972/pexels-photo-1123972.jpeg?auto=compress&cs=tinysrgb&w=700&h=700&dpr=2";
  categoryModel = CategoriesModel();

  categoryModel.categoryName = "Football";
  categories.add(categoryModel);
  categoryModel.imgUrl =
      "https://images.pexels.com/photos/1884574/pexels-photo-1884574.jpeg?auto=compress&cs=tinysrgb&w=700&h=700&dpr=2";
  categoryModel = CategoriesModel();

  categoryModel.categoryName = "Cars";
  categories.add(categoryModel);
  categoryModel.imgUrl =
      "https://images.pexels.com/photos/13369577/pexels-photo-13369577.jpeg?auto=compress&cs=tinysrgb&w=700&h=700&dpr=2";
  categoryModel = CategoriesModel();

  categoryModel.categoryName = "Architecture";
  categories.add(categoryModel);
  categoryModel.imgUrl =
      "https://images.pexels.com/photos/6766628/pexels-photo-6766628.jpeg?auto=compress&cs=tinysrgb&w=700&h=700&dpr=2";
  categoryModel = CategoriesModel();

  categoryModel.categoryName = "Aesthetic";
  categories.add(categoryModel);
  categoryModel.imgUrl =
  "https://images.pexels.com/photos/3910073/pexels-photo-3910073.jpeg?auto=compress&cs=tinysrgb&w=700&h=700&dpr=2";
  categoryModel = CategoriesModel();

  return categories;
}
