import 'package:bloc/bloc.dart';
import '../pages/homepage.dart';
import '../pages/myworks.dart';
import '../pages/schedule.dart';

enum NavigationEvents{ 
  HomePageClickedEvent,
   MyWorksClickedEvent, 
   ScheduleClickedEvent,
}

abstract class NavigationStates{}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates>{
  @override
  
  NavigationStates get initialState => HomePage();

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.HomePageClickedEvent: 
        yield HomePage();
        break;
      case NavigationEvents.MyWorksClickedEvent: 
        yield MyWorksPage();
        break;
      case NavigationEvents.ScheduleClickedEvent: 
        yield SchedulePage();
        break;

    }
  }

}
