class LeaveRequest {
  final String employeeName;
  final String leaveType;
  final String dateRange;
  final String reason;
  final String status;
  final List<String> attachments;

  LeaveRequest({
    required this.employeeName,
    required this.leaveType,
    required this.dateRange,
    required this.reason,
    required this.status,
    required this.attachments,
  });
}