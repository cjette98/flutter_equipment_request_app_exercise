import 'package:equipement_request_app/widgets/equipment_list_items.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/app_labels.dart' as Constants;

class EquipementList extends StatelessWidget {
  const EquipementList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference equipmentCollection =
        FirebaseFirestore.instance.collection('equipment');

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _getEquipmentList(equipmentCollection),
        backgroundColor: const Color.fromARGB(255, 250, 248, 248),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> _getEquipmentList(
      CollectionReference<Object?> equipmentCollection) {
    return StreamBuilder<QuerySnapshot>(
      stream: equipmentCollection.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        var equipmentList = snapshot.data!.docs;
        List<DocumentSnapshot> availableEquipment = [];
        List<DocumentSnapshot> assignedEquipment = [];

        for (var equipment in equipmentList) {
          if (equipment['isAssigned']) {
            assignedEquipment.add(equipment);
          } else {
            availableEquipment.add(equipment);
          }
        }
        return TabBarView(
          children: [
            EquipmentListItems(equipmentList: availableEquipment),
            EquipmentListItems(equipmentList: assignedEquipment)
          ],
        );
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: const Text(
        Constants.REQUEST_EQUIPMENT_APP,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.blue,
      bottom: const TabBar(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black,
        indicatorColor: Colors.white,
        tabs: [
          Tab(child: Text(Constants.AVAILABLE_EQUIPMENT)),
          Tab(child: Text(Constants.ASSIGNED_EQUIPMENT)),
        ],
      ),
    );
  }
}



