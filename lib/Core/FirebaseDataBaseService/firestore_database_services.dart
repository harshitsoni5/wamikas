import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreDataBaseServices{
  static  createNewCollectionOrAddToExisting(String collectionName){
   try{
     CollectionReference collectionReference = FirebaseFirestore.instance.collection(collectionName);
     return collectionReference;
   }
   catch (e) {
     return e.toString();
   }
  }

  static Future fetchTheDocumentByItsCollectionNameDocId({required String collectionName,required String documentId}) async{
  try{
    CollectionReference collectionReference = FirebaseFirestore.instance.collection(collectionName);
    DocumentSnapshot snapshot = await collectionReference.doc(documentId).get();
    return snapshot.data();
  }
  catch(e){
    return e.toString();
  }
  }
}