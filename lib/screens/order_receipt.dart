import 'package:flutter/material.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:imagine_waiting_side/controllers/employee_controller.dart';
import 'package:imagine_waiting_side/models/drink.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:imagine_waiting_side/controllers/food_controller.dart';

class OrderReceipt extends StatelessWidget {
  const OrderReceipt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipt'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.picture_as_pdf))
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: TextButton(
              child: const Text('Print the Receipt'),
              onPressed: () async {
                final FoodController foodController =
                    Get.find<FoodController>();
                final EmployeeController employeeController =
                    Get.find<EmployeeController>();

                final pdf = pw.Document();
                pdf.addPage(pw.Page(
                    pageFormat: PdfPageFormat.a6,
                    build: (pw.Context context) {
                      return pw.ListView(children: [
                        pw.Center(
                            child: pw.Text('Imagine Bar Order Receipt',
                                style: pw.TextStyle(
                                    fontSize: 18,
                                    fontWeight: pw.FontWeight.bold))),
                        pw.Text(DateTime.now()
                            .toLocal()
                            .toString()
                            .substring(0, 16)),
                        pw.Row(
                          children: [
                            pw.Text(employeeController.selectedWaiter!.name),
                            pw.Text('Cedis: ${foodController.getTotalOrders()}',
                                style: pw.TextStyle(
                                    fontSize: 15,
                                    fontWeight: pw.FontWeight.bold))
                          ],
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        ),
                        pw.Table(children: _buildPDFChildren(foodController))
                      ]); // Center
                    })); // Page

                /*final output = await getTemporaryDirectory();
                final file = File('${output.path}/order.pdf');
                await file.writeAsBytes(await pdf.save());
*/
                await Printing.layoutPdf(
                    onLayout: (PdfPageFormat format) async => pdf.save());

                foodController.resetEverything();
                employeeController.resetEverything(); // TODO put back in place
              },
            ),
          ),
          GetBuilder<FoodController>(
            builder: (foodController) => SliverList(
              delegate:
                  SliverChildListDelegate.fixed(_buildChildren(foodController)),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _buildChildren(FoodController foodController) {
    final List<Widget> r = [];

    for (final foodEntry in foodController.foodOrders.entries) {
      r.add(ListTile(
        title: Text(foodEntry.key.name),
        trailing: Text('${foodEntry.value}'),
        subtitle: Text('Cedis = ${foodEntry.value * foodEntry.key.cost}'),
      ));
    }
    for (final drinkEntry in foodController.drinkOrders.entries) {
      r.add(ListTile(
        title: Text(drinkEntry.key.name),
        trailing: Text('${drinkEntry.value}'),
        subtitle: Text('Total: ¢${drinkEntry.value * drinkEntry.key.cost}'),
      ));
    }
    return r;
  }

  List<pw.TableRow> _buildPDFChildren(FoodController foodController) {
    final List<pw.TableRow> r = [];

    for (final foodEntry in foodController.foodOrders.entries) {
      r.add(pw.TableRow(
        children: <pw.Widget>[
          pw.Text(foodEntry.key.name),
          pw.Text('Quantity: ${foodEntry.value}'),
          pw.Text('Cost: ¢${foodEntry.value * foodEntry.key.cost}')
        ],
      ));
    }
    for (final drinkEntry in foodController.drinkOrders.entries) {
      r.add(pw.TableRow(
        children: <pw.Widget>[
          pw.Text(drinkEntry.key.name),
          pw.Text('Quantity: ${drinkEntry.value}'),
          pw.Text('Cost: ¢${drinkEntry.value * drinkEntry.key.cost}')
        ],
      ));
    }
    return r;
  }
}
