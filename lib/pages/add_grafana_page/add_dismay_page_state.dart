
part of 'add_dismay_page_bloc.dart';


class AddDismayPageState extends Equatable {
  final int id;
  final double page;
  final Color color;
  final String title;
  final IconData icon;
  final String url;
  final Color iconColor;
  const AddDismayPageState(
      {@required this.id,
      @required this.page,
      @required this.color,
      @required this.iconColor,
      @required this.title,
      @required this.icon,
      @required this.url});

  static AddDismayPageState from(AddDismayPageState state,
      {int id,
      double page,
      Color color,
      Color iconColor,
      String title,
      IconData icon,
      String url}) {
    return AddDismayPageState(
        id: id ?? state.id,
        page: page ?? state.page,
        color: color ?? state.color,
        title: title ?? state.title,
        icon: icon ?? state.icon,
        iconColor: iconColor ?? state.iconColor,
        url: url ?? state.url);
  }

  @override
  List<Object> get props => [page, color, title, icon, iconColor, url];
}

class InputTitleState extends AddDismayPageState {
  const InputTitleState(
      {@required int id,
      @required double page,
      @required Color color,
      @required String title,
      @required IconData icon,
      @required Color iconColor,
      @required String url})
      : super(
            id: id,
            page: page,
            color: color,
            title: title,
            icon: icon,
            iconColor: iconColor,
            url: url);

  static InputTitleState from(AddDismayPageState state,
      {int id,
      double page,
      Color color,
      Color iconColor,
      String title,
      IconData icon,
      String url}) {
    return InputTitleState(
        id: id ?? state.id,
        page: page ?? state.page,
        color: color ?? state.color,
        title: title ?? state.title,
        icon: icon ?? state.icon,
        iconColor: iconColor ?? state.iconColor,
        url: url ?? state.url);
  }
}

class NextPageState extends AddDismayPageState {
  const NextPageState(
      {@required int id,
      @required double page,
      @required Color color,
      @required String title,
      @required IconData icon,
      @required Color iconColor,
      @required String url})
      : super(
            id: id,
            page: page,
            color: color,
            title: title,
            icon: icon,
            iconColor: iconColor,
            url: url);

  static NextPageState from(AddDismayPageState state,
      {int id,
      double page,
      Color color,
      Color iconColor,
      String title,
      IconData icon,
      String url}) {
    return NextPageState(
        id: id ?? state.id,
        page: page ?? state.page,
        color: color ?? state.color,
        title: title ?? state.title,
        icon: icon ?? state.icon,
        iconColor: iconColor ?? state.iconColor,
        url: url ?? state.url);
  }
}

class GoBackState extends AddDismayPageState {
  const GoBackState(
      {@required int id,
      @required double page,
      @required Color color,
      @required String title,
      @required IconData icon,
      @required Color iconColor,
      @required String url})
      : super(
            id: id,
            page: page,
            color: color,
            title: title,
            icon: icon,
            iconColor: iconColor,
            url: url);

  static GoBackState from(AddDismayPageState state,
      {int id,
      double page,
      Color color,
      Color iconColor,
      String title,
      IconData icon,
      String url}) {
    return GoBackState(
        id: id ?? state.id,
        page: page ?? state.page,
        color: color ?? state.color,
        title: title ?? state.title,
        icon: icon ?? state.icon,
        iconColor: iconColor ?? state.iconColor,
        url: url ?? state.url);
  }
}

class SelectIconState extends AddDismayPageState {
  const SelectIconState(
      {@required int id,
      @required double page,
      @required Color color,
      @required String title,
      @required IconData icon,
      @required Color iconColor,
      @required String url})
      : super(
            id: id,
            page: page,
            color: color,
            title: title,
            icon: icon,
            iconColor: iconColor,
            url: url);

  static SelectIconState from(AddDismayPageState state,
      {int id,
      double page,
      Color color,
      Color iconColor,
      String title,
      IconData icon,
      String url}) {
    return SelectIconState(
        id: id ?? state.id,
        page: page ?? state.page,
        color: color ?? state.color,
        title: title ?? state.title,
        icon: icon ?? state.icon,
        iconColor: iconColor ?? state.iconColor,
        url: url ?? state.url);
  }
}

class SelectColorState extends AddDismayPageState {
  const SelectColorState(
      {@required int id,
      @required double page,
      @required Color color,
      @required String title,
      @required IconData icon,
      @required Color iconColor,
      @required String url})
      : super(
            id: id,
            page: page,
            color: color,
            title: title,
            icon: icon,
            iconColor: iconColor,
            url: url);

