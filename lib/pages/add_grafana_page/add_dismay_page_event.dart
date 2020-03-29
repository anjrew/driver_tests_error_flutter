part of 'add_dismay_page_bloc.dart';


abstract class AddDismayPageEvent extends Equatable {
  const AddDismayPageEvent();
}


class ColorSelectedEvent extends AddDismayPageEvent {
  final Color color;
  const ColorSelectedEvent(this.color);
  @override
  List<Object> get props => [color];
}


class IconSelectedEvent extends AddDismayPageEvent {
  final IconData icon;
  const IconSelectedEvent(this.icon);

  @override
  List<Object> get props => [icon];
}


class SelectIconEvent extends AddDismayPageEvent {
  const SelectIconEvent();

  @override
  List<Object> get props => throw UnimplementedError();
}

class SelectIconColorEvent extends AddDismayPageEvent {
  final Color color;
  const SelectIconColorEvent(this.color);
  @override
  List<Object> get props => [color];
}


class TitleInputEvent extends AddDismayPageEvent {
  final String title;
  const TitleInputEvent(this.title);

  @override
  List<Object> get props => [title];
}


class SubmitDashEvent extends AddDismayPageEvent {
  @override
  List<Object> get props => throw UnimplementedError();
}


class UrlInputEvent extends AddDismayPageEvent {
  final String url;
  const UrlInputEvent(this.url);

  @override
  List<Object> get props => [url];
}


class SubmitAddDismayPageEvent extends AddDismayPageEvent {
  const SubmitAddDismayPageEvent();

  @override
  List<Object> get props => throw UnimplementedError();
}


class GoBackAddDismayPageEvent extends AddDismayPageEvent {
  const GoBackAddDismayPageEvent();

  @override
  List<Object> get props => throw UnimplementedError();
}


class TryToValidateDashEvent extends AddDismayPageEvent {
  const TryToValidateDashEvent();

  @override
  List<Object> get props => throw UnimplementedError();
}


class NextPageEvent extends AddDismayPageEvent {
  final double currentPageIndex;
  const NextPageEvent(this.currentPageIndex);

  @override
  List<Object> get props => [currentPageIndex];
}


class PageChangedEvent extends AddDismayPageEvent {
  final double currentPageIndex;
  const PageChangedEvent(this.currentPageIndex);

  @override
  List<Object> get props => [currentPageIndex];
}

