// import 'package:Coretext/module/user_profile/model/user_data_model.dart';
// import 'package:Coretext/module/user_profile/view_model/user_data_view_model.dart';
// import 'package:Coretext/utils/WebService/api_base_model.dart';
// import 'package:Coretext/utils/widgetConstant/common_widget/common_widget.dart';
// import 'package:Coretext/utils/widgetConstant/text_widget/text_constant_widget.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class ProfileRowWidget extends StatefulWidget {
//   final String label;
//   final TextEditingController controller;
//   final bool isEditable;
//   final bool isEmailField;
//   final bool isMobileField;
//   final bool isDropdown;
//   final List<String>? dropdownItems;
//   final String? dropdownValue;
//   final ValueChanged<String?>? onDropdownChanged;
//   final int? maxLines;
//   final FocusNode? focusNode;
//   final Color editableFieldColor; // New parameter

//   const ProfileRowWidget({
//     super.key,
//     required this.label,
//     required this.controller,
//     required this.isEditable,
//     required this.isEmailField,
//     required this.isMobileField,
//     required this.isDropdown,
//     this.dropdownItems,
//     this.dropdownValue,
//     this.onDropdownChanged,
//     this.maxLines,
//     this.focusNode,
//     this.editableFieldColor =
//         const Color.fromARGB(255, 18, 72, 188), // New parameter
//   });

//   @override
//   _ProfileRowWidgetState createState() => _ProfileRowWidgetState();
// }

// class _ProfileRowWidgetState extends State<ProfileRowWidget> {
//   UserDataViewModel userDataViewModel = Get.put(UserDataViewModel());

//   Future<void> _handleFieldSubmit() async {
//     if (userDataViewModel.isEditClick.value) {
//       FocusScope.of(context).unfocus();
//       userDataViewModel.isEditClick.value = false;

//       APIBaseModel<UserDataModel?>? response =
//           await userDataViewModel.updateUserDetails();

//       if (response?.status == true) {
//         await userDataViewModel.getUsersDetails();
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 9.0),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 2,
//             child: ConstantText(
//               maxLines: 2,
//               text: widget.label,
//               fontSize: 14.0,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           Center(
//             child: ConstantText(
//               text: "-",
//               fontSize: 14.0,
//               color: Colors.black,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           spaceWidget(width: 20.0),
//           Expanded(
//             flex: 2,
//             child: widget.isDropdown
//                 ? DropdownButtonFormField<String>(
//                     style: TextStyle(
//                       fontSize: 14.0,
//                       color: widget.isEditable
//                           ? widget.editableFieldColor
//                           : Colors.black,
//                     ),
//                     isDense: true,
//                     isExpanded: true,
//                     value: widget.dropdownValue,
//                     items: widget.dropdownItems?.map((state) {
//                       return DropdownMenuItem<String>(
//                         value: state,
//                         child: Text(
//                           state,
//                           style: const TextStyle(
//                             fontSize: 14.0,
//                             color: Colors.black,
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                     hint: ConstantText(
//                       fontSize: 14.0,
//                       color: widget.isEditable
//                           ? widget.editableFieldColor
//                           : Colors.black,
//                       text: 'Select State',
//                     ),
//                     onChanged:
//                         widget.isEditable ? widget.onDropdownChanged : null,
//                     decoration: const InputDecoration(
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.symmetric(horizontal: 2.0),
//                     ),
//                   )
//                 : TextFormField(
//                     onFieldSubmitted: (value) async {
//                       //  await _handleFieldSubmit();
//                     },
//                     focusNode: widget.focusNode,
//                     style: TextStyle(
//                       fontSize: 14.0,
//                       color: widget.isEditable &&
//                               !widget.isEmailField &&
//                               !widget.isMobileField
//                           ? widget.editableFieldColor
//                           : Colors.black,
//                     ),
//                     maxLines: widget.maxLines ?? 1,
//                     controller: widget.controller,
//                     readOnly: !widget.isEditable ||
//                         widget.isEmailField ||
//                         widget.isMobileField,
//                     decoration: const InputDecoration(
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.symmetric(horizontal: 2.0),
//                     ),
//                     onTap: () {
//                       if (widget.isEditable) {
//                         widget.focusNode
//                             ?.requestFocus(); // Request focus on tap
//                       }
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }
