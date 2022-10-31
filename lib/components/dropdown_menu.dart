// var options = ['Public', 'NGO', 'Volunteer'];
//   var _currentItemSelected = "Public";
//   var role = "Student";
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           children: [
//             DropdownButton<String>(
//               dropdownColor: Colors.blue[900],
//               isDense: true,
//               isExpanded: false,
//               iconEnabledColor: Colors.white,
//               focusColor: Colors.white,
//               items: options.map((String dropDownStringItem) {
//                 return DropdownMenuItem<String>(
//                   value: dropDownStringItem,
//                   child: Text(
//                     dropDownStringItem,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20,
//                     ),
//                   ),
//                 );
//               }).toList(),
//               onChanged: (newValueSelected) {
//                 setState(() {
//                   _currentItemSelected = newValueSelected!;
//                   role = newValueSelected;
//                 });
//               },
//               value: _currentItemSelected,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
