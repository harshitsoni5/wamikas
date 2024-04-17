import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wamikas/Models/user_profile_model.dart';
import 'package:wamikas/SharedPrefernce/shared_pref.dart';
import 'forum_user_state.dart';

class ForumUserCubit extends Cubit<ForumUserState> {
  ForumUserCubit() : super(ForumUserInitial());
  Future getUserData(UserProfileModel? userProfileModel)async{
    if(userProfileModel!= null){
      emit(ForumUserSuccess(
          name: userProfileModel.name,
          profilePic: userProfileModel.profilePic,
          uid: userProfileModel.phone));
    }else{
      String name = await SharedData.getIsLoggedIn("name");
      String? profilePic = await SharedData.getIsLoggedIn("profile");
      String uid = await SharedData.getIsLoggedIn("uid");
      emit(
          ForumUserSuccess(name: name, profilePic: profilePic, uid: uid)
      );
    }
  }
}
