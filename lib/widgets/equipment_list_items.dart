import 'package:equipement_request_app/screens/equipment_details.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EquipmentListItems extends StatelessWidget {
const EquipmentListItems({ 
  Key? key,
  required this.equipmentList, 
   }) : super(key: key);

 final List<DocumentSnapshot<Object?>> equipmentList;


  @override
  Widget build(BuildContext context){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: equipmentList.length,
                  itemBuilder: (context, index) {
                    return Card(
                        child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EquipmentDetails(equipment:equipmentList[index]),
                          ),
                        );
                      },
                      leading: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 44,
                          minHeight: 44,
                          maxWidth: 64,
                          maxHeight: 64,
                        ),
                        child: Image.network(
                          equipmentList[index]['photo'],
                        ),
                      ),
                      title:  Text(equipmentList[index]['equipmentSpecs']['brand']+" "+equipmentList[index]['description']),
                    subtitle: Text(equipmentList[index]['equipmentCode']),
                      trailing: const Icon(
                        Icons.arrow_circle_right,
                      ),
                    ));
                  })),
        ],
      ),
    );
  }
}