import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseDatabaseService {
  static final FirebaseDatabaseService _instance =
      FirebaseDatabaseService._internal();

  factory FirebaseDatabaseService() => _instance;

  FirebaseDatabaseService._internal();

  late String baseUrl;
  late FirebaseApp firebaseApp;

  Future<void> initialize({required String url}) async {
    baseUrl = url;

    firebaseApp = await Firebase.initializeApp(
      name: 'app-${DateTime.now().millisecondsSinceEpoch}',
      options: Firebase.app().options,
    );
  }

  DatabaseReference ref(String path) {
    final db = FirebaseDatabase.instanceFor(
      app: firebaseApp,
      databaseURL: baseUrl,
    );
    return db.ref(path);
  }
  void listenToAssignmentSubmissions(Function(Map submission) onNewSubmission) {
  final submissionsRef = ref('assignments_submissions');

  submissionsRef.onChildAdded.listen((event) {
    final data = event.snapshot.value;
    if (data is Map) {
      onNewSubmission(data);
    }
  });
}

}
