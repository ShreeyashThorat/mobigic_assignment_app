import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobigic_assignment/data/model/media_model.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../data/logic/files/bloc/file_action_bloc.dart';
import '../../widgets/loading_widgets.dart';
import '../../widgets/my_button.dart';
import '../../widgets/my_textfield.dart';

class ActionMenu extends StatefulWidget {
  final MediaModel file;
  final Function() remove;
  const ActionMenu({super.key, required this.file, required this.remove});

  @override
  State<ActionMenu> createState() => _ActionMenuState();
}

class _ActionMenuState extends State<ActionMenu> {
  final FileActionBloc fileActionBloc = FileActionBloc();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FileActionBloc, FileActionState>(
      bloc: fileActionBloc,
      listener: (context, state1) {
        if (state1 is FileActionLoading) {
          log("loading");
          LoadingWidgets.showLoading(context);
        } else if (state1 is FileActionSuccessful) {
          if (state1.removeFile == true) {
            widget.remove();
          }
          Navigator.of(context).pop();
          LoadingWidgets.showSnackBar(context, state1.message);
        } else if (state1 is FileActionError) {
          Navigator.of(context).pop();
          LoadingWidgets.showSnackBar(context, state1.exception.message!);
        }
      },
      builder: (context, state1) {
        return PopupMenuButton<String>(
          color: Colors.white,
          onSelected: (value) async {
            debugPrint(widget.file.mediaPass!);
            await showMyDialog(context, widget.file.mediaPass!)
                .then((val) async {
              if (val == "true") {
                if (value == "delete") {
                  fileActionBloc.add(DeleteFileEvent(id: widget.file.mediaId!));
                } else if (value == "download") {
                  await Permission.storage.request().then((status) {
                    if (status.isGranted) {
                      fileActionBloc.add(DownloadFileEvent(
                          url: widget.file.mediaUrl!,
                          filename: widget.file.fileName!));
                    } else if (status.isDenied) {
                      LoadingWidgets.showSnackBar(context,
                          "Storage permission denied. Please grant permission to download files.");
                    } else if (status.isPermanentlyDenied) {
                      LoadingWidgets.showSnackBar(context,
                          "Storage permission permanently denied. Please enable it from settings.");
                    }
                  });
                }
              } else {
                LoadingWidgets.showSnackBar(
                    context, "Your have entered wrong password");
              }
            });
          },
          itemBuilder: (BuildContext contesxt) {
            return [
              const PopupMenuItem(
                value: "delete",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Delete"),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.delete_forever_rounded,
                      size: 18,
                    )
                  ],
                ),
              ),
              const PopupMenuItem(
                value: "share",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Share"),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.ios_share_rounded,
                      size: 18,
                    )
                  ],
                ),
              ),
              const PopupMenuItem(
                value: "download",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Download"),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.file_download_rounded,
                      size: 18,
                    )
                  ],
                ),
              ),
            ];
          },
        );
      },
    );
  }

  Future<void> requestPhotosPermissionAndOpenGallery() async {}

  Future<String> showMyDialog(BuildContext context, String password) async {
    TextEditingController filePassword = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter file password'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                MyTextField(
                  controller: filePassword,
                  hintText: "Password",
                  maxLines: 1,
                  maxLength: 6,
                  radius: 8,
                  isObscure: true,
                  verticalPadding: 10,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            MyElevatedButton(
              onPress: () {
                if (password == filePassword.text.trim()) {
                  Navigator.pop(context, "true");
                } else {
                  Navigator.pop(context, "false");
                }
              },
              elevation: 0,
              height: 35,
              buttonContent: const Text(
                "SUBMIT",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );

    return result ?? "false";
  }
}
