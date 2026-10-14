from flask import Blueprint, jsonify

api_v1_bp = Blueprint("api_v1", __name__)


@api_v1_bp.route("/health")
def health_check():
    """Endpoint kiểm tra sức khỏe hệ thống API"""
    return jsonify({
        "success": True,
        "code": 200,
        "service": "PetCare Clinic RESTful API",
        "version": "1.0.0",
        "status": "operational"
    }), 200


# Nạp các route con của API
from .appointments import *
