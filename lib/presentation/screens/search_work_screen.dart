import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;

// Import các file cần thiết của bạn
import '../../data/models/work_entity.dart';
import '../../logic/blocs/work/work_bloc.dart';

// Widget giả lập
class PhoneHighlighter extends StatelessWidget {
  final String text;
  final TextStyle? style;
  const PhoneHighlighter({super.key, required this.text, this.style});
  @override
  Widget build(BuildContext context) {
    return Text(text, style: style, maxLines: 2, overflow: TextOverflow.ellipsis);
  }
}

class SearchWorkScreen extends StatefulWidget {
  const SearchWorkScreen({super.key});

  @override
  State<SearchWorkScreen> createState() => _SearchWorkScreenState();
}

class _SearchWorkScreenState extends State<SearchWorkScreen> {
  late ScrollController _scrollController;

  // 1. CẤU HÌNH KÍCH THƯỚC
  // Để hiệu ứng 3D và Snapping chuẩn, cần một chiều cao cơ sở (extent)
  final double _itemHeight = 200.0;

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

  // 2. HÀM XỬ LÝ SNAP (Tự động trượt vào giữa)
  void _onScrollEnded() {
    if (!_scrollController.hasClients) return;

    final double offset = _scrollController.offset;
    // Tính index của item đang gần giữa nhất
    int index = (offset / _itemHeight).round();

    // Tính toạ độ chính xác để item đó nằm giữa
    double targetOffset = index * _itemHeight;

    // Animation trượt nhẹ tới vị trí đó
    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Tính toán padding để item đầu tiên nằm giữa màn hình
    // (Chiều cao màn hình / 2) - (Chiều cao item / 2)
    final double centerPadding = MediaQuery.of(context).size.height / 2 - _itemHeight / 2;

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
            // 3. BỌC TRONG NOTIFICATION LISTENER ĐỂ BẮT SỰ KIỆN DỪNG CUỘN
            return NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                // Khi người dùng thả tay và danh sách ngừng trôi
                if (scrollNotification is ScrollEndNotification) {
                  // Gọi hàm snap sau một khoảng trễ cực nhỏ để tránh xung đột gesture
                  Future.microtask(() => _onScrollEnded());
                }
                return false;
              },
              child: ListView.builder(
                controller: _scrollController,
                // 4. PADDING ĐẶC BIỆT: Giúp item đầu/cuối có thể ra giữa
                padding: EdgeInsets.symmetric(vertical: centerPadding),
                itemCount: state.works.length,
                itemBuilder: (context, index) {
                  final work = state.works[index];

                  return AnimatedBuilder(
                    animation: _scrollController,
                    builder: (context, child) {
                      // Tính toán vị trí dựa trên _itemHeight đã cố định
                      double itemPositionOffset = index * _itemHeight;
                      double difference = _scrollController.hasClients
                          ? _scrollController.offset - itemPositionOffset
                          : 0.0;

                      // Logic 3D (đã tinh chỉnh cho mượt hơn với snap)
                      double rotation = (difference / 500).clamp(-math.pi / 6, math.pi / 6);
                      double scale = (1 - (difference.abs() / 1000)).clamp(0.8, 1.0); // Scale nhỏ hơn chút để nổi bật item giữa
                      double opacity = (1 - (difference.abs() / 600)).clamp(0.5, 1.0);

                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateX(-rotation)
                          ..scale(scale),
                        child: Opacity(
                          opacity: opacity,
                          child: child,
                        ),
                      );
                    },
                    // Truyền height vào để đảm bảo layout khớp với tính toán
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
    Color baseColor = Colors.blue;
    if (work.workStatusName?.toLowerCase().contains('hoàn thành') == true) {
      baseColor = Colors.green;
    } else if (work.workStatusName?.toLowerCase().contains('thực hiện') == true) {
      baseColor = Colors.orange;
    }

    Color darkTextColor = Color.lerp(baseColor, Colors.black, 0.6) ?? Colors.black;

    return Container(
      // Margin chỉ để tạo khoảng cách giữa các item, height do SizedBox ở trên quản lý
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Stack(
        children: [
          // Nền trắng + Đổ bóng
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // Bóng đậm hơn chút
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
            ),
          ),

          // Gradient nền
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
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

          // Nội dung
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisSize: MainAxisSize.max, // Bung hết chiều cao có thể
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        work.workCode,
                        style: const TextStyle(
                          fontSize: 20, // To hơn chút
                          fontWeight: FontWeight.w900,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: baseColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        work.workStatusName ?? 'N/A',
                        style: TextStyle(
                          color: darkTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded( // Dùng Expanded để đẩy info xuống, tận dụng khoảng trống
                  child: PhoneHighlighter(
                    text: work.workDescription ?? 'Không có mô tả',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.4),
                  ),
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: work.workStaffAvatar != null ? NetworkImage(work.workStaffAvatar!) : null,
                      child: work.workStaffAvatar == null ? Icon(Icons.person, size: 14, color: Colors.grey[600]) : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      work.workStaffName ?? 'Unassigned',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
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