/**
 * PetCare Veterinary Hospital - Main Client Script
 */
document.addEventListener("DOMContentLoaded", function () {
  // 1. Tự động tắt Flash Alerts sau 5 giây
  const alerts = document.querySelectorAll(".alert-dismissible");
  alerts.forEach(function (alert) {
    setTimeout(function () {
      const bsAlert = bootstrap.Alert.getOrCreateInstance(alert);
      bsAlert.close();
    }, 5000);
  });

  // 2. Chống double-submit trên các Form quan trọng
  const forms = document.querySelectorAll("form.prevent-double-submit");
  forms.forEach(function (form) {
    form.addEventListener("submit", function () {
      const submitBtn = form.querySelector('button[type="submit"]');
      if (submitBtn) {
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Đang xử lý...';
      }
    });
  });
});
