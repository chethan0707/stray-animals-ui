import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/volunteer.dart';

class ViewVolunteers extends ConsumerStatefulWidget {
  final List<Volunteer> volunteers;
  const ViewVolunteers({required this.volunteers, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AssignVolunteerScreenState();
}

class _AssignVolunteerScreenState extends ConsumerState<ViewVolunteers> {
  @override
  void initState() {
    super.initState();
  }

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Event Volunteers'),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.75,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.all(20),
            child: ListView.builder(
              itemCount: widget.volunteers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    title: Text('${widget.volunteers[selectedIndex].userName}'),
                    tileColor:
                        selectedIndex == index ? Colors.deepPurple[200] : null,
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                      showCustomDialog(context);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void showCustomDialog(BuildContext context) {
    showModalBottomSheet(
      elevation: 0,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          height: 400,
          decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40))),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      "http://localhost:8080/file/download/${widget.volunteers[selectedIndex].profileUrl}",
                      height: 150,
                      width: 150,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Email: ${widget.volunteers[selectedIndex].email}",
              ),
              const SizedBox(height: 10),
              Text(
                "Animals Rescued: ${widget.volunteers[selectedIndex].rescueCount.toString()}",
              ),
              const SizedBox(height: 10),
              Text(
                "City: ${widget.volunteers[selectedIndex].city}",
              ),
              const SizedBox(height: 10),
              Text(
                "Phone: ${widget.volunteers[selectedIndex].phone.toString()}",
              ),
            ],
          ),
        );
      },
    );
  }
}
