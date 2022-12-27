// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:stray_animals_ui/models/report_model/user_report_model.dart';

// class VolAllReportsScreen extends ConsumerStatefulWidget {
//   final List<UserReport> reports;
//   const VolAllReportsScreen({required this.reports, super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _VolAllReportsScreenState();
// }

// class _VolAllReportsScreenState extends ConsumerState<VolAllReportsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return  widget.vol.ngos!.isEmpty
//             ? (const Center(
//                 child: Text(
//                   "Hello volunteer",
//                 ),
//               ))
//             : RefreshIndicator(
//                 onRefresh: () async {
//                   items.clear();
//                   closed.clear();
//                   open.clear();
//                   setState(() {});
//                 },
//                 child: FutureBuilder(
//                   future: getItems(),
//                   builder: (context, snapshot) {
//                     switch (snapshot.connectionState) {
//                       case ConnectionState.done:
//                         if (open.isEmpty) {
//                           return RefreshIndicator(
//                             onRefresh: () async {
//                               setState(() {
//                                 items.clear();
//                                 closed.clear();
//                                 open.clear();
//                               });
//                             },
//                             child: SizedBox(
//                               height: MediaQuery.of(context).size.height,
//                               child: const Center(
//                                   child: Text('No active reports found')),
//                             ),
//                           );
//                         } else {
//                           return ListView.builder(
//                             itemCount: open.length,
//                             itemBuilder: (context, index) {
//                               return open[index].status == false
//                                   ? Padding(
//                                       padding: const EdgeInsets.all(15),
//                                       child: InkWell(
//                                         onTap: () async {
//                                           var navCont = Navigator.of(context);
//                                           var place = await PlacesService()
//                                               .getPlaceByCoordinates(LatLng(
//                                                   open[index].coordinates[0],
//                                                   open[index].coordinates[1]));
//                                           navCont.push(
//                                             MaterialPageRoute(
//                                               builder: (context) =>
//                                                   VolunteerReport(
//                                                       email: widget.vol.email!,
//                                                       place: place,
//                                                       report: open[index]),
//                                             ),
//                                           );
//                                         },
//                                         child: Container(
//                                           decoration: BoxDecoration(
//                                             borderRadius: const BorderRadius.all(
//                                                 Radius.circular(5)),
//                                             color: Colors.deepPurple[200],
//                                           ),
//                                           child: Column(
//                                             children: [
//                                               ListTile(
//                                                 title: Text(
//                                                   open[index].userId,
//                                                   style: GoogleFonts.aldrich(
//                                                       fontSize: 16,
//                                                       color: Colors.black),
//                                                 ),
//                                                 subtitle: open[index].status ==
//                                                         false
//                                                     ? const Text(
//                                                         "Status: Active",
//                                                         style: TextStyle(
//                                                             color: Colors.black),
//                                                       )
//                                                     : const Text(
//                                                         "Status: Rescued"),
//                                               ),
//                                               ListTile(
//                                                 title: Text(
//                                                   open[index].description,
//                                                   style: GoogleFonts.aldrich(
//                                                       fontSize: 16,
//                                                       color: Colors.black),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     )
//                                   : const SizedBox(
//                                       height: 0,
//                                     );
//                             },
//                           );
//                         }
//                       default:
//                         return const Center(
//                           child: CircularProgressIndicator(
//                             color: Colors.deepPurple,
//                           ),
//                         );
//                     }
//                   },
//                 ),
//               );
//   }
// }
