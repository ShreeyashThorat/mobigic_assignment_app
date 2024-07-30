import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:mobigic_assignment/data/local%20database/local_db.dart';
import 'package:mobigic_assignment/data/logic/files/bloc/get_files_bloc.dart';
import 'package:mobigic_assignment/data/model/user%20model/user_model.dart';
import 'package:mobigic_assignment/utils/constant_data.dart';
import 'package:mobigic_assignment/views/auth/login_screen.dart';
import 'package:mobigic_assignment/views/dashboard/action_menu.dart';
import 'package:mobigic_assignment/widgets/loading_widgets.dart';
import 'package:path/path.dart' as path;

import '../../data/logic/files/bloc/upload_files_bloc.dart';
import '../../widgets/my_button.dart';

class DashboardScreen extends StatefulWidget {
  final UserModel userdata;
  const DashboardScreen({super.key, required this.userdata});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GetFilesBloc getFilesBloc = GetFilesBloc();
  final UploadFilesBloc uploadFilesBloc = UploadFilesBloc();

  @override
  void initState() {
    getFilesBloc.add(GetMyFilesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hi, ${widget.userdata.firstName} ${widget.userdata.lastName}",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
              Text(
                "${widget.userdata.email}",
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
            ],
          ),
          actions: [
            BlocListener<UploadFilesBloc, UploadFilesState>(
              bloc: uploadFilesBloc,
              listener: (context, state) {
                if (state is UploadFileLoading) {
                  LoadingWidgets.showLoading(context);
                } else if (state is UploadFileError) {
                  Navigator.of(context).pop();
                  LoadingWidgets.showSnackBar(
                      context, state.exception.message!);
                } else if (state is UploadFileSuccessfully) {
                  Navigator.of(context).pop();
                  getFilesBloc.add(AddFileEvent(file: state.file));
                  Future.delayed(const Duration(seconds: 1), () {
                    setState(() {});
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title:
                              Text('Your password for ${state.file.fileName}'),
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(state.file.mediaPass!),
                              IconButton(
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(
                                        text: state.file.mediaPass!));
                                  },
                                  icon: const Icon(Icons.copy_rounded))
                            ],
                          ),
                          actions: <Widget>[
                            MyElevatedButton(
                              onPress: () {
                                Navigator.of(context).pop();
                              },
                              elevation: 0,
                              height: 35,
                              buttonContent: const Text(
                                "OK",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        );
                      });
                  });
                  
                }
              },
              child: IconButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();

                    if (result != null) {
                      File file = File(result.files.single.path!);
                      uploadFilesBloc.add(UploadFile(file: file));
                    }
                  },
                  icon: SvgPicture.asset(
                      width: 24, height: 24, ConstantImages.uploadFile)),
            ),
            IconButton(
                onPressed: () async {
                  LoadingWidgets.showLoading(context);
                  await LocalDatabase.deleteUserData().then((val) =>
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                          (Route<dynamic> route) => false));
                },
                icon: SvgPicture.asset(
                    width: 24, height: 24, ConstantImages.logout))
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(5),
            child: Container(
              color: Colors.grey[200],
              height: 1,
            ),
          ),
        ),
        body: BlocConsumer<GetFilesBloc, GetFilesState>(
          bloc: getFilesBloc,
          listener: (context, state) {},
          builder: (context, state) {
            if (state is GetFilesLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              );
            } else if (state is GetFilesError) {
              return Center(
                child: Text(state.exception.message ?? "Something went wrong"),
              );
            } else if (state is GetFilesSuccessfully && state.files.isEmpty) {
              return const Center(
                child: Text("No Files, Upload files"),
              );
            } else if (state is GetFilesSuccessfully &&
                state.files.isNotEmpty) {
              return ListView.builder(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.025, vertical: 10),
                  itemCount: state.files.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.025, vertical: 10),
                          child: Row(
                            children: [
                              getFileExtension(state.files[index].mediaUrl!) !=
                                      "image"
                                  ? Image(
                                      width: size.width * 0.08,
                                      height: size.width * 0.08,
                                      fit: BoxFit.cover,
                                      image: AssetImage(getFileExtension(
                                          state.files[index].mediaUrl!)),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: CachedNetworkImage(
                                          key: UniqueKey(),
                                          alignment: Alignment.center,
                                          fit: BoxFit.contain,
                                          width: size.width * 0.08,
                                          height: size.width * 0.08,
                                          fadeInDuration:
                                              const Duration(milliseconds: 200),
                                          fadeInCurve: Curves.easeInOut,
                                          imageUrl:
                                              state.files[index].mediaUrl!,
                                          errorWidget: (context, url, error) =>
                                              const SizedBox(),
                                          placeholder: (context, url) {
                                            return Container(
                                              width: size.width * 0.08,
                                              height: size.width * 0.08,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  color: Colors.grey.shade200),
                                            );
                                          }),
                                    ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.files[index].fileName!,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    "Modified at ${formatDate(state.files[index].updatedAt!)}",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              ActionMenu(
                                  file: state.files[index],
                                  remove: () {
                                    getFilesBloc
                                        .add(RemoveFileEvent(index: index));
                                    Future.delayed(const Duration(seconds: 1),
                                        () {
                                      setState(() {});
                                    });
                                  })
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.grey.shade200,
                          height: 1,
                        )
                      ],
                    );
                  });
            }
            return Container();
          },
        ));
  }

  String getFileExtension(String filePath) {
    final extension = path.extension(filePath).toLowerCase();
    switch (extension) {
      case '.pdf':
        return ConstantImages.pdf;
      case '.doc':
      case '.docx':
      case '.dot':
      case '.dotx':
        return ConstantImages.doc;
      case '.xls':
      case '.xlsx':
      case '.xlsm':
      case '.csv':
        return ConstantImages.excel;
      case '.jpg':
      case '.jpeg':
      case '.png':
      case '.gif':
      case '.bmp':
      case '.webp':
        return "image";
      case '.mp4':
      case '.mkv':
      case '.avi':
      case '.mov':
      case '.wmv':
      case '.flv':
        return ConstantImages.audio;
      case '.mp3':
      case '.wav':
      case '.flac':
      case '.aac':
      case '.ogg':
        return ConstantImages.mp3;
      case '.txt':
      case '.log':
      case '.md':
        return ConstantImages.txt;
      default:
        return ConstantImages.googleDocs;
    }
  }

  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('d MMMM yyyy').format(dateTime);
  }
}
