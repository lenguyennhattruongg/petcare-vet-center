FROM python:3.12-slim

WORKDIR /app

# Cài đặt thư viện hệ thống cần thiết
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    default-libmysqlclient-dev \
    pkg-config \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy và cài đặt dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy mã nguồn dự án
COPY . .

# Mở cổng 5000
EXPOSE 5000

# Chạy ứng dụng bằng Waitress hoặc Gunicorn
CMD ["python", "app.py"]
