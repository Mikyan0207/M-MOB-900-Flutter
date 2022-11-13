import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:flutter_parsed_text_field/flutter_parsed_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:starlight/domain/entities/user_entity.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:starlight/presentation/widgets/messages/dropped_file.dart';
import 'package:starlight/presentation/widgets/messages/dropped_file_widget.dart';
import 'package:velocity_x/velocity_x.dart';

class MessageBar extends StatefulWidget {
  const MessageBar({
    super.key,
    required this.messagePlaceholder,
    required this.onSendMessage,
    required this.members,
  });

  final String messagePlaceholder;

  final Future<void> Function(
    String value,
  ) onSendMessage;

  final List<UserEntity> members;

  @override
  State<MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends State<MessageBar> {
  final FlutterParsedTextFieldController flutterParsedTextFieldController =
      FlutterParsedTextFieldController();

  final FocusNode _textFieldNode = FocusNode();

  late DropzoneViewController controller1;
  String message1 = 'Drop something here';
  bool highlighted1 = false;
  dynamic image;
  late String url;
  late XFile imageFile;
  DroppedFile file = const DroppedFile(url: "", name: "", mime: "", bytes: 0);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: highlighted1 ? const Color(0xFF8667f2) : Colors.transparent,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 25,
                maxHeight: 150,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.black400,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 2.0,
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(
                            Icons.add_circle,
                            color: Vx.gray400,
                          ),
                          onPressed: () async {
                            if (kIsWeb)
                            {
                              await controller1.pickFiles(
                                mime: <String>['image/jpeg', 'image/png'],
                              );
                            }
                            else {
                              final XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

                              imageFile = XFile(pickedFile!.path);
                              final String extension = pickedFile.name
                                  .split('.')
                                  .last
                                  .toString();

                              final CroppedFile? croppedImage = await ImageCropper().cropImage(
                                sourcePath: pickedFile.path,
                                maxHeight: 2080,
                                maxWidth: 2080,
                                aspectRatioPresets: <CropAspectRatioPreset>[
                                  CropAspectRatioPreset.square,
                                  CropAspectRatioPreset.ratio3x2,
                                  CropAspectRatioPreset.original,
                                  CropAspectRatioPreset.ratio4x3,
                                  CropAspectRatioPreset.ratio16x9
                                ],
                                uiSettings: <PlatformUiSettings>[
                                  AndroidUiSettings(
                                    toolbarTitle: 'Cropper',
                                    toolbarColor: Colors.deepOrange,
                                    toolbarWidgetColor: Colors.white,
                                    initAspectRatio: CropAspectRatioPreset.original,
                                    lockAspectRatio: false,
                                  ),
                                  IOSUiSettings(
                                    title: 'Cropper',
                                  ),
                                  WebUiSettings(
                                    context: context,
                                  ),
                                ],
                              );

                              if (croppedImage != null) {
                                imageFile = XFile(croppedImage.path);
                                final DroppedFile droppedFile = DroppedFile(
                                  url: croppedImage.path,
                                  name: pickedFile.name,
                                  mime: 'image/png',
                                  bytes: 0,
                                );
                                setState(() {
                                  file = droppedFile;
                                });
                              }
                            }
                          },
                        ),
                        Expanded(
                          child: Stack(
                            children: <Widget>[
                              if (kIsWeb) buildDropZone(context) else Container(),
                              if (!file.name.isEmptyOrNull)
                                DroppedFileWidget(key: UniqueKey(), file: file)
                              else
                                Container(),
                              Form(
                                key: UniqueKey(),
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxHeight: 150,
                                  ),
                                  child: FlutterParsedTextField(
                                    focusNode: _textFieldNode,
                                    autofocus: Vx.isWeb || Vx.isDesktop,
                                    onSubmitted: (String? value) async {
                                      if (!file.name.isEmptyOrNull) {
                                        try {
                                          final String extension = file.name
                                              .split('.')
                                              .last
                                              .toString();
                                          final Reference ref = FirebaseStorage
                                              .instance
                                              .ref()
                                              .child('ImageMessage/')
                                              .child(DateTime.now().toString());
                                          final SettableMetadata newMetadata =
                                              SettableMetadata(
                                            cacheControl: "public,max-age=300",
                                            contentType: "image/$extension",
                                          );

                                          if (kIsWeb)
                                          {
                                            await ref.putData(
                                              await controller1
                                                  .getFileData(image),
                                              newMetadata,
                                            );
                                          }
                                          else {
                                            await ref.putData(await imageFile!.readAsBytes(), newMetadata);
                                          }

                                          await Fluttertoast.showToast(
                                            msg: "Image uploaded",
                                          );
                                          url = await ref.getDownloadURL();
                                          flutterParsedTextFieldController
                                              .text = url;
                                        } catch (e) {
                                          await Fluttertoast.showToast(
                                            msg: e.toString(),
                                          );
                                        }
                                      }

                                      final String content =
                                          flutterParsedTextFieldController
                                              .stringify()
                                              .trim();

                                      flutterParsedTextFieldController.clear();
                                      await widget.onSendMessage.call(content);
                                      _textFieldNode.unfocus();
                                      _textFieldNode.requestFocus();

                                      setState(() {
                                        highlighted1 = false;
                                        url = "";
                                        file = const DroppedFile(
                                          url: "",
                                          name: "",
                                          mime: "",
                                          bytes: 0,
                                        );
                                      });
                                    },
                                    suggestionPosition:
                                        SuggestionPosition.above,
                                    matchers: <Matcher<dynamic>>[
                                      Matcher<UserEntity>(
                                        trigger: "@",
                                        style: const TextStyle(
                                          color: AppColors.primaryColor,
                                        ),
                                        suggestions: widget.members,
                                        idProp: (dynamic suggestion) =>
                                            suggestion.id,
                                        displayProp: (dynamic suggestion) =>
                                            suggestion.username,
                                        stringify: (
                                          String trigger,
                                          dynamic suggestion,
                                        ) {
                                          return '[$trigger${suggestion.username}:${suggestion.id}]';
                                        },
                                        parse:
                                            (RegExp regex, String suggestion) {
                                          final RegExpMatch? match =
                                              regex.firstMatch(suggestion);

                                          if (match != null) {
                                            return UserEntity(
                                              id: match.group(3)!,
                                              username: match.group(2)!,
                                            );
                                          }

                                          return UserEntity();
                                        },
                                        parseRegExp:
                                            RegExp(r"\[(@([^\]]+)):([^\]]+)\]"),
                                      ),
                                    ],
                                    textInputAction: TextInputAction.send,
                                    controller:
                                        flutterParsedTextFieldController,
                                    maxLines: null,
                                    keyboardType: TextInputType.multiline,
                                    style: const TextStyle(
                                      color: Vx.gray100,
                                    ),
                                    cursorColor: Vx.gray400,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      hintStyle: TextStyle(
                                        color: Vx.gray500,
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .subtitle2!
                                            .fontSize,
                                      ),
                                      hintText: widget.messagePlaceholder,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: VerticalDivider(
                                thickness: context.isMobile ? 1 : 0.5,
                                color: Vx.gray400,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.send,
                                color: Vx.indigo300,
                              ),
                              onPressed: () async {
                                if (!file.name.isEmptyOrNull) {
                                  try {
                                    final String extension =
                                        file.name.split('.').last.toString();
                                    final Reference ref = FirebaseStorage
                                        .instance
                                        .ref()
                                        .child('ImageMessage/')
                                        .child(DateTime.now().toString());
                                    final SettableMetadata newMetadata =
                                        SettableMetadata(
                                      cacheControl: "public,max-age=300",
                                      contentType: "image/$extension",
                                    );

                                    if (kIsWeb)
                                    {
                                      await ref.putData(
                                        await controller1
                                            .getFileData(image),
                                        newMetadata,
                                      );
                                    }
                                    else {
                                      await ref.putData(await imageFile!.readAsBytes(), newMetadata);
                                    }

                                    await Fluttertoast.showToast(
                                      msg: "Image uploaded",
                                    );
                                    url = await ref.getDownloadURL();
                                    flutterParsedTextFieldController.text = url;
                                  } catch (e) {
                                    await Fluttertoast.showToast(
                                      msg: e.toString(),
                                    );
                                  }
                                }

                                final String content =
                                    flutterParsedTextFieldController
                                        .stringify()
                                        .trim();

                                flutterParsedTextFieldController.clear();
                                await widget.onSendMessage.call(content);
                                setState(() {
                                  highlighted1 = false;
                                  url = "";
                                  file = const DroppedFile(
                                    url: "",
                                    name: "",
                                    mime: "",
                                    bytes: 0,
                                  );
                                });
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDropZone(BuildContext context) => Builder(
        builder: (BuildContext context) => ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 50,
          ),
          child: DropzoneView(
            operation: DragOperation.copy,
            cursor: CursorType.grab,
            onCreated: (DropzoneViewController ctrl) => controller1 = ctrl,
            onHover: () {
              setState(() => highlighted1 = true);
            },
            onLeave: () {
              setState(() => highlighted1 = false);
            },
            onDrop: (dynamic ev) async {
              final String tempUrl = await controller1.createFileUrl(ev);
              final String tempMime = await controller1.getFileMIME(ev);
              final int tempSize = await controller1.getFileSize(ev);
              final DroppedFile droppedFile = DroppedFile(
                url: tempUrl,
                name: ev.name,
                mime: tempMime,
                bytes: tempSize,
              );
              setState(() {
                message1 = '${ev.name} dropped';
                highlighted1 = false;
                url = tempUrl.toString();
                file = droppedFile;
                image = ev;
              });
              flutterParsedTextFieldController.text = "[Image]";
            },
          ),
        ),
      );
}
