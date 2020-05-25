import 'package:flutter/material.dart';
import 'package:focus/page/group/group_page.dart';
import 'package:focus/page/graph/graph_page.dart';
import 'package:focus/page/graph/new_graph_page.dart';
import 'package:focus/page/home/about_page.dart';
import 'package:focus/page/error/error_page.dart';

const String ROUTE_GROUP_PAGE = '/Group/';
const String ROUTE_GRAPH_PAGE = '/Graph/';
const String ROUTE_NEW_GRAPH_PAGE = '/NewGraph/';
const String ROUTE_ABOUT_PAGE = '/About/';
const String ROUTE_ERROR_PAGE = '/Error/';

Route<dynamic> handleRoute(RouteSettings routeSettings) {
  // One route handler to handle them all.
  List<String> nameParm = routeSettings.name.split(":");

  assert(nameParm.length == 1);
  String name = nameParm[0];
  assert(name != null);

  Object object = routeSettings.arguments;

  Widget childWidget;

  switch(name){
    case ROUTE_GROUP_PAGE:
      childWidget = GroupPage(object);
      break;

    case ROUTE_GRAPH_PAGE:
      childWidget = GraphPage(object);
      break;

    case ROUTE_NEW_GRAPH_PAGE:
      childWidget = NewGraphPage(object);
      break;

    case ROUTE_ABOUT_PAGE:
      childWidget = AboutPage();
      break;
  }

  if (name == null) {
    childWidget = ErrorPage(object);
  }

  return MaterialPageRoute(
      builder: (context) => childWidget);
}

