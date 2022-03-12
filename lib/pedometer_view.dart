import 'package:flutter/material.dart';
import 'package:pedometer_test/pedometer_service.dart';
import 'package:pedometer_test/pedometer_viewmodel.dart';
import 'package:stacked/stacked.dart';

class PedometerView extends StatelessWidget {
  const PedometerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PedometerService>.reactive(
      
        viewModelBuilder: () => PedometerService(),
        onModelReady: (model)=> model.init(),
        builder: (context, model, child) => SafeArea(
              child: Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Steps taken:',
                        style: TextStyle(fontSize: 30),
                      ),
                      Text(
                        model.steps,
                        style: TextStyle(fontSize: 60),
                      ),
                      const Divider(
                        height: 100,
                        thickness: 0,
                        color: Colors.white,
                      ),
                      const Text(
                        'Pedestrian status:',
                        style: TextStyle(fontSize: 30),
                      ),
                      Icon(
                        model.status == 'walking'
                            ? Icons.directions_walk
                            : model.status == 'stopped'
                                ? Icons.accessibility_new
                                : Icons.error,
                        size: 100,
                      ),
                      Center(
                        child: Text(
                          model.status,
                          style: model.status == 'walking' ||
                                  model.status == 'stopped'
                              ? const TextStyle(fontSize: 30)
                              : const TextStyle(
                                  fontSize: 20, color: Colors.red),
                        ),

                  
                      ),
                       SizedBox(height: 10,),
                      Text(' Today Step: ${model.todayStep.toString()}'),
                      SizedBox(height: 10,),
                      Text(' Steps to be saved: ${model.stepsToBeSaved.toString()}'),
                       SizedBox(height: 10,),
                      Text(' Previous step taken: ${model.previousStepsTaken.toString()}'),
                       SizedBox(height: 10,),

                      Text(' Event.step: ${model.myevent.toString()}'),
                       SizedBox(height: 10,),

                      Text(' Case: ${model.mywhere.toString()}')

                     
                     
                    ],
                  ),
                ),
              ),
            ));
  }
}
