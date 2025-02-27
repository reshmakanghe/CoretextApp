import 'package:Coretext/module/speciality_page_module/bookmark_module/screen/bookmark_screen.dart';
import 'package:Coretext/module/speciality_page_module/my_specialities_module/screens/my_specialities_screen.dart';
import 'package:Coretext/module/speciality_page_module/poll_module/screen/poll_screen.dart';
import 'package:Coretext/module/speciality_page_module/speciality_module/screen/speciality_screen.dart';
import 'package:Coretext/utils/constants/ColorConstant/color_constant.dart';
import 'package:flutter/material.dart';

class Categories extends StatefulWidget implements PreferredSizeWidget {
  final int initialIndex; // Allow passing the initial index

  const Categories({super.key, this.initialIndex = 0});

  @override
  _CategoriesState createState() => _CategoriesState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CategoriesState extends State<Categories> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    // Initialize the selected index with the initial index passed to the widget
    selectedIndex = widget.initialIndex;
    // Restore the saved index from PageStorage
    final savedIndex = PageStorage.of(context)
        .readState(context, identifier: 'selectedIndex') as int?;
    if (savedIndex != null) {
      setState(() {
        selectedIndex = savedIndex;
      });
    }
  }

  // Function to handle tab selection and navigation
  void onTabTapped(int index) {
    setState(() {
      selectedIndex = index; // Update the selected index
    });

    // Save the selected index in PageStorage
    PageStorage.of(context)
        .writeState(context, selectedIndex, identifier: 'selectedIndex');

    // Navigate to the respective screen based on the selected index
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          switch (index) {
            case 0:
              return const SpecialityScreen();
            case 1:
              return const MySpecialityScreen();
            case 2:
              return const PollScreen();
            case 3:
              return BookmarksScreen();
            default:
              return const SpecialityScreen();
          }
        },
      ),
    ).then((_) {
      // Restore the selected index when coming back to this screen
      final savedIndex = PageStorage.of(context)
          .readState(context, identifier: 'selectedIndex') as int?;
      if (savedIndex != null) {
        setState(() {
          selectedIndex = savedIndex;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Top section with the tabs (Specialities, My Specialities, Poll, Bookmarks)
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          color: primaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TabButton(
                title: 'Specialities',
                isSelected: selectedIndex == 0,
                onTap: () => onTabTapped(0),
                selectedImagePath:
                    'assets/images/LIST.png', // Image for selected state
                unselectedImagePath: 'assets/images/LIST2.png',
              ),
              TabButton(
                title: 'My Specialities',
                isSelected: selectedIndex == 1,
                onTap: () => onTabTapped(1),
                selectedImagePath:
                    'assets/images/REVIEW.png', // Image for selected state
                unselectedImagePath: 'assets/images/REVIEW 2.png',
              ),
              TabButton(
                title: 'Poll',
                isSelected: selectedIndex == 2,
                onTap: () => onTabTapped(2),
                selectedImagePath:
                    'assets/images/ANALYTICS.png', // Image for selected state
                unselectedImagePath: 'assets/images/ANALYTICS 2.png',
              ),
              TabButton(
                title: 'Bookmarks',
                isSelected: selectedIndex == 3,
                onTap: () => onTabTapped(3),
                selectedImagePath:
                    'assets/images/BOOKMARK 2.png', // Image for selected state
                unselectedImagePath: 'assets/images/bookmark_5126251-.png',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Custom widget for the TabButton
class TabButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap; // Callback for navigation
  final String selectedImagePath; // Image for selected state
  final String unselectedImagePath; // Image for unselected state
  const TabButton({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap, // Required onTap function
    required this.selectedImagePath,
    required this.unselectedImagePath, // Both images are required
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Call the onTap function when tapped
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Circle container with icon
          Container(
            height: MediaQuery.of(context).size.height * 0.11,
            width: MediaQuery.of(context).size.width * 0.15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? Colors.white
                  : const Color.fromARGB(255, 235, 235, 235),
              border: Border.all(
                color: isSelected
                    ? const Color(0xffeb602f)
                    : primaryColor,
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Image.asset(
                isSelected
                    ? selectedImagePath
                    : unselectedImagePath, // Show selected or unselected image
                fit: BoxFit.contain,
              ),
            ),
          ),
          // const SizedBox(height: 5), // Space between the circle and title

          // Title below the circle container
          Text(
            title,
            maxLines: 2, // Enforce single line
            overflow: TextOverflow.visible, // Handle overflow with ellipsis
            softWrap:
                true, // Disable soft wrapping to prevent breaking into multiple lines
            style: TextStyle(
              color: isSelected
                  ? const Color(0xffeb602f)
                  : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.height > 800
                  ? 14
                  : MediaQuery.of(context).size.height > 700
                      ? 12
                      : MediaQuery.of(context).size.height > 650
                          ? 10
                          : MediaQuery.of(context).size.height > 500
                              ? 10
                              : MediaQuery.of(context).size.height > 400
                                  ? 8
                                  : 9,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
