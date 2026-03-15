import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:core_care/main.dart';
import 'package:core_care/profile_decoration.dart';
import 'package:core_care/decoration.dart';
import 'home_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  static bool hasImage = false;
  static Uint8List imageBytes = Uint8List(0);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  Future<void> pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      maxHeight: 1080,
      maxWidth: 1080,
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      XFile? imageFile = XFile(pickedImage.path);
      ProfilePage.imageBytes = await imageFile.readAsBytes();
      setState(() {
        ProfilePage.hasImage = true;
      });
    }
  }
  void removeImage(){
    setState(() {
      ProfilePage.hasImage = false;
    });
  }

  void _showDialog(){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text("Edit Profile Image"),
        actions: [
          OutlinedButton(onPressed: (){
            removeImage();
            Navigator.pop(context);
          }, child: Text('Remove Image')),
          FilledButton(onPressed: (){
            pickImage();
            Navigator.pop(context);
          }, child: Text('Change Image')),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(40),
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: -150,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 60, 20, 15),
                      child: Column(
                        children: [
                          Text(
                            "User",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Text(
                            "user.new@aust.edu",
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.tertiary,
                                    child: Emoji.starter,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Starter",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                  Text(
                                    "110 XP",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelSmall,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.tertiary,
                                    child: Emoji.fire,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "3 day",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                  Text(
                                    "Streak",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelSmall,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.tertiary,
                                    child: Emoji.coin,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "100 FC",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                  Text(
                                    "FitCoins",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelSmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.chevron_left_rounded, size: 40),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Text(
                      "Profile",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        if (!ProfilePage.hasImage)
                          CircleAvatar(
                            backgroundColor: CustomColors.greyLight(context),
                            radius: 37,
                            child: Icon(Icons.person, size: 40),
                          )
                        else
                          CircleAvatar(
                            radius: 37,
                            foregroundImage: MemoryImage(ProfilePage.imageBytes),
                          ),
                        Positioned(
                          right: -5,
                          bottom: -5,
                          child: SizedBox(
                            height: 24,
                            width: 24,
                            child: IconButton.filled(
                              style: IconButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.tertiary,
                              ),
                              padding: const EdgeInsets.all(0),
                              onPressed: () {
                                if(ProfilePage.hasImage){
                                  _showDialog();
                                }
                                else{
                                  pickImage();
                                }
                              },
                              icon: ProfilePage.hasImage
                                  ? Icon(Icons.edit)
                                  : Icon(Icons.camera_alt),
                              iconSize: 18,
                              tooltip: "Add",
                              color: Theme.of(context).colorScheme.onTertiary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 150),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 10,
                ),
                child: ListView(
                  children: [
                    profileTile(Emoji.profile, 'Personal Information', 'Identity and body stats', ProfileWidgets.profileList(context), "Personal info", EditSheets.profileEdit, context),
                    const SizedBox(height: 10,),
                    profileTile(Emoji.stat, 'Body Stats', 'Identity and body stats', ProfileWidgets.statList(context), "Body Stats", EditSheets.statEdit, context),
                    const SizedBox(height: 10,),
                    profileTile(Emoji.fit, 'Fitness Profile', 'Activity & Goals', ProfileWidgets.fitList(context), "Fitness Profile", EditSheets.fitEdit, context),
                    const SizedBox(height: 10,),
                    profileTile(Emoji.diet, 'Diet Profile', 'Meal & Diet preferences', ProfileWidgets.dietList(context), "Diet Preferences", EditSheets.dietEdit, context),
                    const SizedBox(height: 10,),
                    profileTile(Emoji.med, 'Health & Conditions', 'Medical Conditions and allergies', ProfileWidgets.medList(context), "Health info", EditSheets.medEdit, context),
                    const SizedBox(height: 10,),
                    profileTile(Emoji.time, 'Schedule', 'Daily routine & workout timing', ProfileWidgets.timeList(context), "Schedule", EditSheets.timeEdit, context),
                    const SizedBox(height: 10,),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text('App Settings'),
                        leading: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.tertiary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Emoji.settings,
                        ),
                        trailing: IconButton(onPressed: (){
                          Navigator.pushNamed(context, '/settings');
                        }, icon: Icon(Icons.chevron_right)),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 50),
                      child: OutlinedButton(onPressed: (){
                        showDialog(context: context, builder: (BuildContext context){
                          return AlertDialog(
                            title: Text('Log Out',),
                            content: Text('Do you want to sign out from the account?', style: Theme.of(context).textTheme.labelLarge,),
                            actions: [
                              OutlinedButton(onPressed: (){
                                Navigator.of(context).pop();
                              }, child: Text('Cancel')),
                              FilledButton(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Theme.of(context).colorScheme.error,
                                  ),
                                  onPressed: () async{
                                    await HomeScreen.logUserOut();
                                    if(context.mounted){
                                      Navigator.of(context).pushNamedAndRemoveUntil('/auth', (route) => false);
                                    }
                                  }, child: Text('Log out')),
                            ],
                          );
                        });
                      }, child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          child: Row(children: [Icon(Icons.logout), const SizedBox(width: 10,), Text('Log Out')],))),
                    ),
                    const SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 50),
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Theme.of(context).colorScheme.error),
                            foregroundColor: Theme.of(context).colorScheme.error,
                          ),
                          onPressed: (){
                            showDialog(context: context, builder: (BuildContext context){
                              return AlertDialog(
                                title: Text('Delete Account', style: TextStyle(color: Theme.of(context).colorScheme.error),),
                                content: Text('Do you really want to delete your account?', style: Theme.of(context).textTheme.labelLarge,),
                                actions: [
                                  OutlinedButton(onPressed: (){
                                    Navigator.of(context).pop();
                                  }, child: Text('Cancel')),
                                  FilledButton(
                                      style: FilledButton.styleFrom(
                                        backgroundColor: Theme.of(context).colorScheme.error,
                                      ),
                                      onPressed: (){}, child: Text('Delete')),
                                ],
                              );
                            });
                          }, child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          child: Row(children: [Icon(Icons.delete), const SizedBox(width: 10,), Text('Delete Account')],))),
                    ),
                    const SizedBox(height: 30,),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget profileTile(Image img, String title, String sub, Widget list, String edit, void Function(BuildContext) function, BuildContext context){
    return ExpansionTile(
      collapsedBackgroundColor: Theme.of(context).colorScheme.surface,
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide.none,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Theme.of(context).colorScheme.primary,),
      ),
      leading: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: img,
      ),
      title: Text(title,),
      subtitle: Text(sub, style: Theme.of(context).textTheme.labelSmall,),
      children: [
        Divider(height: 1, color: CustomColors.greyDark(context),),
        list,
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 120),
          child: Center(
            child: OutlinedButton(onPressed: () => function(context), child: Row(children: [Icon(Icons.edit),const SizedBox(width: 8,),Text("Edit $edit")])),
          ),
        ),
        const SizedBox(height: 15,),
      ],
    );
  }
}