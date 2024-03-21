import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wamikas/SharedPrefernce/shared_pref.dart';
import '../../../Core/FirebaseDataBaseService/firestore_database_services.dart';
import 'location_state.dart';


class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial());

  Future saveLocation(String country,String state,String city,String address,String pin)async{
    emit(LocationLoading());
    if(state.isNotEmpty && city.isNotEmpty && address.isNotEmpty && pin.isNotEmpty){
      try{
        String documentId = await SharedData.getIsLoggedIn("phone");
        await FireStoreDataBaseServices.addDataOfUserToCollection(
            "users",
            documentId,
            {
              "country":country,
              "state":state,
              "city":city,
              "address":address,
              "zipCode":pin
            }
        );
        emit(LocationSuccess());
        emit(LocationInitial());
      }
      catch(e){
        emit(LocationError());
        emit(LocationInitial());
        print(e.toString());
      }
    }else{
      emit(ForumNotFilledProperly());
      emit(LocationInitial());
    }
  }
}
