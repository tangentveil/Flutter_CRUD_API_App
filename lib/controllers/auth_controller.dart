import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthService _authService;

  AuthController(this._authService);

  final isLoading = false.obs;
  final phoneNumber = ''.obs;
  final verificationId = ''.obs;
  final errorMessage = ''.obs;
  final isLoggedIn = false.obs;
  final currentUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    _authService.authStateChanges().listen((user) {
      currentUser.value = user;
      isLoggedIn.value = user != null;
      if (user != null) {
        Get.offAllNamed(Routes.OBJECT_LIST);
      } else {
        Get.offAllNamed(Routes.LOGIN);
      }
    });
  }

  Future<void> startPhoneVerification() async {
    if (phoneNumber.value.isEmpty) {
      errorMessage.value = 'Phone number is required';
      Get.snackbar('Error', errorMessage.value);
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      await _authService.verifyPhoneNumber(
        phoneNumber: phoneNumber.value,
        onVerificationCompleted: (PhoneAuthCredential credential) async {
          // Optional: auto sign in for Android
          try {
            await FirebaseAuth.instance.signInWithCredential(credential);
          } catch (e) {
            Get.snackbar('Error', 'Auto sign-in failed');
          }
        },
        onVerificationFailed: (FirebaseAuthException e) {
          isLoading.value = false;
          errorMessage.value = e.message ?? 'Verification failed';
          Get.snackbar('Error', errorMessage.value);
        },
        onCodeSent: (String verId, int? resendToken) {
          isLoading.value = false;
          verificationId.value = verId;
          Get.toNamed(Routes.OTP);
        },
        onCodeAutoRetrievalTimeout: (String verId) {
          verificationId.value = verId;
        },
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Something went wrong');
    }
  }

  Future<void> verifyOtp(String otp) async {
    if (otp.isEmpty) {
      Get.snackbar('Error', 'OTP is required');
      return;
    }

    isLoading.value = true;
    try {
      await _authService.signInWithSmsCode(
        verificationId: verificationId.value,
        smsCode: otp,
      );
      isLoading.value = false;
      // authStateChanges listener will navigate
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.message ?? 'Invalid OTP');
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Unknown error');
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
  }
}
