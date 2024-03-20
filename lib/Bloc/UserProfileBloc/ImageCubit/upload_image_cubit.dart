import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wamikas/Bloc/UserProfileBloc/ImageCubit/upload_image_state.dart';
import 'dart:io';
import '../../../Core/FirebaseDataBaseService/firestore_database_services.dart';
import '../../../SharedPrefernce/shared_pref.dart';

class UploadImageCubit extends Cubit<UploadImageState> {
  UploadImageCubit() : super(UploadImageInitial());

  Future uploadPhotoEvent(bool camera) async {
    emit(UploadImageLoading());
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
          source:camera?
      ImageSource.camera:ImageSource.gallery,);
      if (image != null) {
        Reference referenceRoot = FirebaseStorage.instance.ref();
        Reference imagePdf =referenceRoot.child('profile pic');
        Reference imageToUpload = imagePdf.child("image${DateTime.now().millisecondsSinceEpoch}");
        await imageToUpload.putFile(File(image.path));
        String imageURL = await imageToUpload.getDownloadURL();
        SharedData.setImageUrl(imageURL);
        String documentId = await SharedData.getIsLoggedIn("phone");
        await FireStoreDataBaseServices.addDataOfUserToCollection(
            "users",
            documentId,
            {
              "profile_pic":imageURL
            }
        );
        emit(UploadImageSuccess(path: image.path));
      }
      else{
        emit(UploadImageInitial());
      }
    }
    catch(e){
      emit(UploadImageError());
      emit(UploadImageInitial());
    }
  }
}
