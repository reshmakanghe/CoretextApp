import 'dart:convert';

import 'package:Coretext/module/auth_module/login/view_model/login_view_model.dart';
import 'package:Coretext/module/speciality_page_module/speciality_module/view_model/speciality_view_model.dart';
import 'package:Coretext/module/user_profile/model/user_data_model.dart';
import 'package:Coretext/module/user_profile/view_model/user_data_view_model.dart';
import 'package:Coretext/utils/WebService/api_base_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class UserProfileWidget extends StatefulWidget {
  final ImageProvider? image; // Image parameter
  final bool isEditable;
  final TextEditingController controller;
  final bool isEmailField;
  final bool isDropdown;
  final bool? myInterest;
  final List<String>? dropdownItems;
  final String? dropdownValue;
  final ValueChanged<String?>? onDropdownChanged;
  final int? maxLines;
  final FocusNode? focusNode;
  final Color editableFieldColor;
  final String? hintText; // Add hintText
  final TextStyle? textStyle;
  final bool? isMobileField;
  final List<TextInputFormatter>? inputFormatters;
  const UserProfileWidget({
    Key? key,
    this.image,
    this.myInterest,
    required this.controller,
    required this.isEditable,
    required this.isEmailField,
    required this.isDropdown,
    this.isMobileField,
    this.hintText,
    this.dropdownItems,
    this.dropdownValue,
    this.onDropdownChanged,
    this.maxLines,
    this.focusNode,
    this.textStyle,
    this.inputFormatters,
    this.editableFieldColor =
        const Color.fromARGB(255, 18, 72, 188), // Default color
  }) : super(key: key);

  @override
  _UserProfileWidgetState createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  UserDataViewModel userDataViewModel = Get.put(UserDataViewModel());
  LoginViewModel loginViewModel = Get.put(LoginViewModel());
  SpecialityViewModel specialityViewModel = Get.put(SpecialityViewModel());
  String? _errorText;
  // Future<void> _handleFieldSubmit() async {
  //   // Trigger saving data if it's in edit mode
  //   if (userDataViewModel.isEditClick.value) {
  //     FocusScope.of(context).unfocus();
  //     userDataViewModel.isEditClick.value = false;

  //     // Call update method to save the updated values
  //     APIBaseModel<UserDataModel?>? response =
  //         await userDataViewModel.updateUserDetails();

  //     if (response?.status == true) {
  //       await userDataViewModel.getUsersDetails();
  //     }
  //   }
  // }

  bool _validateField() {
    if (widget.hintText?.toLowerCase().contains('mobile') == true) {
      final value = widget.controller.text;
      setState(() {
        if (value.isEmpty) {
          _errorText = 'Mobile number is required';
        } else if (value.length < 10) {
          _errorText = 'Mobile number must be 10 digits';
        } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
          _errorText = 'Only numbers are allowed';
        } else {
          _errorText = null;
        }
      });
      return _errorText == null;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobileField =
        widget.hintText?.toLowerCase().contains('mobile') == true;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 9.0),
      child: Row(
        children: [
          // Profile image
          widget.image != null
              ? Image(
                  image: widget.image!,
                  width: MediaQuery.of(context)
                                                        .size
                                                        .height >
                                                    800
                                                ? 24
                                                : MediaQuery.of(context)
                                                            .size
                                                            .height >
                                                        700
                                                    ? 24
                                                    : MediaQuery.of(context)
                                                                .size
                                                                .height >
                                                            650
                                                        ? 22
                                                        : MediaQuery.of(context)
                                                                    .size
                                                                    .height >
                                                                500
                                                            ? 20
                                                            :18,
                  // height: 24.0,
                )
              : const CircleAvatar(
                  radius: 24.0,
                  child: Icon(Icons.label, size: 24.0, color: Colors.black),
                ),
          const SizedBox(width: 16.0), // Space between image and input field

          // Text field, dropdown, or interest dialog
          Expanded(
            flex: 2,
            child: widget.isDropdown
                ? DropdownButtonFormField<String>(
                    menuMaxHeight: 290,
                    dropdownColor: const Color(0xfff4f4f4),
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height >
                                                    800
                                                ? 14
                                                : MediaQuery.of(context)
                                                            .size
                                                            .height >
                                                        700
                                                    ? 14
                                                    : MediaQuery.of(context)
                                                                .size
                                                                .height >
                                                            650
                                                        ? 12
                                                        : MediaQuery.of(context)
                                                                    .size
                                                                    .height >
                                                                500
                                                            ? 11
                                                            :10,
                      color: widget.isEditable
                          ? widget.editableFieldColor
                          : Colors.black,
                    ),
                    isDense: true,
                    isExpanded: true,
                    value:
                        widget.dropdownItems?.contains(widget.dropdownValue) ??
                                false
                            ? widget.dropdownValue
                            : null, // Set to null if value isn't valid
                    items: widget.dropdownItems?.map((item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style:  TextStyle(
                            fontFamily: "Montserrat",
                      fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height >
                                                    800
                                                ? 14
                                                : MediaQuery.of(context)
                                                            .size
                                                            .height >
                                                        700
                                                    ? 14
                                                    : MediaQuery.of(context)
                                                                .size
                                                                .height >
                                                            650
                                                        ? 12
                                                        : MediaQuery.of(context)
                                                                    .size
                                                                    .height >
                                                                500
                                                            ? 11
                                                            :10,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      );
                    }).toList(),
                    hint: Text(
                      'Select State',
                      style: TextStyle(
                        fontFamily: "Montserrat",
                      fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height >
                                                    800
                                                ? 14
                                                : MediaQuery.of(context)
                                                            .size
                                                            .height >
                                                        700
                                                    ? 14
                                                    : MediaQuery.of(context)
                                                                .size
                                                                .height >
                                                            650
                                                        ? 12
                                                        : MediaQuery.of(context)
                                                                    .size
                                                                    .height >
                                                                500
                                                            ? 11
                                                            :10,
                        color: widget.isEditable
                            ? widget.editableFieldColor
                            : Colors.black,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    onChanged: widget.isEditable
                        ? (newValue) {
                            if (widget.onDropdownChanged != null) {
                              widget.onDropdownChanged!(newValue);
                            }
                          }
                        : null,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 2.0),
                    ),
                  )
                : widget.myInterest == true && widget.isEditable
                    ? Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.black, width: 1.0),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  if (widget.isEditable) {
                                    _showSpecialityDialog(context);
                                  }
                                },
                                style: TextButton.styleFrom(
                                  alignment: Alignment
                                      .centerLeft, // Aligns text to the left
                                  padding: EdgeInsets
                                      .zero, // Remove any default padding
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween, // Space between text and icon
                                  children: [
                                    Obx(() {
                                      // Check if there are any selected specialities
                                      var selectedSpecialities = loginViewModel
                                          .selectedSpecialities
                                          .map((id) {
                                            // Use firstWhere and provide a default if not found
                                            var speciality = specialityViewModel
                                                .specialties
                                                .firstWhere((speciality) =>
                                                    speciality.catId == id);
                                            return speciality
                                                ?.catName; // Return name or null
                                          })
                                          .where((name) =>
                                              name !=
                                              null) // Filter out null names
                                          .toSet() // Convert to a Set to remove duplicates
                                          .join(', '); // Join names with commas

                                      return Expanded(
                                        child: Text(
                                          selectedSpecialities.isNotEmpty
                                              ? selectedSpecialities // Display selected categories
                                              : 'Select Interests', // Default text when nothing is selected
                                          style: TextStyle(
                                            fontFamily: "Montserrat",
                      fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height >
                                                    800
                                                ? 14
                                                : MediaQuery.of(context)
                                                            .size
                                                            .height >
                                                        700
                                                    ? 14
                                                    : MediaQuery.of(context)
                                                                .size
                                                                .height >
                                                            650
                                                        ? 12
                                                        : MediaQuery.of(context)
                                                                    .size
                                                                    .height >
                                                                500
                                                            ? 11
                                                            :10,
                                            color: widget.isEditable
                                                ? Colors.black
                                                : Colors.grey,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      );
                                    }),
                                    const Icon(Icons.arrow_drop_down,
                                        color: Colors.black), // Dropdown arrow
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    // : TextFormField(
                    //     controller: widget.controller,
                    //     focusNode: widget.focusNode,
                    //     maxLines: widget.maxLines ?? 1,
                    //     style: TextStyle(
                    //       fontSize: 15.0,
                    //       color: widget.isEditable && !widget.isEmailField
                    //           ? widget.editableFieldColor
                    //           : Colors.black,
                    //     ),
                    //     textAlign: TextAlign.left,
                    //     keyboardType:
                    //         isMobileField ? TextInputType.number : null,
                    //     readOnly: !widget.isEditable || widget.isEmailField,
                    //     onChanged: (value) {
                    //       if (isMobileField) _validateField();
                    //       widget.controller.selection =
                    //           TextSelection.collapsed(offset: value.length);
                    //     },
                    //     onFieldSubmitted: (value) async {
                    //       widget.controller.text = value;
                    //       // widget.controller = widget.controller.text ?? "";
                    //       //   await _handleFieldSubmit(); // Save the changes
                    //     },
                    //     onSaved: (newValue) {
                    //       loginViewModel.firstNameController.text = newValue ??
                    //           loginViewModel.firstNameController.text;
                    //     },
                    //     decoration: InputDecoration(
                    //       hintText:
                    //           widget.hintText ?? '', // Added hintText here
                    //       hintStyle: const TextStyle(color: Colors.grey),
                    //       border: const UnderlineInputBorder(
                    //         borderSide:
                    //             BorderSide(color: Colors.black, width: 1.0),
                    //       ),
                    //       focusedBorder: const UnderlineInputBorder(
                    //         borderSide:
                    //             BorderSide(color: Colors.black, width: 2.0),
                    //       ),
                    //       contentPadding:
                    //           const EdgeInsets.symmetric(horizontal: 2.0),
                    //     ),
                    //     inputFormatters: isMobileField
                    //         ? [
                    //             FilteringTextInputFormatter.allow(
                    //                 RegExp(r'[0-9]')),
                    //             LengthLimitingTextInputFormatter(10),
                    //           ]
                    //         : widget.inputFormatters,
                    //     onTap: () {
                    //       if (widget.isEditable) {
                    //         widget.focusNode?.requestFocus();
                    //       }
                    //     },
                    //   ),
                    : TextFormField(
                        controller: widget.controller,
                        focusNode: widget.focusNode,
                        maxLines: widget.maxLines ?? 1,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height >
                                                    800
                                                ? 15
                                                : MediaQuery.of(context)
                                                            .size
                                                            .height >
                                                        700
                                                    ? 14
                                                    : MediaQuery.of(context)
                                                                .size
                                                                .height >
                                                            650
                                                        ? 14
                                                        : MediaQuery.of(context)
                                                                    .size
                                                                    .height >
                                                                500
                                                            ? 12
                                                            :10,
                          color: widget.isEditable && !widget.isEmailField
                              ? widget.editableFieldColor
                              : Colors.black,
                        ),
                        textAlign: TextAlign.left,
                        keyboardType:
                            isMobileField ? TextInputType.number : null,
                        readOnly: !widget.isEditable || widget.isEmailField,
                        onChanged: (value) {
                          widget.controller.text = value;
                          widget.controller.selection =
                              TextSelection.collapsed(offset: value.length);
                          if (isMobileField) _validateField();
                          // widget.controller.selection =
                          //     TextSelection.collapsed(offset: value.length);
                          // // Make sure to reflect the new value in your view model
                          // if (widget.controller ==
                          //     loginViewModel.firstNameController) {
                          //   loginViewModel.firstNameController.text = value;
                          // } else if (widget.controller ==
                          //     loginViewModel.lastNameController) {
                          //   loginViewModel.lastNameController.text = value;
                          // }
                        },
                        onFieldSubmitted: (value) {
                          widget.controller.text = value;

                          // Optionally dismiss the keyboard here
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        decoration: InputDecoration(
                          hintText: widget.hintText ?? '',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 2.0),
                        ),
                        inputFormatters: isMobileField
                            ? [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                                LengthLimitingTextInputFormatter(10),
                              ]
                            : widget.inputFormatters,
                        onTap: () {
                          if (widget.isEditable) {
                            widget.focusNode?.requestFocus();
                          }
                        },
                      ),
          ),
        ],
      ),
    );
  }

