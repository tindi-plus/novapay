import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/annotations.dart';
import 'package:novapay/src/features/authentication/data/auth_repository.dart';

@GenerateMocks([
  User,
  FirebaseFunctions,
  HttpsCallable,
  HttpsCallableResult,
  Connectivity,
  AuthRepository,
  FirebaseFirestore,
])
void main() {}