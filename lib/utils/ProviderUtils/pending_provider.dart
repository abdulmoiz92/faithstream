import 'package:connectivity/connectivity.dart';
import 'package:faithstream/model/pendingcomment.dart';
import 'package:faithstream/model/pendingfavourite.dart';
import 'package:faithstream/model/pendinglike.dart';
import 'package:flutter/cupertino.dart';

class PendingRequestProvider extends ChangeNotifier {
  ConnectivityResult connectivityResult;
   bool internet = false;
   List<PendingLike> pendingLikes =[];
   List<PendingFavourite> pendingFavourites = [];
   List<PendingFavourite> pendingRemoveFavourites = [];
   List<PendingComment> pendingComments = [];

   set setConnectivityResult(ConnectivityResult result) {
     connectivityResult = result;
   }

   set setInternet(bool value) {
     internet = value;
   }

   set addPendingLike(PendingLike pendingLike) {
     pendingLikes.add(pendingLike);
     notifyListeners();
   }

   void resetPendingLikes() {
     pendingLikes = [];
     notifyListeners();
   }

   set addPendingFavourite(PendingFavourite pendingFavourite) {
     pendingFavourites.add(pendingFavourite);
     notifyListeners();
   }

   void resetPendingFavourites() {
     pendingFavourites = [];
     notifyListeners();
   }

   set addPendingRemoveFavourite(PendingFavourite pendingFavourite) {
     pendingRemoveFavourites.add(pendingFavourite);
     notifyListeners();
   }

   void resetPendingRemoveFavourites() {
     pendingRemoveFavourites = [];
     notifyListeners();
   }

   set addPendingComments(PendingComment pendingComment) {
     pendingComments.add(pendingComment);
     notifyListeners();
   }

   void resetPendingComments() {
     pendingComments = [];
     notifyListeners();
   }
}