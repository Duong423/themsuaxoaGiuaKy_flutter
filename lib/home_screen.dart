// ignore_for_file: prefer_const_constructors, avoid_print, unused_local_variable, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, curly_braces_in_flow_control_structures, prefer_final_fields, unused_import

import 'dart:io';

import 'package:app_gk/Login%20SignUp/Services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';

import 'Login SignUp/Screen/login.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _loaiController = TextEditingController();
  final TextEditingController _giaController = TextEditingController();

  CollectionReference _users = FirebaseFirestore.instance.collection("users");
  String imageUrl = '';
  /////add
  _addUser() async {
    await _users.add({
      'name': _nameController.text,
      'loai': _loaiController.text,
      'gia': _giaController.text,
      'imageUrl': imageUrl, // Lưu URL hình ảnh
    });

    _nameController.clear();
    _loaiController.clear();
    _giaController.clear();
  }

  ////delete
  void _deleteUser(String userId) {
    _users.doc(userId).delete();
  }

  ///edit
  void _editUser(DocumentSnapshot user) {
    _nameController.text = user['name'];
    _loaiController.text = user['loai'];
    _giaController.text = user['gia'];

    /////form sua
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Sửa sản phẩm"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "tên sp"),
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _loaiController,
                  decoration: InputDecoration(labelText: "loại sp"),
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _giaController,
                  decoration: InputDecoration(labelText: "giá sp"),
                ),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Hủy")),
              ElevatedButton(
                  onPressed: () {
                    _updateUser(user.id);
                    Navigator.pop(context);
                  },
                  child: Text("Cập nhật")),
            ],
          );
        });
  }

  ///update
  void _updateUser(String userId) {
    _users.doc(userId).update({
      'name': _nameController.text,
      'loai': _loaiController.text,
      'gia': _giaController.text,
    });
    _nameController.clear();
    _loaiController.clear();
    _giaController.clear();
  }

  // lấy ảnh
  String? selectedFileName;
  Uint8List? selectedFileBytes; // Thay đổi kiểu từ List<int> thành Uint8List

  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image, // Chỉ cho phép chọn tệp hình ảnh
      );

      if (result != null) {
        setState(() {
          selectedFileName = result.files.single.name; // Lấy tên tệp
          selectedFileBytes = result.files.single.bytes; // Lấy bytes
        });
        print('Tên tệp: $selectedFileName');
        print('Byte của tệp: ${selectedFileBytes?.length}');
      } else {
        print('Không có tệp nào được chọn.');
      }
    } catch (e) {
      print('Đã xảy ra lỗi khi chọn tệp: $e');
    }
  }
/// up lên storage
  Future<void> uploadFileToStorage() async {
    if (selectedFileBytes == null) {
      print('Chưa có tệp nào được chọn để tải lên');
      return;
    }

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    // Tham chiếu đến thư mục images
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    try {
      // Tải tệp lên Firebase Storage bằng cách sử dụng dữ liệu byte và kiểu MIME
      await referenceImageToUpload.putData(
        selectedFileBytes!,
        SettableMetadata(contentType: 'image/jpg'), // Hoặc 'image/png'
      );

      // Lấy URL của tệp đã tải lên
      imageUrl = await referenceImageToUpload.getDownloadURL();
      print('Tải lên thành công, URL: $imageUrl');

      /// lưu
    } catch (error) {
      print('Lỗi khi tải lên tệp: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dữ liệu sản phẩm",
          style: TextStyle(color: Colors.white),
        ), 
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await AuthMethod().googleSignOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  ); // Gọi phương thức đăng xuất
              // Điều hướng đến màn hình đăng nhập nếu cần
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Nhap ten sp"),
            ),
            SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: _loaiController,
              decoration: InputDecoration(labelText: "Nhap loai sp"),
            ),
            SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: _giaController,
              decoration: InputDecoration(labelText: "Nhap gia sp"),
            ),
            SizedBox(
              height: 16,
            ),
            IconButton(
                onPressed: () async {
                  await pickFile();
                  
                  //////////ÚP ẢNH SỬ DỤNG NỀN TẢNG MOBILE//////
                  /*ImagePicker imagePicker = ImagePicker();
                  XFile? file =
                      await imagePicker.pickImage(source: ImageSource.gallery);
                  print('${file?.path}');*/

                  /*if (selectedFilePath == null) return;
                  String uniqueFileName =
                      DateTime.now().millisecondsSinceEpoch.toString();

                  /**upload đến storage */

                  //tham chieu den thu muc images
                  Reference referenceRoot = FirebaseStorage.instance.ref();
                  Reference referenceDirImages = referenceRoot.child('images');
                  //tham chieu den anh dc lua tru
                  Reference referenceImageToUpload =
                      referenceDirImages.child(uniqueFileName);
                  try {
                    await referenceImageToUpload
                        .putFile(File(selectedFilePath!.bytes));
                    //tai url
                    imageUrl = await referenceImageToUpload.getDownloadURL();
                  } catch (error) {
                    //Loi
                  }*/
                },
                icon: Icon(Icons.camera_alt)),
            if (selectedFileName != null) ...[
              SizedBox(height: 20),
              Text('Tệp đã chọn: $selectedFileName'),
            ],
            SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () async {
                await _addUser();
                await uploadFileToStorage();
              },
              child: Text("Them "),
            ),
            SizedBox(
              height: 16,
            ),
            Expanded(
                child: StreamBuilder(
              stream: _users.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var user = snapshot.data!.docs[index];

                    return Dismissible(
                      key: Key(user.id),
                      background: Container(
                        color: Colors.redAccent,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 16),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (direction) {
                        _deleteUser(user.id);
                      },
                      direction: DismissDirection.endToStart,
                      child: Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(8.0),
                          // Sử dụng Row để hiển thị ảnh và thông tin sản phẩm theo hàng ngang
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Hiển thị hình ảnh từ URL
                              user['imageUrl'] != null && user['imageUrl'].isNotEmpty
                                  ? Image.network(
                                      user['imageUrl'],
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      width: 80,
                                      height: 80,
                                      color: Colors.grey[300],
                                      child: Icon(Icons.image_not_supported),
                                    ),
                              SizedBox(width: 16),
                              SizedBox(
                                  width:
                                      16), // Khoảng cách giữa ảnh và thông tin

                              // Hiển thị thông tin sản phẩm
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Tên sp: ',
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          TextSpan(
                                            text: user['name'],
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Giá sp: ',
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          TextSpan(
                                            text: user['gia'],
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Loại sp: ',
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          TextSpan(
                                            text: user['loai'],
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          trailing: Column(
                            children: [
                              IconButton(
                                onPressed: () {
                                  _editUser(user);
                                },
                                icon: Icon(Icons.edit),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}
