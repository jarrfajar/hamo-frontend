import 'package:get/get.dart';
import 'package:hamo/app/models/Service.dart';
import 'package:hamo/app/modules/home/controllers/home_controller.dart';

class SearchController extends GetxController {
  final HomeController homeController = Get.find();

  RxList<Service> search = RxList<Service>();

  RxString keyword = ''.obs;
  RxString count = ''.obs;
  RxString first = 'Cari sesuatu..'.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  searchChanged(String value) {
    RxList<Service> service = homeController.listSerivce;
    if (value.isNotEmpty) {
      keyword.value = value;
      var cari = service.where((element) => element.title!.toLowerCase().contains(value.toLowerCase())).toList().obs;
      search.clear();
      first.value = '';
      count.value = cari.length.toString();
      search.addAll(cari);
    } else {
      keyword.value = '';
      search.clear();
    }
  }
}
