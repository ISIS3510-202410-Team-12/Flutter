import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:unischedule/services/notifications_service.dart';
import 'package:intl/intl.dart';


class CreateClassPage extends StatefulWidget {
  const CreateClassPage({Key? key}) : super(key: key);

  @override
  _CreateClassPageState createState() => _CreateClassPageState();
}

class _CreateClassPageState extends State<CreateClassPage> {
  DateTime _eventStartTime = DateTime.now();
  String? _selectedReminder;
  String _selectedDuration = '1h'; // Valor inicial


  int _getReminderMinutes(String? reminder) {
    switch (reminder) {
      case '5 minutes before':
        return 5;
      case '15 minutes before':
        return 15;
      case '30 minutes before':
        return 30;
      case '1 hour before':
        return 60;
      default:
        return 0; // No reminder or unhandled value
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _buildAppBar(),
          Expanded(
            child: _buildCreateClassForm(),
          ),
        ]
      ),
      backgroundColor: const Color(0xFFF8F8F8),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: SvgPicture.asset('assets/icons/arrow-left.svg',
            width: 21, height: 24, color: Colors.black),
        onPressed: () {
          context.go('/calendar'); // FIXME - Pop last route, will need to work on navigation stack
        },
      ),
      title: const Text(
        'Create Class',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: SvgPicture.asset('assets/icons/plus.svg',
              width: 24, height: 24, color: Colors.black),
          onPressed: () {

            DateTime notificationTime = _eventStartTime.subtract(Duration(minutes: _getReminderMinutes(_selectedReminder)));
            print('Hora notificacion: ${notificationTime} , minutos antes para el recordatorio:  ${Duration(minutes: _getReminderMinutes(_selectedReminder))} ');
            NotificationService().scheduleNotification(
                title: 'Scheduled Event Reminder',
                body: 'Your event is about to start at ${DateFormat('HH:mm').format(_eventStartTime)}',
                scheduledNotificationDateTime: notificationTime);
            context.go('/calendar');
          },
        ),

      ],
    );
  }

  Widget _buildCreateClassForm() {

    const assistants = <String>[
      'Laura',
      'Gotty',
      'Sebastian',
      'Juan',
      'Lucciano'
    ];
    final MultiSelectController assistantsMultiSelectController = MultiSelectController();

    const reminders = <String>[
      'No reminder',
      'At time of event',
      '5 minutes before',
      '15 minutes before',
      '30 minutes before',
      '1 hour before',
    ];


    const labels = <String>[
      'Uniandes 📚',
      'Work 👩‍💻',
      'Personal ✨',
      'Family 👨‍👩‍👧‍👦',
      'Friends 👯‍',
    ];
    final MultiSelectController labelsMultiSelectController = MultiSelectController();

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          Row(  // TODO add a toggle to switch between one-time and recurrent events
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFD0D5DD), width: 1),
                ),
                child: const Text(
                  'One-Time',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xFF475569),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF9DCC18),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF9DCC18), width: 1),
                ),
                child: const Text(
                  'Recurrent',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFD0D5DD), width: 1),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  height: 56,
                  child: Row(
                    children: <Widget>[
                      const Expanded(
                        child: TextField(
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            color: Color(0xFF475569),
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Event Name',
                            hintStyle: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Color(0xFF475569),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                        child: SvgPicture.asset('assets/icons/signature.svg',
                            width: 24, height: 24, color: const Color(0xFF475569)),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFD0D5DD),
                      width: 1,
                    ),
                  ),
                  height: 1,
                ),
                Container(
                  height: 56,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: MultiSelectDropDown(
                          controller: assistantsMultiSelectController,
                          onOptionSelected: (List<ValueItem> selectedOptions) {},
                          options: assistants.map((key) => ValueItem(label: key, value: key)).toList(),
                          selectionType: SelectionType.multi,
                          chipConfig: const ChipConfig(
                            wrapType: WrapType.scroll,
                            labelStyle: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                          optionTextStyle: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            color: Color(0xFF475569),
                          ),
                          borderColor: Colors.transparent,
                          focusedBorderColor: Colors.transparent,
                          borderWidth: 0,
                          focusedBorderWidth: 0,
                          clearIcon: const Icon(Icons.clear),
                          padding: const EdgeInsets.all(0),
                          hint: 'Assistants',
                          hintStyle: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            color: Color(0xFF475569),
                          ),
                          hintPadding: const EdgeInsets.all(0),
                        ),
                      ),
                      SizedBox(
                          width: 30,
                          child: SvgPicture.asset('assets/icons/person-chalkboard.svg',
                              width: 24, height: 24, color: const Color(0xFF475569)),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFD0D5DD),
                      width: 1,
                    ),
                  ),
                  height: 1,
                ),
                Container(
                  height: 56,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Reminder',
                            hintStyle: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Color(0xFF475569),
                            ),
                          ),
                          items: reminders.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  color: Color(0xFF475569),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedReminder = newValue;
                            });
                          },
                          value: _selectedReminder,
                        ),
                      ),
                      SizedBox(
                          width: 30,
                          child: SvgPicture.asset('assets/icons/stopwatch.svg',
                              width: 24, height: 24, color: const Color(0xFF475569)),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFD0D5DD),
                      width: 1,
                    ),
                  ),
                  height: 1,
                ),
                Container(
                  height: 56,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: MultiSelectDropDown(
                          controller: labelsMultiSelectController,
                          onOptionSelected: (List<ValueItem> selectedOptions) {},
                          options: labels.map((key) => ValueItem(label: key, value: key)).toList(),
                          selectionType: SelectionType.multi,
                          chipConfig: const ChipConfig(
                              wrapType: WrapType.scroll,
                              labelStyle: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                color: Color(0xFFFFFFFF),
                              ),
                          ),
                          optionTextStyle: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            color: Color(0xFF475569),
                          ),
                          borderColor: Colors.transparent,
                          focusedBorderColor: Colors.transparent,
                          borderWidth: 0,
                          focusedBorderWidth: 0,
                          clearIcon: const Icon(Icons.clear),
                          padding: const EdgeInsets.all(0),
                          hint: 'Labels',
                          hintStyle: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            color: Color(0xFF475569),
                          ),
                          hintPadding: const EdgeInsets.all(0),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                        child: SvgPicture.asset('assets/icons/tag.svg',
                            width: 24, height: 24, color: const Color(0xFF475569)),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFD0D5DD), width: 1),
            ),
            width: double.infinity,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                      "Event Color",
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: Color(0xFF475569)
                      )
                  ),
                ),
                EventColorInput(),
              ]
            ),
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () {
              DatePicker.showDateTimePicker(
                context,
                showTitleActions: true,
                minTime: DateTime.now(),
                onConfirm: (date) {
                  setState(() {
                    _eventStartTime = date;
                  });
                },
                currentTime: _eventStartTime,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24), // Ajustado para aumentar la altura
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFD0D5DD), width: 1),
              ),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[ // Aumentado para mover el icono a la derecha
                  SvgPicture.asset('assets/icons/hourglass-start.svg',
                      width: 24, height: 24, color: const Color(0xFF475569)),
                  const SizedBox(width: 12), // Espacio entre el icono y el texto
                  Text(
                    DateFormat('MMMM dd - HH:mm').format(_eventStartTime),
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Color(0xFF475569)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24), // Ajustado para aumentar la altura
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFD0D5DD), width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SvgPicture.asset('assets/icons/calendar-day.svg',
                          width: 24, height: 24, color: const Color(0xFF475569)),
                      const SizedBox(width: 12), // Espaciado entre el icono y el texto
                      Text(
                        DateFormat('EEEE').format(_eventStartTime), // Muestra el día de la semana
                        style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            color: Color(0xFF475569)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Ajustado para aumentar la altura
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFD0D5DD), width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset('assets/icons/clock.svg',
                          width: 24, height: 24, color: const Color(0xFF475569)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedDuration, // Usa la variable de estado para el valor actual
                            items: <String>['1h', '2h', '3h', '4h'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedDuration = newValue!; // Actualiza la variable de estado con la nueva selección
                              });
                            },
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Color(0xFF475569),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () {
              showGeneralDialog(
                context: context,
                barrierDismissible: true,
                barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                barrierColor: Colors.black45,
                transitionDuration: const Duration(milliseconds: 200),
                pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
                  return Center(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: PlaceRecommendationsDialog(),
                    ),
                  );
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF9DCC18).withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFD0D5DD), width: 1),
              ),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                      "Find a Place on Campus",
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: Color(0xFF475569),
                          fontWeight: FontWeight.bold
                      )
                  ),
                  const SizedBox(width: 12),
                  SvgPicture.asset('assets/icons/location-dot.svg',
                      width: 24, height: 24, color: const Color(0xFF475569)),
                ]
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlaceRecommendationsDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width - 24,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
                'Place Recommendations',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                  decoration: TextDecoration.none,
                )
            ),
            Expanded(
              child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  itemBuilder: (BuildContext context, int index) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                                'SD-402',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 20,
                                  color: Color(0xFF475569),
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.bold,
                                )
                            ),
                            SizedBox(height: 4),
                            Text(
                                'Available from 11:00 am to 5:30 pm',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  color: Color(0xFF475569),
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.normal,
                                )
                            ),
                          ],
                        ),
                        Container(
                          width: 80,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8), // Borde redondeado
                            image: const DecorationImage(
                              image: AssetImage('assets/images/buildings/sd.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  separatorBuilder: (BuildContext context, int index) => const Divider(height: 1, color: Color(0xFFD0D5DD)),
                  itemCount: 10
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        color: Color(0xFF9FA5C0),
                        decoration: TextDecoration.none,
                      )
                  ),
                ),
                const SizedBox(width: 48),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                      'Confirm',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        color: Color(0xFF9DCC18),
                        decoration: TextDecoration.none,
                      )
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}


class EventColorInput extends StatefulWidget {
  const EventColorInput({Key? key}) : super(key: key);

  @override
  _EventColorInputState createState() => _EventColorInputState();
}

class _EventColorInputState extends State<EventColorInput> {

  Color currentColor = Colors.deepPurpleAccent;
  void changeColor(Color color) {
    setState(() => currentColor = color);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                titlePadding: const EdgeInsets.all(0.0),
                contentPadding: const EdgeInsets.all(0.0),
                content: SingleChildScrollView(
                  child: ColorPicker(
                    pickerColor: currentColor,
                    onColorChanged: changeColor,
                    colorPickerWidth: 300.0,
                    pickerAreaHeightPercent: 0.7,
                    displayThumbColor: true,
                    enableAlpha: false,
                    paletteType: PaletteType.hsv,
                    pickerAreaBorderRadius: const BorderRadius.all(Radius.circular(16)),
                  ),
                ),
              );
            },
          );
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(currentColor),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        child: const SizedBox(
          width: 24,
          height: 24,
        )
    );
  }
}

