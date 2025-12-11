import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

import '../../data/models/work_entity.dart';
import '../../logic/blocs/work/work_bloc.dart';

// Widget giả lập (giữ nguyên của bạn)
class PhoneHighlighter extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const PhoneHighlighter({super.key, required this.text, this.style});

  @override
  Widget build(BuildContext context) {
    final RegExp phoneRegex = RegExp(r'\b(84|0[3|5|7|8|9])([0-9]{8})\b');

    final List<TextSpan> spans = [];
    int start = 0;

    // Tìm tất cả các số điện thoại trong chuỗi text
    for (final match in phoneRegex.allMatches(text)) {
      // 1. Thêm đoạn text thường nằm trước số điện thoại
      if (match.start > start) {
        spans.add(TextSpan(
          text: text.substring(start, match.start),
          style: style, // Dùng style mặc định truyền vào
        ));
      }

      final String phoneNumber = match.group(0)!;

      spans.add(
        TextSpan(
          text: phoneNumber,
          style: (style ?? const TextStyle()).copyWith(
            color: Colors.blue[700], // Màu xanh nổi bật
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline, // Gạch chân cho giống link
            decorationColor: Colors.blue[300],
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              // Xử lý gọi điện
              final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
              if (await canLaunchUrl(launchUri)) {
                await launchUrl(launchUri);
              } else {
                print("Không thể gọi số này: $phoneNumber");
              }
            },
        ),
      );
      start = match.end;
    }

    // 3. Thêm đoạn text còn lại sau số điện thoại cuối cùng
    if (start < text.length) {
      spans.add(TextSpan(
        text: text.substring(start),
        style: style,
      ));
    }

    // Nếu không tìm thấy số nào, trả về text thường cho nhanh
    if (spans.isEmpty) {
      return Text(text, style: style, maxLines: 3, overflow: TextOverflow.ellipsis);
    }

    // Trả về RichText hỗ trợ highlight
    return RichText(
      maxLines: 3, // Giới hạn 3 dòng như ý bạn
      overflow: TextOverflow.ellipsis, // Cắt đuôi ... nếu dài quá
      text: TextSpan(
        style: style ?? DefaultTextStyle.of(context).style,
        children: spans,
      ),
    );
  }
}

class SearchWorkScreen extends StatefulWidget {
  const SearchWorkScreen({super.key});

  @override
  State<SearchWorkScreen> createState() => _SearchWorkScreenState();
}

class _SearchWorkScreenState extends State<SearchWorkScreen> {
  late ScrollController _scrollController;

  // 1. Cấu hình chiều cao item
  // Giảm nhẹ chiều cao xuống 180 để 2 item dễ vừa màn hình điện thoại hơn
  final double _itemHeight = 180.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    context.read<WorkBloc>().add(const LoadWorks());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // 2. Hàm Snap: Vẫn snap vào index chẵn hoặc lẻ, nhưng logic hiển thị sẽ khác
  void _onScrollEnded() {
    if (!_scrollController.hasClients) return;

    final double offset = _scrollController.offset;
    // Tìm index gần nhất
    int index = (offset / _itemHeight).round();

    // Animation trượt tới vị trí đó
    _scrollController.animateTo(
      index * _itemHeight,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutBack,
    );
  }

  @override
  Widget build(BuildContext context) {
    // 3. TÍNH PADDING MỚI
    // Mục tiêu: Hiển thị 2 item ở giữa màn hình.
    // Công thức: (Chiều cao màn hình - (Chiều cao 1 item * 2)) / 2
    final double screenHeight = MediaQuery.of(context).size.height;
    // Dùng math.max để tránh lỗi nếu màn hình quá bé
    final double verticalPadding = math.max(0.0, (screenHeight - (_itemHeight * 2)) / 2);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Danh sách công việc', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: BlocBuilder<WorkBloc, WorkState>(
        builder: (context, state) {
          if (state is WorkLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WorkLoaded) {
            return NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollEndNotification) {
                  Future.microtask(() => _onScrollEnded());
                }
                return false;
              },
              child: ListView.builder(
                controller: _scrollController,
                // Padding để 2 item đầu tiên nằm giữa màn hình
                padding: EdgeInsets.symmetric(vertical: verticalPadding),
                itemCount: state.works.length,
                itemBuilder: (context, index) {
                  final work = state.works[index];

                  return AnimatedBuilder(
                    animation: _scrollController,
                    builder: (context, child) {
                      double itemPositionOffset = index * _itemHeight;

                      double difference = 0.0;
                      if (_scrollController.hasClients) {

                        difference = (_scrollController.offset + (_itemHeight / 2)) - itemPositionOffset;
                      }

                      double rotation = (difference / 500).clamp(-math.pi / 3, math.pi / 3);

                      // Scale cũng chỉnh lại để 2 item cùng to gần bằng nhau
                      double scale = (1 - (difference.abs() / 1500)).clamp(0.7, 1.0);

                      double opacity = (1 - (difference.abs() / 1000)).clamp(0.3, 1.0);

                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.0025)
                          ..rotateX(-rotation) // Item trên ngửa lên, item dưới ngửa xuống
                          ..scale(scale),
                        child: Opacity(
                          opacity: opacity,
                          child: child,
                        ),
                      );
                    },
                    child: SizedBox(
                      height: _itemHeight,
                      child: _build3DWorkCard(context, work),
                    ),
                  );
                },
              ),
            );
          } else if (state is WorkError) {
            return Center(child: Text('Lỗi: ${state.message}'));
          }
          return const Center(child: Text('Chưa có dữ liệu'));
        },
      ),
    );
  }

  Widget _build3DWorkCard(BuildContext context, WorkEntity work) {
    // Logic màu sắc giữ nguyên
    Color baseColor = Colors.blue;
    if (work.workStatusName?.toLowerCase().contains('hoàn thành') == true) {
      baseColor = Colors.green;
    } else if (work.workStatusName?.toLowerCase().contains('thực hiện') == true) {
      baseColor = Colors.orange;
    }
    Color darkTextColor = Color.lerp(baseColor, Colors.black, 0.6) ?? Colors.black;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.white, baseColor.withOpacity(0.1)],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0), // Padding nhỏ hơn chút cho layout 180px
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        work.workCode,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: baseColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        work.workStatusName ?? 'N/A',
                        style: TextStyle(
                          color: darkTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: PhoneHighlighter(
                    text: work.workDescription ?? 'Không có mô tả',
                    style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.3),
                  ),
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: work.workStaffAvatar != null ? NetworkImage(work.workStaffAvatar!) : null,
                      child: work.workStaffAvatar == null ? Icon(Icons.person, size: 12, color: Colors.grey[600]) : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      work.workStaffName ?? 'Unassigned',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}