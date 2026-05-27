import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/chat_service.dart';
import '../../data/dummy_data.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService _chatService = ChatService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  void _sendMessage({String? fileUrl, String? fileName, String? fileType}) async {
    final msg = _messageController.text;
    
    // If it's just text and it's empty, return
    if (msg.trim().isEmpty && fileUrl == null) return;
    
    _messageController.clear();

    try {
      await _chatService.sendMessage(msg, fileUrl: fileUrl, fileName: fileName, fileType: fileType);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error sending message: $e")),
        );
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 70, 
      );

      if (image != null) {
        File file = File(image.path);
        await _handleFileUpload(file, 'image');
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'png'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);
        String extension = result.files.single.extension?.toLowerCase() ?? '';
        String type = extension == 'pdf' ? 'pdf' : 'image';
        await _handleFileUpload(file, type);
      }
    } catch (e) {
      debugPrint("Error picking file: $e");
    }
  }

  Future<void> _handleFileUpload(File file, String type) async {
    // 2MB Limit Check
    int sizeInBytes = await file.length();
    if (sizeInBytes > 2 * 1024 * 1024) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("File size must be less than 2MB"), backgroundColor: Colors.orange),
        );
      }
      return;
    }

    setState(() => _isUploading = true);
    
    try {
      // 1. Upload to Firebase Storage
      String? url = await _chatService.uploadFile(file);
      
      if (url != null) {
        // 2. Send Firestore message with the URL
        _sendMessage(
          fileUrl: url, 
          fileName: file.path.split('/').last, 
          fileType: type
        );
      } else {
        throw Exception("Upload failed - check Firebase Storage rules");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Upload Error: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  String _getChatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) return "Today";
    if (messageDate == yesterday) return "Yesterday";
    return DateFormat('MMMM dd, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    const primaryTeal = Color(0xFF38104D);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final doctor = dummyDoctors.first;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(doctor.photoUrl),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(doctor.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          ],
        ),
        elevation: 1,
        backgroundColor: primaryTeal,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0B0329) : const Color(0xFFDED6ED),
        ),
        child: Column(
          children: [
            if (_isUploading)
              const LinearProgressIndicator(
                backgroundColor: Colors.transparent, 
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              ),
            
            // --- Message List ---
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _chatService.getMessages(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
                  
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: primaryTeal));
                  }

                  final docs = snapshot.data!.docs;

                  if (docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle),
                            child: Icon(Icons.lock_outline, size: 40, color: isDark ? Colors.white24 : Colors.grey),
                          ),
                          const SizedBox(height: 16),
                          const Text("Messages are end-to-end encrypted.", 
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    reverse: true,
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
                      final bool isMe = data['senderType'] == 'patient';
                      final timestamp = data['timestamp'] as Timestamp?;
                      final date = timestamp?.toDate() ?? DateTime.now();
                      
                      bool showDateSeparator = false;
                      if (index == docs.length - 1) {
                        showDateSeparator = true;
                      } else {
                        final prevData = docs[index + 1].data() as Map<String, dynamic>;
                        final prevTimestamp = prevData['timestamp'] as Timestamp?;
                        if (prevTimestamp != null) {
                          final prevDate = prevTimestamp.toDate();
                          if (date.day != prevDate.day || date.month != prevDate.month || date.year != prevDate.year) {
                            showDateSeparator = true;
                          }
                        }
                      }

                      return Column(
                        children: [
                          if (showDateSeparator)
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 20),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF182229) : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _getChatDate(date),
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? Colors.white60 : Colors.grey[600]),
                              ),
                            ),
                          _buildMessageBubble(
                            data: data,
                            isMe: isMe,
                            time: DateFormat('hh:mm a').format(date),
                            isDark: isDark,
                            primaryTeal: primaryTeal,
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),

            // --- Input Field ---
            Container(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1F2C34) : Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              style: TextStyle(color: isDark ? Colors.white : Colors.black),
                              decoration: const InputDecoration(
                                hintText: "Message",
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.attach_file, color: Colors.grey),
                            onPressed: _isUploading ? null : _pickFile,
                          ),
                          IconButton(
                            icon: const Icon(Icons.camera_alt, color: Colors.grey),
                            onPressed: _isUploading ? null : () => _pickImage(ImageSource.camera),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  CircleAvatar(
                    backgroundColor: primaryTeal,
                    radius: 24,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white, size: 20),
                      onPressed: () => _sendMessage(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble({
    required Map<String, dynamic> data,
    required bool isMe,
    required String time,
    required bool isDark,
    required Color primaryTeal,
  }) {
    String? fileUrl = data['fileUrl'];
    String? fileType = data['fileType'];
    String? text = data['text'];

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        padding: const EdgeInsets.all(4),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isMe 
            ? (isDark ? const Color(0xFF0A1E55) : const Color(0xFFBEBBD6))
            : (isDark ? const Color(0xFF1F2C34) : Colors.white),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14),
            topRight: const Radius.circular(14),
            bottomLeft: Radius.circular(isMe ? 14 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 14),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), offset: const Offset(0, 1), blurRadius: 1)
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (fileUrl != null)
              GestureDetector(
                onTap: () => launchUrl(Uri.parse(fileUrl), mode: LaunchMode.externalApplication),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: fileType == 'pdf'
                    ? Container(
                        padding: const EdgeInsets.all(12),
                        color: Colors.black.withOpacity(0.05),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.picture_as_pdf, color: Colors.red, size: 30),
                            const SizedBox(width: 10),
                            Flexible(child: Text(data['fileName'] ?? "Document.pdf", overflow: TextOverflow.ellipsis, style: TextStyle(color: isDark ? Colors.white : Colors.black87))),
                          ],
                        ),
                      )
                    : Image.network(
                        fileUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 150, 
                            width: 200, 
                            color: Colors.grey[200],
                            child: const Center(child: CircularProgressIndicator(strokeWidth: 2))
                          );
                        },
                      ),
                ),
              ),
            if (text != null && text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                child: Text(text, style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 15)),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 2, 8, 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(time, style: TextStyle(fontSize: 10, color: isDark ? Colors.white60 : Colors.grey[600])),
                  if (isMe) ...[
                    const SizedBox(width: 4),
                    const Icon(Icons.done_all, size: 14, color: Colors.blueAccent),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
