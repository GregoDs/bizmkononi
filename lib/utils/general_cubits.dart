// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:intl/intl.dart';

import '../exports.dart';

class FormValidationCubit extends Cubit<Map<String, bool>> {
  FormValidationCubit() : super({});

  void validateField(String fieldId, bool isValid, {String? errorText}) {
    state[fieldId] = isValid;
    emit(Map.from(state));
  }

  bool isFormValid() {
    return state.values.every((isValid) => isValid);
  }

  void resetState() {
    emit({});
  }
}


enum Gender { PreferNotToSay, Male, Female , pleaseSelectGender}

class GenderCubit extends Cubit<Gender> {
  GenderCubit() : super(Gender.pleaseSelectGender);

  void setGender(Gender gender) => emit(gender);
}

enum ProductType { SelectType, SERVICE, PRODUCT, SERVICE_PRODUCT }

class ProductTypeCubit extends Cubit<ProductType> {
  ProductTypeCubit() : super(ProductType.SelectType);

  void setProductType(ProductType type) => emit(type);
}


class ImagePickerCubit extends Cubit<File?> {
  final ImagePicker _picker = ImagePicker();

  ImagePickerCubit() : super(null);

  Future<void> getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source, imageQuality: 50);

    if (pickedFile != null) {
      emit(File(pickedFile.path));
    }
  }
}


class SubTotalCubit extends Cubit<double> {
  SubTotalCubit() : super(0);

  void updateProduct(double value1, double value2) {
    emit(value1 * value2);
  }
}


class DateCubit extends Cubit<DateTime?> {
  DateCubit() : super(null);

  void selectDate(DateTime date) {
    emit(date);
  }

  void resetDate() {
    emit(null);
  }
}


String capitalizeWord(String word) {
  if (word.isNotEmpty) {
    // Check if the first character is a letter
    if (word[0].toUpperCase() != word[0].toLowerCase()) {
      // If the first character is a letter, capitalize it
      return word[0].toUpperCase() + word.substring(1);
    } else {
      // If the first character is not a letter, find the next letter and capitalize it
      for (int i = 1; i < word.length; i++) {
        if (word[i].toUpperCase() != word[i].toLowerCase()) {
          return word[i].toUpperCase() + word.substring(i + 1);
        }
      }
    }
  }
  // If the word is empty or doesn't contain any letters, return the original word
  return word;
}

String convertToHumanReadableDate(String timestamp) {
    // Convert the string timestamp to DateTime object
    DateTime dateTime = DateTime.parse(timestamp);

    // Format the DateTime object to include day name and month name
    String formattedDate = DateFormat('EEEE, MMMM dd, yyyy').format(dateTime);

    return formattedDate;
  }

  void showSuccess(BuildContext context, String message) {
    return showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.success(
        backgroundColor: ColorName.primaryColor,
        message: message,
      ),
    );
  }
