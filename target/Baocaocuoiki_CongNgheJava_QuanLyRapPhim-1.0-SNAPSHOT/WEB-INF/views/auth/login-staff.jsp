<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Starlight Staff - Đăng nhập</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700;800&display=swap');
        body { font-family: 'Plus Jakarta Sans', sans-serif; }
        .login-bg {
            background: radial-gradient(circle at top right, rgba(37, 99, 235, 0.15), transparent),
                        radial-gradient(circle at bottom left, rgba(6, 182, 212, 0.1), transparent), #0b0c10;
        }
        .glass-card {
            background: rgba(20, 21, 27, 0.8);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.05);
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.7);
        }
        @keyframes fadeInUp { from { opacity: 0; transform: scale(0.9) translateY(40px); } to { opacity: 1; transform: scale(1) translateY(0); } }
        .shake { animation: shake 0.4s ease-in-out; }
        @keyframes shake { 0%, 100% { transform: translateX(0); } 25% { transform: translateX(-10px); } 75% { transform: translateX(10px); } }
    </style>
</head>
<body class="login-bg min-h-screen flex items-center justify-center p-6">
    <div class="fixed top-[-10%] left-[-10%] w-[40%] h-[40%] bg-blue-600/10 blur-[120px] rounded-full"></div>
    <div class="fixed bottom-[-10%] right-[-10%] w-[40%] h-[40%] bg-cyan-600/10 blur-[120px] rounded-full"></div>

    <div id="login-container" class="w-full max-w-md glass-card rounded-[2rem] p-10 relative" style="animation: fadeInUp 0.8s cubic-bezier(0.16, 1, 0.3, 1) forwards;">
        <div class="text-center mb-10">
            <div class="inline-flex items-center justify-center bg-gradient-to-tr from-blue-600 to-cyan-500 text-white w-16 h-16 rounded-2xl mb-6 shadow-xl shadow-blue-900/40">
                <i class="fa-solid fa-user-tie text-3xl"></i>
            </div>
            <h1 class="text-2xl font-extrabold text-white uppercase tracking-tighter">Starlight <span class="text-blue-500">Staff</span></h1>
            <p class="text-gray-400 text-[10px] mt-2 font-bold tracking-[0.4em] uppercase opacity-60">Employee Portal</p>
        </div>

        <form action="${pageContext.request.contextPath}/login-staff" method="POST" class="space-y-5">
            <div class="space-y-2">
                <label class="block text-[10px] font-black text-gray-500 uppercase tracking-[0.2em] ml-2">Tài khoản</label>
                <div class="relative">
                    <i class="fa-solid fa-user absolute left-5 top-1/2 -translate-y-1/2 text-gray-600"></i>
                    <input type="text" name="username" required
                           class="w-full bg-white/[0.03] border border-white/5 rounded-2xl pl-14 pr-6 py-4 text-white focus:outline-none focus:border-blue-500/50 transition"
                           placeholder="Nhập tên đăng nhập">
                </div>
            </div>
            <div class="space-y-2">
                <label class="block text-[10px] font-black text-gray-500 uppercase tracking-[0.2em] ml-2">Mật khẩu</label>
                <div class="relative">
                    <i class="fa-solid fa-lock absolute left-5 top-1/2 -translate-y-1/2 text-gray-600"></i>
                    <input type="password" id="password" name="password" required
                           class="w-full bg-white/[0.03] border border-white/5 rounded-2xl pl-14 pr-14 py-4 text-white focus:outline-none focus:border-blue-500/50 transition"
                           placeholder="••••••••">
                    <button type="button" onclick="togglePassword()" class="absolute right-5 top-1/2 -translate-y-1/2 text-gray-600 hover:text-blue-500">
                        <i class="fa-solid fa-eye" id="eye-icon"></i>
                    </button>
                </div>
            </div>
            <button type="submit"
                    class="w-full bg-gradient-to-r from-blue-600 to-cyan-500 hover:from-blue-500 hover:to-cyan-400 text-white font-black py-4 rounded-2xl transition shadow-xl shadow-blue-600/20 uppercase text-[11px] tracking-[0.2em]">
                Đăng nhập
            </button>

            <c:if test="${not empty error}">
                <div class="mt-4 p-4 bg-red-500/10 border border-red-500/20 rounded-2xl flex items-center space-x-3">
                    <i class="fa-solid fa-xmark text-red-500"></i>
                    <p class="text-red-400 text-[11px] font-bold uppercase">${error}</p>
                </div>
            </c:if>
            <c:if test="${not empty successMessage}">
                <div class="mt-4 p-4 bg-green-500/10 border border-green-500/20 rounded-2xl flex items-center space-x-3">
                    <i class="fa-solid fa-check text-green-500"></i>
                    <p class="text-green-400 text-[11px] font-bold">${successMessage}</p>
                </div>
            </c:if>
        </form>

        <p class="text-center text-gray-600 text-[10px] mt-6">
            <a href="${pageContext.request.contextPath}/login-admin" class="hover:text-blue-400 transition">Đăng nhập quản trị</a>
            &nbsp;|&nbsp;
            <a href="${pageContext.request.contextPath}/customer/home" class="hover:text-blue-400 transition">Trang khách hàng</a>
        </p>
    </div>

    <script>
        function togglePassword() {
            const input = document.getElementById('password');
            const icon = document.getElementById('eye-icon');
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.replace('fa-eye', 'fa-eye-slash');
            } else {
                input.type = 'password';
                icon.classList.replace('fa-eye-slash', 'fa-eye');
            }
        }
        <c:if test="${not empty error}">
            document.getElementById('login-container').classList.add('shake');
        </c:if>
    </script>
</body>
</html>
