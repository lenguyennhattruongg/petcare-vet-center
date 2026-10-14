from flask import jsonify, request
from . import api_v1_bp


@api_v1_bp.route("/appointments/available-slots", methods=["GET"])
def get_available_slots():
    """
    REST API: Lấy danh sách khung giờ trống theo bác sĩ và ngày (BR-01, BR-02)
    Params:
      - doctor_id (int): ID của bác sĩ thú y
      - date (string: YYYY-MM-DD): Ngày muốn đặt lịch
    """
    doctor_id = request.args.get("doctor_id", type=int)
    date_str = request.args.get("date")

    # Mock response cho Mốc 1 chuẩn format JSON
    sample_slots = [
        {"start_time": "08:00", "end_time": "08:30", "is_available": True},
        {"start_time": "08:30", "end_time": "09:00", "is_available": True},
        {"start_time": "09:00", "end_time": "09:30", "is_available": False, "reason": "Đã có lịch hẹn"},
        {"start_time": "09:30", "end_time": "10:00", "is_available": True},
        {"start_time": "10:00", "end_time": "10:30", "is_available": True},
        {"start_time": "14:00", "end_time": "14:30", "is_available": True},
        {"start_time": "14:30", "end_time": "15:00", "is_available": True},
        {"start_time": "15:00", "end_time": "15:30", "is_available": True},
    ]

    return jsonify({
        "success": True,
        "code": 200,
        "data": {
            "doctor_id": doctor_id,
            "date": date_str,
            "slots": sample_slots
        }
    }), 200