  static SelectColorState from(AddDismayPageState state,
      {int id,
      double page,
      Color color,
      Color iconColor,
      String title,
      IconData icon,
      String url}) {
    return SelectColorState(
        id: id ?? state.id,
        page: page ?? state.page,
        color: color ?? state.color,
        title: title ?? state.title,
        icon: icon ?? state.icon,
        iconColor: iconColor ?? state.iconColor,
        url: url ?? state.url);
  }
}

class InputUrlState extends AddDismayPageState {
  const InputUrlState(
      {@required int id,
      @required double page,
      @required Color color,
      @required String title,
      @required IconData icon,
      @required Color iconColor,
      @required String url})
      : super(
            id: id,
            page: page,
            color: color,
            title: title,
            icon: icon,
            iconColor: iconColor,
            url: url);

  static InputUrlState from(AddDismayPageState state,
      {int id,
      double page,
      Color color,
      Color iconColor,
      String title,
      IconData icon,
      String url}) {
    return InputUrlState(
        id: id ?? state.id,
        page: page ?? state.page,
        color: color ?? state.color,
        title: title ?? state.title,
        icon: icon ?? state.icon,
        iconColor: iconColor ?? state.iconColor,
        url: url ?? state.url);
  }
}

class TryToValidateDashState extends AddDismayPageState {
  const TryToValidateDashState(
      {@required int id,
      @required double page,
      @required Color color,
      @required String title,
      @required IconData icon,
      @required Color iconColor,
      @required String url})
      : super(
            id: id,
            page: page,
            color: color,
            title: title,
            icon: icon,
            iconColor: iconColor,
            url: url);
            
  static TryToValidateDashState from(AddDismayPageState state,
      {int id,
      double page,
      Color color,
      Color iconColor,
      String title,
      IconData icon,
      String url}) {
    return TryToValidateDashState(
        id: id ?? state.id,
        page: page ?? state.page,
        color: color ?? state.color,
        title: title ?? state.title,
        icon: icon ?? state.icon,
        iconColor: iconColor ?? state.iconColor,
        url: url ?? state.url);
  }
}

class SaveDashState extends AddDismayPageState {
  const SaveDashState(
      {@required int id,
      @required double page,
      @required Color color,
      @required String title,
      @required IconData icon,
      @required Color iconColor,
      @required String url})
      : super(
            id: id,
            page: page,
            color: color,
            title: title,
            icon: icon,
            iconColor: iconColor,
            url: url);

  static SaveDashState from(AddDismayPageState state,
      {int id,
      double page,
      Color color,
      Color iconColor,
      String title,
      IconData icon,
      String url}) {
    return SaveDashState(
        id: id ?? state.id,
        page: page ?? state.page,
        color: color ?? state.color,
        title: title ?? state.title,
        icon: icon ?? state.icon,
        iconColor: iconColor ?? state.iconColor,
        url: url ?? state.url);
  }
}

class AddDismayPageErrorState extends AddDismayPageState {
  final String errorMessage;

  const AddDismayPageErrorState(this.errorMessage,
      {@required int id,
      @required double page,
      @required Color color,
      @required String title,
      @required IconData icon,
      @required Color iconColor,
      @required String url})
      : super(
            id: id,
            page: page,
            color: color,
            title: title,
            icon: icon,
            url: url,
            iconColor: iconColor);

  @override
  List<Object> get props => [page, color, title, icon, iconColor, url];

  AddDismayPageErrorState copyWith({String errorMessage, double page}) {
    return AddDismayPageErrorState(errorMessage ?? errorMessage,
        id: id ?? id,
        page: page ?? page,
        color: color ?? color,
        icon: icon ?? icon,
        title: title ?? title,
        url: url ?? url,
        iconColor: iconColor ?? iconColor);
  }

   static AddDismayPageErrorState from(AddDismayPageState state, String message,
      {int id,
      double page,
      Color color,
      Color iconColor,
      String title,
      IconData icon,
      String url}) {
    return AddDismayPageErrorState(message,
        id: id ?? state.id,
        page: page ?? state.page,
        color: color ?? state.color,
        title: title ?? state.title,
        icon: icon ?? state.icon,
        iconColor: iconColor ?? state.iconColor,
        url: url ?? state.url);
  }

  Map<String, dynamic> toMap() {
    return {
      'errorState': errorMessage,
    };
  }

  static AddDismayPageErrorState fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return AddDismayPageErrorState(map['errorState'] as String,
        id: map['id'] as int,
        page: map['page'] as double,
        color: map['color'] as Color,
        icon: map['icon'] as IconData,
        title: map['title'] as String,
        url: map['url'] as String,
        iconColor: map['iconColor'] as Color);
  }

  String toJson() => json.encode(toMap()) as String;

  static AddDismayPageErrorState fromJson(String source) =>
      fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AddDismayPageErrorState errorState: $errorMessage';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is AddDismayPageErrorState && o.errorMessage == errorMessage;
  }

  @override
  int get hashCode => errorMessage.hashCode;
}
