import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wamikas/Bloc/UserProfileBloc/ImageCubit/upload_image_state.dart';
import 'dart:io';
import '../../../Core/FirebaseDataBaseService/firestore_database_services.dart';
import '../../../SharedPrefernce/shared_pref.dart';

class UploadImageCubit extends Cubit<UploadImageState> {
  UploadImageCubit() : super(UploadImageInitial());

  Future uploadPhotoEvent() async {
    emit(UploadImageLoading());
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        dialogTitle: "Select Profile Photo",
        allowMultiple: false,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );
      if (result != null) {
        PlatformFile? file = result.files.first;
        Reference referenceRoot = FirebaseStorage.instance.ref();
        Reference imagePdf =referenceRoot.child('profile pic');
        Reference imageToUpload = imagePdf.child("image${DateTime.now().millisecondsSinceEpoch}");
        await imageToUpload.putFile(File(file.path!));
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
        emit(UploadImageSuccess(path: file.path));
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
