import 'package:flutter/material.dart';
import 'package:focus/page/group/group_page.dart';
import 'package:focus/page/home/about_page.dart';
import 'package:focus/page/error/error_page.dart';

const String ROUTE_GROUP_PAGE = '/GroupPage/';
const String ROUTE_ABOUT_PAGE = '/About/';
const String ROUTE_ERROR_PAGE = '/Error/';

//TODO refactor into separate file
Route<dynamic> handleRoute(RouteSettings routeSettings) {
  // One route handler to handle them all.
  List<String> nameParm = routeSettings.name.split(":");

  assert(nameParm.length == 1);
  String name = nameParm[0];
  assert(name != null);

  Object object = routeSettings.arguments;

  Widget childWidget;
  if (name == ROUTE_GROUP_PAGE) {
    childWidget = GroupPage(object);
  } else if (name == ROUTE_ABOUT_PAGE) {
    childWidget = AboutPage();
  } else {
    childWidget = ErrorPage(object);
  }
  return MaterialPageRoute(
      builder: (context) => childWidget);
}