// Show the dialog for selecting specialties
  void _showSpecialityDialog(BuildContext context) {
    // Step 1: Clear existing selections to avoid duplicates
    loginViewModel.selectedSpecialities.clear();

    // Step 2: Prepopulate `selectedSpecialities` based on user interests
    final userInterests = userDataViewModel
        .userListDataModel.value?.responseBody?.first?.userInterest;

    if (userInterests != null) {
      // Add only the IDs from user interests to `selectedSpecialities`
      loginViewModel.selectedSpecialities.addAll(
        userInterests.map((interest) => interest.catId!).whereType<int>(),
      );
    }

    // Step 3: Show the dialog with preselected values
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Select Interest",
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.left,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: specialityViewModel.specialties.map((speciality) {
                return Obx(() {
                  // Check if the selectedSpecialities contains the catId
                  bool isSelected = loginViewModel.selectedSpecialities
                      .contains(speciality.catId);

                  return CheckboxListTile(
                    title: Text(speciality.catName ?? ''), // Display the name
                    value: isSelected, // Reflect the preselected state
                    onChanged: (bool? selected) {
                      if (selected == true) {
                        // Add category ID to selectedSpecialities
                        loginViewModel.selectedSpecialities
                            .add(speciality.catId!);
                      } else {
                        // Remove category ID from selectedSpecialities
                        loginViewModel.selectedSpecialities
                            .remove(speciality.catId!);
                      }
                      loginViewModel.update(); // Refresh UI
                    },
                  );
                });
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Done"),
            ),
          ],
        );
      },
    );
  }
}
