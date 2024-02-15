import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/utils.dart';
import '../constants/app_labels.dart' as Constants;

class EquipmentDetails extends StatelessWidget {
  final DocumentSnapshot equipment;

  const EquipmentDetails({super.key, required this.equipment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: !equipment['isAssigned']
          ? FloatingActionButton.extended(
              backgroundColor: Colors.blue,
              label: const Text(Constants.REQUEST,
                  style: TextStyle(color: Colors.white)),
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                _modalForCreateRequest(context);
              },
            )
          : null,
      appBar: AppBar(
        title: const Text(
          Constants.EQUIPMENT_DETAILS,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: EdgeInsets.zero,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Image.network(
            equipment['photo'],
            width: context.width,
            fit: BoxFit.fill,
            height: 250,
          ),
          _buildDetailRow(
              Constants.BRAND, equipment['equipmentSpecs']['brand']),
          _buildDetailRow(
              Constants.MODEL, equipment['equipmentSpecs']['model']),
          _buildDetailRow(
              Constants.PROCESSOR, equipment['equipmentSpecs']['processor']),
          _buildDetailRow(Constants.GRAPHICS_CARD,
              equipment['equipmentSpecs']['graphicsCard']),
          if (equipment['isAssigned']) ...[
            _buildDetailRow(
                Constants.ASSIGNED_TO, equipment['assignedTo']['name']),
            _buildDetailRow(
                Constants.PURPOSE, equipment['assignedTo']['purpose']),
          ]
        ]),
      ),
    );
  }

  Future<dynamic> _modalForCreateRequest(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final TextEditingController nameController = TextEditingController();
    final TextEditingController scheduleController = TextEditingController();
    final TextEditingController purposeController = TextEditingController();
    return showModalBottomSheet(
      context: context,
      builder: ((context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
            top: 10,
            left: 20,
            right: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  Constants.REQUEST_DETAILS,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: nameController,
                  decoration:
                      const InputDecoration(labelText: Constants.YOUR_NAME),
                ),
                TextFormField(
                  controller: scheduleController,
                  decoration:
                      const InputDecoration(labelText: Constants.SCHEDULE),
                ),
                TextFormField(
                  controller: purposeController,
                  decoration:
                      const InputDecoration(labelText: Constants.PURPOSE),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    width: screenWidth - 20,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () async {
                        await _submitRequest(nameController, scheduleController,
                            purposeController, context);
                        Navigator.pop(context); // Close the bottom sheet
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          Constants.SUBMIT_REQUEST,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Future<DocumentReference<Map<String, dynamic>>> _submitRequest(
      TextEditingController nameController,
      TextEditingController scheduleController,
      TextEditingController purposeController,
      context) async {
    try {
      DocumentReference<Map<String, dynamic>> ref = await FirebaseFirestore
          .instance
          .collection('equipment/${equipment.id}/requests')
          .add({
        'equipmentId': equipment.id,
        'name': nameController.text,
        'schedule': scheduleController.text,
        'purpose': purposeController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Request submitted successfully'),
        ),
      );
      return ref;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting request: $e'),
        ),
      );
      rethrow;
    }
  }
}

Widget _buildDetailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(value),
        ),
      ],
    ),
  );
}
