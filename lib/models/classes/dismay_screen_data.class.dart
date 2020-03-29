import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:dismay_app/utils/helpers.tools.dart';

class DismayScreenData {
  int id;
  String url;
  String title;
  Color color;
  IconData icon;
  Color iconColor;
  DismayScreenData({
    @required this.id,
    this.url,
    this.title,
    this.color,
    this.icon,
    this.iconColor,
  });

  DismayScreenData copyWith({
    int id,
    String url,
    String title,
    Color color,
    IconData icon,
    Color iconColor,
  }) {
    return DismayScreenData(
      id: id ?? this.id,
      url: url ?? this.url,
      title: title ?? this.title,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'title': title,
      'color': color.value,
      'icon': icon.codePoint,
      'iconColor': iconColor.value,
    };
  }

  static DismayScreenData fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return DismayScreenData(
      id: map['id'] as int,
      url: map['url'] as String,
      title: map['title'] as String,
      color: Color(map['color'] as int),
      icon: IconData(map['icon'] as int, fontFamily: 'MaterialIcons'),
      iconColor: Color(map['iconColor'] as int),
    );
  }


  static DismayScreenData defaultData(int sessions) {
  
    return DismayScreenData(
      id: idGenerator(sessions),
      url: 'https://www.dismay.com',
      title: 'DriverDismay',
      color: Colors.orange,
      icon: Icons.dashboard,
      iconColor: Colors.orange,
    );
  }

  String toJson() => json.encode(toMap());

  static DismayScreenData fromJson(String source) => fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DismayScreenData id: $id, url: $url, title: $title, color: $color, icon: $icon, iconColor: $iconColor';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is DismayScreenData &&
      o.id == id &&
      o.url == url &&
      o.title == title &&
      o.color == color &&
      o.icon == icon &&
      o.iconColor == iconColor;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      url.hashCode ^
      title.hashCode ^
      color.hashCode ^
      icon.hashCode ^
      iconColor.hashCode;
  }
}
