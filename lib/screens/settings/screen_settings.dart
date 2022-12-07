import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager/constants/strings.dart';
import 'package:money_manager/controllers/transaction_controller.dart';
import 'package:money_manager/database/boxes.dart';
import 'package:money_manager/models/category.dart';
import 'package:money_manager/models/transaction.dart';
import 'package:money_manager/screens/settings/edit_profile.dart';
import 'package:money_manager/screens/splashscreen.dart';
import 'package:money_manager/services/notification_service.dart';
import 'package:money_manager/util.dart';
import 'package:money_manager/widgets/menu_widget.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextStyle secTitleStyle = const TextStyle(fontWeight: FontWeight.bold);
  late SharedPreferences prefs;
  bool isNotifiyDaily = false;
  bool isApplockEnable = false;
  TimeOfDay? pickedTime;
  String userName = '';
  String imageString = '';
  late Box box;
  late NotificationService notificationService;

  @override
  void initState() {
    box = Boxes.getStorageBox();
    readSettings();
    notificationService = NotificationService();
    super.initState();
  }

  readSettings() async {
    prefs = await SharedPreferences.getInstance();
    final int hour = prefs.getInt(Strings.reminderHour) ?? 21; //dafult 9:00 PM
    final int minute = prefs.getInt(Strings.reminderMin) ?? 0;

    setState(() {
      isApplockEnable = prefs.getBool(Strings.applockEnable) ?? false;
      isNotifiyDaily = prefs.getBool(Strings.notifyDaily) ?? false;
      userName = box.get('userName', defaultValue: '');
      imageString = box.get('profilePhoto', defaultValue: '');
      pickedTime = TimeOfDay(hour: hour, minute: minute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const MenuWidget(),
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SettingsList(
          contentPadding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          platform: DevicePlatform.web,
          lightTheme: const SettingsThemeData(
            leadingIconsColor: Colors.blue,
            titleTextColor: Colors.blue,
            trailingTextColor: Colors.blue,
          ),
          sections: [
            SettingsSection(
                title: Text(
                  'Profile',
                  style: secTitleStyle,
                ),
                tiles: [
                  CustomSettingsTile(
                      child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Material(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const EditProfile())).whenComplete(() {
                            setState(() {
                              userName = box.get('userName', defaultValue: '');
                              imageString =
                                  box.get('profilePhoto', defaultValue: '');
                            });
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Builder(builder: (context) {
                            return Row(
                              children: [
                                CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage:
                                        Util.getAvatharImage(imageString)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    userName,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                )
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  )),
                ]),
            /* SettingsSection(
                title: Text(
                  'Security',
                  style: secTitleStyle,
                ),
                tiles: [
                  SettingsTile.switchTile(
                      initialValue: isApplockEnable,
                      activeSwitchColor: Colors.blue,
                      onToggle: (val) async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PasscodeScreen()));
                        setState(() {
                          isApplockEnable = val;
                        });
                        await prefs.setBool(Strings.applockEnable, val);
                      },
                      title: const Text('Applock'),
                      leading: const Icon(Icons.lock)),
                  SettingsVisibility(
                    visibe: isApplockEnable,
                    child: SettingsTile(
                      title: Text(
                        'Change Password',
                        style: TextStyle(
                            color:
                                isApplockEnable ? Colors.black : Colors.grey),
                      ),
                      leading: const Icon(Icons.key),
                      enabled: isApplockEnable,
                      onPressed: (context) {},
                    ),
                  ),
                ]),*/
            SettingsSection(
                title: Text(
                  'Notification',
                  style: secTitleStyle,
                ),
                tiles: [
                  SettingsTile.switchTile(
                    initialValue: isNotifiyDaily,
                    activeSwitchColor: Colors.blue,
                    onToggle: (enable) async {
                      if (enable) {
                        enableNotification();
                      } else {
                        notificationService.cancelNotification(1);
                      }
                      setState(() {
                        isNotifiyDaily = enable;
                      });
                      await prefs.setBool(Strings.notifyDaily, enable);
                    },
                    title: const Text('Daily Reminder'),
                    leading: const Icon(Icons.notifications_outlined),
                  ),
                  SettingsTile(
                    title: Text(
                      'Notification Time',
                      style: TextStyle(
                          color: isNotifiyDaily ? Colors.black : Colors.grey),
                    ),
                    leading: Icon(Icons.alarm,
                        color: isNotifiyDaily ? Colors.blue : Colors.grey),
                    enabled: isNotifiyDaily,
                    onPressed: (context) {
                      pickTime(context);
                    },
                    value: Text(
                        pickedTime != null ? pickedTime!.format(context) : '',
                        style: TextStyle(
                            color: isNotifiyDaily ? Colors.blue : Colors.grey,
                            fontWeight: FontWeight.bold)),
                  ),
                ]),
            SettingsSection(
                title: Text(
                  'Others',
                  style: secTitleStyle,
                ),
                tiles: [
                  SettingsTile(
                      title: const Text('Reset Data'),
                      leading: const Icon(Icons.restore),
                      onPressed: (context) {
                        confirmReset(context);
                      }),
                  SettingsTile(
                    title: const Text('Feedback'),
                    leading: const Icon(Icons.feedback_outlined),
                    onPressed: (context) {
                      feedback();
                    },
                  ),
                  SettingsTile(
                    title: const Text('About'),
                    leading: const Icon(Icons.info_outline),
                    onPressed: (context) {
                      showAboutDialog(
                        context: context,
                        applicationIcon: ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: Image.asset('assets/images/appicon.png',
                                width: 50)),
                        applicationName: 'Money Manager',
                        applicationVersion: 'version 1.0.1',
                        children: <Widget>[
                          const Text('Developed by Ihsan Kottupadam')
                        ],
                      );
                    },
                  )
                ])
          ]),
    );
  }

  Future<dynamic> confirmReset(BuildContext ctx) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Warning'),
              content: const Text(
                "This will permanently delete the app's data including your transactions and preferences",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('No')),
                TextButton(
                    onPressed: () {
                      resetData(ctx);
                    },
                    child: const Text('Yes'))
              ],
            ));
  }

  pickTime(BuildContext context) async {
    TimeOfDay? pickedT = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        helpText: 'SELECT REMINDER TIME');

    if (pickedT != null) {
      setState(() {
        pickedTime = pickedT;
      });
      prefs.setInt(Strings.reminderHour, pickedT.hour);
      prefs.setInt(Strings.reminderMin, pickedT.minute);
      enableNotification();
    }
  }

  enableNotification() {
    notificationService.showNotificationDaily(
        id: 1,
        title: 'Money Manager',
        body: 'Have you recorded your transactions today?',
        scheduleTime: pickedTime!);
  }

  resetData(ctx) {
    Hive.box<Transaction>('transactions').clear();
    Hive.box<Category>('categories').clear();
    TransactionController transactionController = Get.find();
    transactionController.filterdList.clear();
    prefs.clear();
    Navigator.pushAndRemoveUntil(
        ctx,
        MaterialPageRoute(
          builder: (ctx) => const SplashScreen(),
        ),
        (route) => false);
  }

  feedback() async {
    final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: 'ihsanpv007@gmail.com',
        query: 'subject=Feedback about Money Manager app&body=');

    if (!await launchUrl(emailLaunchUri)) {
      throw '';
    }
  }
}

class SettingsVisibility extends AbstractSettingsTile {
  final bool visibe;
  final Widget child;
  const SettingsVisibility(
      {Key? key, required this.visibe, required this.child})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Visibility(visible: visibe, child: child);
  }
}
