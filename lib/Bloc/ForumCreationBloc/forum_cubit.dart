import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Core/FirebaseDataBaseService/firestore_database_services.dart';
import '../../SharedPrefernce/shared_pref.dart';
import 'forum_state.dart';

class ForumCubit extends Cubit<ForumState> {
  ForumCubit() : super(ForumInitial());

  Future createForum(
      {required String forumName,
      required String forumTitle,
      required String forumDescription,
      required String postId,
      required String dateAndTime,
      required String name,
      }) async {
    emit(ForumLoading());
    try {
      if (forumName.isNotEmpty) {
        if (forumTitle.isNotEmpty) {
          if (forumDescription.isNotEmpty) {
            await FireStoreDataBaseServices.createNewCollectionOrAddToExisting(
                "posts");
            String documentId = await SharedData.getIsLoggedIn("phone");
            await FireStoreDataBaseServices.setDataToUserCollection(
                "posts", postId, {
              "uid": documentId,
              "forum_name": forumName,
              "forum_title": forumTitle,
              "forum_content": forumDescription,
              "like": [],
              "comments": [],
              "time": dateAndTime,
              "id":postId
            });
            emit(ForumSuccess());
            emit(ForumInitial());
          } else {
            emit(ForumDescriptionMissing());
          }
        }
        else {
          emit(ForumHeadlinesMissing());
        }
      } else {
        emit(ForumNotSelected());
      }
    } catch (e) {
      emit(ForumError());
    }
  }

}

