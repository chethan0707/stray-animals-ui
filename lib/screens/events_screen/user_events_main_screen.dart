// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';

// import '../../models/event_model.dart';

// class Events extends ConsumerWidget {
//   final List<Event> events;
//   const Events({required this.events, super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return events.isEmpty
//         ? const Center(child: Text("No upcoming events! "))
//         : ListView.builder(
//             itemCount: events.length,
//             itemBuilder: (context, index) {
//               return Padding(
//                 padding: const EdgeInsets.all(15),
//                 child: InkWell(
//                   onTap: () {},
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: const BorderRadius.all(Radius.circular(5)),
//                       color: Colors.deepPurple[200],
//                     ),
//                     child: Column(
//                       children: [
//                         ListTile(
//                           title: Text(
//                             events[index].eventName,
//                             style: GoogleFonts.aldrich(
//                                 fontSize: 16, color: Colors.black),
//                           ),
//                         ),
//                         ListTile(
//                             title: Text(
//                           events[index].description,
//                           style: GoogleFonts.aldrich(
//                               fontSize: 16, color: Colors.black),
//                         )),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//   }
// }
