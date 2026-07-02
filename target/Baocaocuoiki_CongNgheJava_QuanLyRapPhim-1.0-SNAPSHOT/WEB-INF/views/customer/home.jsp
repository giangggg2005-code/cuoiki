<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Starlight Cinema - Trải nghiệm điện ảnh đỉnh cao</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            --bg-dark: #0a0a0a;
            --bg-header: #000000;
            --bg-footer: #111111;
            --primary-color: #FFB800;
            --text-main: #ffffff;
            --text-muted: #a0a0a0;
            --border-color: #333333;
            
            --card-1: #2a2008;
            --card-2: #081e2a;
            --card-3: #22082a;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', sans-serif;
        }

        body {
            background-color: var(--bg-dark);
            color: var(--text-main);
            line-height: 1.5;
            overflow-x: hidden;
        }

        a {
            text-decoration: none;
            color: inherit;
            transition: 0.3s;
        }

        ul {
            list-style: none;
        }

        /* --- HEADER --- */
        header {
            background-color: var(--bg-header);
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 50px;
            border-bottom: 1px solid #1a1a1a;
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .logo-icon {
            background-color: var(--primary-color);
            color: black;
            width: 35px;
            height: 35px;
            border-radius: 8px;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 18px;
        }

        .logo-text {
            display: flex;
            flex-direction: column;
        }

        .logo-text span:first-child {
            font-weight: 800;
            font-size: 18px;
            letter-spacing: 1px;
        }

        .logo-text span:last-child {
            font-size: 10px;
            color: var(--text-muted);
            letter-spacing: 2px;
        }

        nav ul {
            display: flex;
            gap: 30px;
        }

        nav a {
            font-size: 13px;
            font-weight: 600;
            color: var(--text-muted);
            text-transform: uppercase;
        }

        nav a:hover, nav a.active {
            color: var(--primary-color);
        }

        /* --- DROPDOWN MENU --- */
        nav ul li {
            position: relative;
        }

        .dropdown-menu {
            position: absolute;
            top: 100%;
            left: 0;
            background-color: #000;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            padding: 10px 0;
            min-width: 180px;
            opacity: 0;
            visibility: hidden;
            transform: translateY(15px);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            z-index: 1000;
            box-shadow: 0 10px 30px rgba(0,0,0,0.8);
        }

        .dropdown-menu a {
            padding: 10px 20px;
            display: block;
            font-size: 12px;
            text-transform: none;
            font-weight: 500;
            color: var(--text-muted) !important;
        }

        .dropdown-menu a:hover {
            background-color: #111;
            color: var(--primary-color) !important;
        }

        nav ul li:hover .dropdown-menu {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
        }

        .header-actions {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .search-btn {
            background: #1a1a1a;
            border: none;
            color: white;
            width: 40px;
            height: 40px;
            border-radius: 8px;
            cursor: pointer;
            transition: 0.3s;
        }
        
        .search-btn:hover { background: #333; }

        .register-btn {
            background-color: transparent;
            color: var(--text-main);
            border: 1px solid var(--border-color);
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14px;
            cursor: pointer;
            transition: 0.3s;
        }

        .register-btn:hover { 
            border-color: var(--primary-color);
            color: var(--primary-color);
            transform: translateY(-2px);
        }

        .login-btn {
            background-color: var(--primary-color);
            color: black;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: 0.3s;
        }
        
        .login-btn:hover { 
            opacity: 1; 
            transform: translateY(-2px);
            background: linear-gradient(135deg, var(--primary-color) 0%, #FF8A00 100%);
            box-shadow: 0 0 20px rgba(255, 184, 0, 0.6);
        }

        /* --- HERO SECTION --- */
        .hero {
            padding: 100px 50px;
            background: linear-gradient(to right, rgba(10,10,10,1) 30%, rgba(10,10,10,0.4) 60%, rgba(10,10,10,0.1) 100%), 
                        url('https://images.unsplash.com/photo-1626814026160-2237a95fc5a0?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80');
            background-size: cover;
            background-position: center;
            min-height: 650px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .badges {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }

        .badge {
            padding: 5px 12px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 800;
            text-transform: uppercase;
        }

        .badge.hot { background-color: #E50914; color: white; }
        .badge.new { background-color: var(--primary-color); color: black; }

        .hero h1 {
            font-size: 72px;
            font-weight: 900;
            line-height: 1;
            margin-bottom: 20px;
            letter-spacing: -2px;
            max-width: 800px;
            text-transform: uppercase;
        }

        .hero p {
            color: var(--text-muted);
            max-width: 550px;
            margin-bottom: 30px;
            font-size: 16px;
            line-height: 1.6;
        }

        .meta-info {
            display: flex;
            align-items: center;
            gap: 20px;
            font-size: 14px;
            color: var(--text-muted);
            margin-bottom: 40px;
        }

        .rating {
            color: var(--primary-color);
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .rating span.score {
            color: white;
        }

        .hero-buttons {
            display: flex;
            gap: 15px;
        }

        .btn {
            padding: 14px 28px;
            border-radius: 10px;
            font-weight: 700;
            font-size: 14px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 10px;
            border: none;
            transition: 0.3s;
        }

        .btn-primary { background-color: var(--primary-color); color: black; }
        .btn-primary:hover { transform: scale(1.05); }

        .btn-secondary { background-color: rgba(255,255,255,0.1); color: white; backdrop-filter: blur(10px); }
        .btn-secondary:hover { background-color: rgba(255,255,255,0.2); }

        /* --- DASHBOARD/STATS SECTION --- */
        .dashboard {
            padding: 50px;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 20px;
            margin-top: -60px;
            position: relative;
            z-index: 10;
        }

        .stat-card {
            border-radius: 16px;
            padding: 25px;
            display: flex;
            align-items: center;
            gap: 20px;
            transition: 0.3s;
        }
        
        .stat-card:hover { transform: translateY(-5px); }

        .stat-card.c1 { background: linear-gradient(135deg, var(--card-1), #1a1505); border: 1px solid #4a3a10; }
        .stat-card.c2 { background: linear-gradient(135deg, var(--card-2), #05151a); border: 1px solid #103a4a; }
        .stat-card.c3 { background: linear-gradient(135deg, var(--card-3), #15051a); border: 1px solid #3a104a; }

        .stat-icon {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            background: rgba(255,255,255,0.1);
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 20px;
        }
        
        .c1 .stat-icon { color: var(--primary-color); }
        .c2 .stat-icon { color: #00d1ff; }
        .c3 .stat-icon { color: #d100ff; }

        .stat-info h3 { font-size: 24px; font-weight: 800; }
        .stat-info p { font-size: 12px; color: var(--text-muted); text-transform: uppercase; letter-spacing: 1px; }

        /* --- MOVIE GRID --- */
        .section-container { padding: 40px 50px; }
        .lobby-layout {
            display: flex;
            gap: 28px;
            align-items: flex-start;
        }
        .lobby-main { flex: 1; min-width: 0; }
        .lobby-calendar-book {
            width: 300px;
            flex-shrink: 0;
            position: sticky;
            top: 90px;
            background: linear-gradient(145deg, #1a1410 0%, #121212 100%);
            border: 1px solid #3d2e14;
            border-radius: 16px 20px 20px 16px;
            box-shadow: 12px 12px 40px rgba(0,0,0,0.5), inset 0 1px 0 rgba(255,184,0,0.08);
            overflow: hidden;
        }
        .calendar-spine {
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 14px;
            background: repeating-linear-gradient(
                180deg,
                #2a2218 0px, #2a2218 8px,
                #1a1510 8px, #1a1510 16px
            );
            border-right: 1px solid #4a3a20;
        }
        .calendar-inner { margin-left: 14px; padding: 18px 16px 20px; }
        .calendar-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 14px;
            padding-bottom: 12px;
            border-bottom: 1px dashed #3d3520;
        }
        .calendar-header h3 {
            font-size: 13px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: var(--primary-color);
        }
        .calendar-nav-btn {
            width: 28px;
            height: 28px;
            border-radius: 8px;
            border: 1px solid #3d3520;
            background: #1a1a1a;
            color: var(--text-muted);
            cursor: pointer;
            transition: 0.2s;
        }
        .calendar-nav-btn:hover { border-color: var(--primary-color); color: var(--primary-color); }
        .calendar-month-label {
            font-size: 14px;
            font-weight: 700;
            text-align: center;
            margin-bottom: 12px;
            color: white;
        }
        .calendar-weekdays {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 4px;
            margin-bottom: 6px;
        }
        .calendar-weekdays span {
            font-size: 10px;
            font-weight: 700;
            text-align: center;
            color: #666;
            text-transform: uppercase;
        }
        .calendar-days {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 4px;
        }
        .calendar-day {
            aspect-ratio: 1;
            border: none;
            border-radius: 8px;
            background: transparent;
            color: #ccc;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.2s;
        }
        .calendar-day:hover:not(:disabled) { background: rgba(255,184,0,0.12); color: var(--primary-color); }
        .calendar-day.other-month { color: #444; }
        .calendar-day.today { box-shadow: inset 0 0 0 1px var(--primary-color); }
        .calendar-day.selected { background: var(--primary-color); color: #000; font-weight: 800; }
        .calendar-day:disabled { color: #333; cursor: not-allowed; }
        .calendar-day.has-showtime::after {
            content: '';
            display: block;
            width: 4px;
            height: 4px;
            border-radius: 50%;
            background: var(--primary-color);
            margin: 2px auto 0;
        }
        .calendar-day.selected.has-showtime::after { background: #000; }
        .calendar-hint {
            margin-top: 14px;
            padding-top: 12px;
            border-top: 1px dashed #3d3520;
            font-size: 11px;
            color: var(--text-muted);
            line-height: 1.5;
        }
        .calendar-selected-label {
            font-size: 11px;
            color: var(--primary-color);
            font-weight: 700;
            margin-top: 8px;
        }
        .movie-showtime-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
            margin-top: 8px;
        }
        .movie-showtime-tag {
            font-size: 10px;
            font-weight: 700;
            padding: 3px 8px;
            border-radius: 6px;
            background: rgba(255,184,0,0.12);
            color: var(--primary-color);
            border: 1px solid rgba(255,184,0,0.25);
        }
        .section-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .section-title { font-size: 24px; font-weight: 800; }
        .view-all { color: var(--primary-color); font-size: 13px; font-weight: 600; }

        .movie-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 30px;
        }

        .movie-card {
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
            position: relative;
        }

        .movie-card:hover {
            transform: translateY(-10px);
        }

        /* --- BOOKING MODAL (LOTTE STYLE) --- */
        #booking-modal {
            position: fixed;
            inset: 0;
            z-index: 200;
            background: rgba(0, 0, 0, 0.95);
            display: flex;
            align-items: center;
            justify-content: center;
            backdrop-filter: blur(10px);
            padding: 20px;
        }

        #booking-modal.hidden { display: none; }

        .booking-container {
            background: #111;
            border: 1px solid #333;
            width: 100%;
            max-width: 1100px;
            height: 90vh;
            border-radius: 30px;
            overflow: hidden;
            display: flex;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
        }

        .booking-main { flex: 1; padding: 40px; overflow-y: auto; display: flex; flex-direction: column; }
        .booking-sidebar { width: 320px; background: #080808; border-l: 1px solid #222; padding: 40px; display: flex; flex-direction: column; }

        .step-progress { display: flex; gap: 20px; margin-bottom: 40px; }
        .step-item { font-size: 13px; font-weight: 700; color: #444; text-transform: uppercase; letter-spacing: 1px; }
        .step-item.active { color: var(--primary-color); }

        .booking-step-content { flex: 1; }
        .booking-step-content.hidden { display: none; }

        /* Step 1: Schedule */
        .date-list { display: flex; gap: 10px; margin-bottom: 30px; overflow-x: auto; padding-bottom: 10px; }
        .date-btn { min-width: 70px; padding: 10px; border-radius: 12px; border: 1px solid #333; background: transparent; color: white; cursor: pointer; text-align: center; }
        .date-btn.active { background: var(--primary-color); color: black; border-color: var(--primary-color); }
        .date-btn span { display: block; font-size: 10px; opacity: 0.6; }
        .date-btn strong { font-size: 18px; }

        .time-group-title { font-size: 11px; font-weight: 800; color: var(--primary-color); text-transform: uppercase; margin-bottom: 15px; display: block; }
        .time-slots { display: flex; gap: 10px; flex-wrap: wrap; margin-bottom: 25px; }
        .time-slot { padding: 10px 20px; border-radius: 10px; border: 1px solid #333; color: white; font-weight: 600; cursor: pointer; transition: 0.3s; }
        .time-slot:hover, .time-slot.active { border-color: var(--primary-color); color: var(--primary-color); }

        /* Step 2: Seats */
        .screen-ui { width: 80%; h: 4px; background: linear-gradient(to right, transparent, #444, transparent); margin: 0 auto 40px; position: relative; border-radius: 4px; }
        .screen-ui::after { content: 'MÀN HÌNH'; position: absolute; top: 10px; left: 50%; transform: translateX(-50%); font-size: 10px; color: #444; letter-spacing: 5px; font-weight: 800; }
        
        .seat-grid { display: grid; gap: 8px; justify-content: center; margin-bottom: 16px; }
        .seat {
            width: 36px; height: 36px; border-radius: 10px 10px 4px 4px; cursor: pointer;
            display: flex; align-items: center; justify-content: center;
            font-size: 9px; font-weight: 700; color: #fff; transition: 0.2s;
            background: linear-gradient(to bottom, #ef4444, #dc2626);
            border-bottom: 3px solid #991b1b;
            box-shadow: 0 0 10px rgba(220, 38, 38, 0.4);
        }
        .seat:hover:not(.sold):not(.maintenance):not(.selected) { transform: translateY(-2px); }
        .seat.sold {
            background: #eab308 !important; color: #713f12 !important;
            border-bottom: 3px solid #a16207; box-shadow: 0 0 12px rgba(234, 179, 8, 0.5);
            cursor: not-allowed; opacity: 1;
        }
        .seat.maintenance {
            background: rgba(55, 65, 81, 0.85) !important; color: #9ca3af !important;
            border-bottom: 3px solid #111827; cursor: not-allowed; opacity: 0.75; box-shadow: none;
        }
        .seat.selected {
            background: linear-gradient(to bottom, #22c55e, #16a34a) !important;
            border-bottom-color: #15803d !important; color: #fff !important;
            box-shadow: 0 0 14px rgba(34, 197, 94, 0.7) !important;
        }
        .seat-legend { display: flex; flex-wrap: wrap; justify-content: center; gap: 16px 24px; margin-top: 8px; margin-bottom: 24px; font-size: 10px; font-weight: 800; text-transform: uppercase; color: #888; }
        .seat-legend-item { display: flex; align-items: center; gap: 8px; }
        .seat-legend-box { width: 18px; height: 18px; border-radius: 6px 6px 2px 2px; }

        /* Sidebar */
        .sidebar-poster { width: 100%; aspect-ratio: 2/3; border-radius: 15px; object-fit: cover; margin-bottom: 20px; box-shadow: 0 10px 20px rgba(0,0,0,0.5); }
        .summary-item { border-bottom: 1px solid #222; padding: 15px 0; }
        .summary-label { font-size: 10px; color: var(--text-muted); text-transform: uppercase; font-weight: 800; margin-bottom: 5px; }
        .summary-value { font-size: 14px; font-weight: 700; color: white; }
        .total-price { margin-top: auto; padding-top: 20px; }
        .total-price .amount { font-size: 28px; font-weight: 900; color: var(--primary-color); }
        .summary-seats-detail { margin-top: 10px; max-height: 150px; overflow-y: auto; }
        .summary-seats-detail .seat-price-row {
            display: flex; justify-content: space-between; align-items: center;
            font-size: 12px; color: #888; margin-top: 8px;
        }
        .summary-seats-detail .seat-price-row .seat-name { color: #fff; font-weight: 700; }
        .summary-seats-detail .seat-price-row .seat-price { color: var(--primary-color); font-weight: 800; }
        #panel-qr.hidden { display: none !important; }

        .booking-nav { display: flex; justify-content: space-between; margin-top: 30px; padding-top: 20px; border-top: 1px solid #222; }
        .btn-nav { padding: 12px 30px; border-radius: 12px; font-weight: 800; text-transform: uppercase; font-size: 12px; cursor: pointer; border: none; transition: 0.3s; }
        .btn-back { background: transparent; color: #555; border: 1px solid #333; }
        .btn-back:hover { color: white; border-color: white; }
        .btn-next { background: var(--primary-color); color: black; box-shadow: 0 10px 20px rgba(255, 184, 0, 0.2); }
        .btn-next:hover { transform: translateY(-2px); box-shadow: 0 15px 30px rgba(255, 184, 0, 0.3); }

        .booking-toolbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
        .booking-step-back {
            display: inline-flex; align-items: center; gap: 8px;
            padding: 8px 14px; border-radius: 10px;
            border: 1px solid #333; background: transparent;
            color: #888; font-size: 11px; font-weight: 700;
            text-transform: uppercase; cursor: pointer; transition: 0.2s;
        }
        .booking-step-back:hover { color: white; border-color: #666; }
        .booking-close-btn {
            width: 40px; height: 40px; border-radius: 50%;
            border: 1px solid #333; background: #1a1a1a;
            color: #888; cursor: pointer; transition: 0.2s;
        }
        .booking-close-btn:hover { color: white; border-color: #666; }
        .booking-main-nav {
            display: flex; justify-content: space-between; align-items: center;
            gap: 16px; margin-top: 24px; padding-top: 20px; border-top: 1px solid #222;
        }

        .movie-poster {
            position: relative;
            border-radius: 12px;
            overflow: hidden;
            aspect-ratio: 2/3;
            margin-bottom: 15px;
            box-shadow: 0 10px 20px rgba(0,0,0,0.5);
        }

        .movie-poster img { width: 100%; height: 100%; object-fit: cover; transition: 0.5s; } /* ĐÃ ĐƯỢC SỬA TẠI ĐÂY */
        .movie-card:hover img { transform: scale(1.1); }

        /* Overlay hiệu ứng hover */
        .poster-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            opacity: 0;
            transition: 0.3s ease;
            background: rgba(0, 0, 0, 0.2);
            backdrop-filter: blur(2px);
        }

        .movie-card:hover .poster-overlay {
            opacity: 1;
        }

        .hover-book-btn {
            padding: 12px 24px;
            background: var(--primary-color);
            color: black;
            border-radius: 12px;
            font-size: 13px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            display: flex;
            align-items: center;
            gap: 10px;
            transform: translateY(20px);
            transition: 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            box-shadow: 0 10px 20px rgba(0,0,0,0.3);
        }

        .movie-card:hover .hover-book-btn {
            transform: translateY(0);
        }

        .movie-info h4 { font-size: 16px; font-weight: 700; margin-bottom: 5px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .movie-card:hover .movie-info h4 { color: var(--primary-color); }
        .movie-info p { font-size: 13px; color: var(--text-muted); }

        /* --- SEARCH BOX --- */
        .search-box-container {
            position: relative;
            margin-bottom: 25px;
            max-width: 450px;
        }

        .search-box-container input {
            width: 100%;
            background-color: #1a1a1a;
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 12px 15px 12px 45px;
            color: white;
            outline: none;
            transition: 0.3s;
        }

        .search-box-container input:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 4px rgba(255, 184, 0, 0.1);
        }

        .search-icon {
            position: absolute;
            left: 18px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
            pointer-events: none;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* --- GENRE FILTERS --- */
        .genre-filters {
            display: flex;
            gap: 10px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }

        .genre-btn {
            padding: 8px 20px;
            border-radius: 20px;
            background: #1a1a1a;
            color: var(--text-muted);
            font-size: 13px;
            font-weight: 600;
            border: 1px solid var(--border-color);
            cursor: pointer;
            transition: 0.3s;
        }

        .genre-btn.active, .genre-btn:hover {
            background: var(--primary-color);
            color: black;
            border-color: var(--primary-color);
        }

        .hidden { display: none !important; }

        /* --- FOOTER --- */
        footer {
            background-color: var(--bg-footer);
            padding: 60px 50px 30px;
            border-top: 1px solid var(--border-color);
            margin-top: 50px;
        }
        
        .footer-content {
            display: flex;
            justify-content: space-between;
            margin-bottom: 50px;
            flex-wrap: wrap;
            gap: 40px;
        }
        
        .footer-logo { margin-bottom: 20px; }
        .footer-desc { color: var(--text-muted); font-size: 14px; max-width: 300px; }
        .footer-links h4 { margin-bottom: 20px; font-size: 16px; }
        .footer-links ul li { margin-bottom: 10px; color: var(--text-muted); font-size: 14px; transition: 0.3s; }
        .footer-links ul li:hover { color: white; }

        /* Social Icon Animations */
        .footer-links a i, .footer-bottom a {
            display: inline-block;
            transition: transform 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275), color 0.3s ease;
        }

        .footer-links a:hover i {
            transform: scale(1.3) rotate(8deg);
            color: white !important;
        }

        .footer-bottom a:hover {
            transform: translateY(-5px) scale(1.3);
            color: var(--primary-color);
        }

        .footer-bottom { border-top: 1px solid #222; padding-top: 30px; display: flex; justify-content: space-between; font-size: 12px; color: var(--text-muted); }

        /* BỔ SUNG RESPONSIVE Ở ĐÂY DÀNH CHO MOBILE */
        @media (max-width: 768px) {
            .hero h1 { font-size: 40px; }
            .hero { padding: 50px 20px; min-height: 500px; }
            .dashboard { grid-template-columns: 1fr; margin-top: 20px; padding: 20px; }
            header { padding: 15px 20px; flex-direction: column; gap: 15px; }
            nav ul { flex-wrap: wrap; justify-content: center; }
            .section-container { padding: 40px 20px; }
            .lobby-layout { flex-direction: column; }
            .lobby-calendar-book { width: 100%; position: static; order: -1; }
        }
    </style>
</head>
<body>

    <header>
        <a href="${pageContext.request.contextPath}/customer/home" class="logo">
            <div class="logo-icon"><i class="fa-solid fa-star"></i></div>
            <div class="logo-text"><span>STARLIGHT</span><span>CINEMA CLUB</span></div>
        </a>
        <nav>
            <ul>
                <li><a href="${pageContext.request.contextPath}/customer/home" class="active">Trang chủ</a></li>
                <li><a href="${pageContext.request.contextPath}/customer/showtimes">Lịch chiếu</a></li>
                <li><a href="${pageContext.request.contextPath}/customer/movies">Phim</a></li>
                <li>
                    <a href="javascript:void(0)">Thể loại <i class="fa-solid fa-chevron-down" style="font-size:10px;margin-left:4px;"></i></a>
                    <div class="dropdown-menu">
                        <a href="${pageContext.request.contextPath}/customer/movies">Tất cả thể loại</a>
                        <c:forEach var="g" items="${genreList}">
                            <c:url var="genreUrl" value="/customer/movies">
                                <c:param name="genre" value="${g}" />
                            </c:url>
                            <a href="${genreUrl}">${g}</a>
                        </c:forEach>
                    </div>
                </li>
            </ul>
        </nav>
        <div class="header-actions">
            <button class="search-btn"><i class="fa-solid fa-search"></i></button>
            <c:choose>
                <c:when test="${not empty sessionScope.loggedInUser}">
                    <nav>
                        <ul>
                            <li>
                                <a href="${pageContext.request.contextPath}/customer/profile" class="login-btn" style="background: transparent; color: white; border: 1px solid var(--border-color);">
                                    <i class="fa-solid fa-user"></i> Chào, ${sessionScope.loggedInUser.fullName}
                                </a>
                                <div class="dropdown-menu">
                                    <a href="${pageContext.request.contextPath}/customer/profile">Hồ sơ cá nhân</a>
                                    <a href="${pageContext.request.contextPath}/logout-customer">Đăng xuất</a>
                                </div>
                            </li>
                        </ul>
                    </nav>
                </c:when>
                <c:otherwise>
                    <button class="register-btn" onclick="location.href='${pageContext.request.contextPath}/register-customer'">Đăng ký</button>
                    <button class="login-btn" onclick="location.href='${pageContext.request.contextPath}/login-customer'"><i class="fa-solid fa-right-to-bracket"></i> Đăng nhập</button>
                </c:otherwise>
            </c:choose>
        </div>
    </header>

    <c:if test="${not empty heroMovie}">
    <div class="hero" style="background: linear-gradient(to right, rgba(10,10,10,1) 30%, rgba(10,10,10,0.4) 60%, rgba(10,10,10,0.1) 100%), url('${heroMovie.posterUrl}') center/cover;">
        <div class="badges">
            <span class="badge hot">${heroMovie.censorship != null ? heroMovie.censorship : 'P'}</span>
            <span class="badge new">ĐANG CHIẾU</span>
        </div>
        <h1>${heroMovie.title}</h1>
        <p>${heroMovie.description}</p>
        <div class="meta-info">
            <div><i class="fa-solid fa-clock"></i> ${heroMovie.duration} Phút</div>
            <div><i class="fa-solid fa-calendar"></i> <fmt:formatDate value="${heroMovie.releaseDate}" pattern="dd/MM/yyyy" /></div>
            <div style="border: 1px solid var(--border-color); padding: 2px 8px; border-radius: 4px; font-size: 11px;">${heroMovie.genre}</div>
            <div><i class="fa-solid fa-language"></i> ${heroMovie.language}</div>
        </div>
        <div class="hero-buttons">
            <button class="btn btn-primary" onclick="openBooking('${heroMovie.id_Movie}', '${heroMovie.title}', '${heroMovie.posterUrl}', ${heroMovie.basePrice})"><i class="fa-solid fa-ticket"></i> Đặt vé ngay</button>
            <a href="${heroMovie.trailerUrl}" target="_blank" class="btn btn-secondary"><i class="fa-solid fa-play"></i> Xem Trailer</a>
        </div>
    </div>
    </c:if>

    <div class="dashboard">
        <div class="stat-card c1">
            <div class="stat-icon"><i class="fa-solid fa-film"></i></div>
            <div class="stat-info">
                <h3>${totalMovies != null ? totalMovies : '20+'}</h3>
                <p>Phim Đang Chiếu</p>
            </div>
        </div>
        <div class="stat-card c2">
            <div class="stat-icon"><i class="fa-solid fa-video"></i></div>
            <div class="stat-info">
                <h3>${totalRooms != null ? totalRooms : '5'}</h3>
                <p>Phòng Chiếu Tiêu Chuẩn</p>
            </div>
        </div>
        <div class="stat-card c3">
            <div class="stat-icon"><i class="fa-solid fa-users"></i></div>
            <div class="stat-info">
                <h3>${totalMembers != null ? totalMembers : '10,000+'}</h3>
                <p>Khách Hàng Thành Viên</p>
            </div>
        </div>
    </div>

    <div class="section-container">
        <div class="lobby-layout">
            <div class="lobby-main">
        <div class="section-header">
            <div>
                <h2 class="section-title" id="section-movie-title">Phim chiếu ngày ${selectedDateDisplay}</h2>
                <p style="font-size:12px;color:var(--text-muted);margin-top:4px;">Chọn ngày trên quyển lịch bên phải để xem suất chiếu</p>
            </div>
            <a href="${pageContext.request.contextPath}/customer/movies" class="view-all">Xem tất cả <i class="fa-solid fa-angle-right ml-1"></i></a>
        </div>

        <div class="search-box-container">
            <i class="fa-solid fa-search search-icon"></i>
            <input type="text" id="movie-search-input" placeholder="Tìm kiếm phim, thể loại..." autocomplete="off">
        </div>

        <div class="genre-filters" id="genre-filters">
            <button type="button" class="genre-btn active" data-genre="all">Tất cả</button>
            <c:forEach var="genre" items="${genreList}">
                <button type="button" class="genre-btn" data-genre="${genre}">${genre}</button>
            </c:forEach>
        </div>

        <p id="movie-filter-empty" class="hidden" style="color:var(--text-muted); text-align:center; padding:40px 0; font-size:14px;">
            Không tìm thấy phim phù hợp với bộ lọc hiện tại.
        </p>

        <div class="movie-grid" id="movie-grid">
            <c:choose>
                <c:when test="${not empty movieList}">
                    <c:forEach var="movie" items="${movieList}">
                        <div class="movie-card" data-genre="${movie.genre}" data-title="${movie.title}"
                             onclick="openBooking('${movie.id_Movie}', '${movie.title}', '${movie.posterUrl}', ${movie.basePrice})">
                            <div class="movie-poster">
                                <img src="${movie.posterUrl}" alt="${movie.title}" onerror="this.src='https://via.placeholder.com/300x450?text=No+Poster'">
                                <div class="poster-overlay">
                                    <div class="hover-book-btn">
                                        <i class="fa-solid fa-ticket"></i> Đặt vé ngay
                                    </div>
                                </div>
                            </div>
                            <div class="movie-info">
                                <h4>${movie.title}</h4>
                                <p>${movie.genre} | ${movie.duration} Phút</p>
                                <c:if test="${not empty movie.showtimes}">
                                    <div class="movie-showtime-tags">
                                        <c:forEach var="st" items="${movie.showtimes}">
                                            <span class="movie-showtime-tag"><fmt:formatDate value="${st.startTime}" pattern="HH:mm"/></span>
                                        </c:forEach>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p id="movie-grid-empty" class="text-gray-500 col-span-full" style="grid-column:1/-1;">Chưa có phim trong hệ thống. Vui lòng thêm phim tại trang quản trị.</p>
                </c:otherwise>
            </c:choose>
        </div>
            </div>

            <aside class="lobby-calendar-book" id="lobby-calendar-book">
                <div class="calendar-spine"></div>
                <div class="calendar-inner">
                    <div class="calendar-header">
                        <h3><i class="fa-regular fa-calendar"></i> Quyển lịch</h3>
                        <div style="display:flex;gap:6px;">
                            <button type="button" class="calendar-nav-btn" id="cal-prev" title="Tháng trước"><i class="fa-solid fa-chevron-left"></i></button>
                            <button type="button" class="calendar-nav-btn" id="cal-next" title="Tháng sau"><i class="fa-solid fa-chevron-right"></i></button>
                        </div>
                    </div>
                    <div class="calendar-month-label" id="calendar-month-label"></div>
                    <div class="calendar-weekdays">
                        <span>T2</span><span>T3</span><span>T4</span><span>T5</span><span>T6</span><span>T7</span><span>CN</span>
                    </div>
                    <div class="calendar-days" id="calendar-days"></div>
                    <p class="calendar-selected-label" id="calendar-selected-label">Đang xem: ${selectedDateDisplay}</p>
                    <p class="calendar-hint"><i class="fa-solid fa-circle" style="font-size:6px;color:var(--primary-color);vertical-align:middle;margin-right:4px;"></i> Chấm vàng = có suất chiếu. Bấm ngày để lọc phim.</p>
                </div>
            </aside>
        </div>
    </div>

    <div id="booking-modal" class="hidden">
        <div class="booking-container">
            <div class="booking-main">
                <div class="booking-toolbar">
                    <button type="button" class="booking-step-back" onclick="changeStep(-1)">
                        <i class="fa-solid fa-arrow-left"></i>
                        <span id="btn-booking-top-back-label">Quay về trang chủ</span>
                    </button>
                    <button type="button" class="booking-close-btn" onclick="closeBooking()" title="Đóng đặt vé">
                        <i class="fa-solid fa-times"></i>
                    </button>
                </div>

                <div class="step-progress">
                    <div class="step-item active" id="step-idx-1">01. Chọn Lịch Chiếu</div>
                    <div class="step-item" id="step-idx-2">02. Chọn Ghế</div>
                    <div class="step-item" id="step-idx-3">03. Thanh Toán</div>
                    <div class="step-item" id="step-idx-4">04. Xác Nhận</div>
                </div>

                <div class="booking-step-content" id="step-1">
                    <button type="button" class="booking-step-back booking-step-back-inline" onclick="changeStep(-1)" style="margin-bottom:16px;">
                        <i class="fa-solid fa-arrow-left"></i>
                        <span class="booking-step-back-label">Quay về trang chủ</span>
                    </button>
                    <h3 style="font-weight: 800; font-size: 18px; margin-bottom: 20px;">CHỌN NGÀY VÀ GIỜ CHIẾU</h3>
                    
                    <div class="date-list" id="dynamic-date-list">
                    </div>

                    <div>
                        <span class="time-group-title">Starlight Quận 1 - Rạp IMAX</span>
                        <div class="time-slots" id="dynamic-time-slots">
                        </div>
                    </div>
                </div>

                <div class="booking-step-content hidden" id="step-2">
                    <button type="button" class="booking-step-back booking-step-back-inline" onclick="changeStep(-1)" style="margin-bottom:16px;">
                        <i class="fa-solid fa-arrow-left"></i>
                        <span class="booking-step-back-label">Quay lại chọn suất</span>
                    </button>
                    <div class="screen-ui"></div>
                    <div class="seat-grid" id="seat-grid"></div>
                    <div class="seat-legend">
                        <div class="seat-legend-item"><div class="seat-legend-box" style="background:linear-gradient(to bottom,#ef4444,#dc2626);border-bottom:2px solid #991b1b;"></div><span style="color:#f87171;">Trống</span></div>
                        <div class="seat-legend-item"><div class="seat-legend-box" style="background:#eab308;border-bottom:2px solid #a16207;"></div><span style="color:#eab308;">Đã bán</span></div>
                        <div class="seat-legend-item"><div class="seat-legend-box" style="background:rgba(55,65,81,0.85);border-bottom:2px solid #111827;opacity:0.75;"></div><span>Bảo trì</span></div>
                        <div class="seat-legend-item"><div class="seat-legend-box" style="background:linear-gradient(to bottom,#22c55e,#16a34a);border-bottom:2px solid #15803d;"></div><span style="color:#4ade80;">Đang chọn</span></div>
                    </div>
                </div>

                <div class="booking-step-content hidden" id="step-3">
                    <button type="button" class="booking-step-back booking-step-back-inline" onclick="changeStep(-1)" style="margin-bottom:16px;">
                        <i class="fa-solid fa-arrow-left"></i>
                        <span class="booking-step-back-label">Quay lại chọn ghế</span>
                    </button>
                    <h3 style="font-weight: 800; font-size: 18px; margin-bottom: 20px;">CHỌN PHƯƠNG THỨC THANH TOÁN</h3>
                    <div style="display:flex; gap:12px; margin-bottom:24px;">
                        <button type="button" onclick="selectPaymentMethod('Card')" id="btn-pay-card"
                            style="flex:1; padding:14px; border-radius:12px; border:2px solid var(--primary-color); background:rgba(255,184,0,0.1); color:white; font-weight:700; cursor:pointer;">
                            <i class="fa-solid fa-credit-card"></i> Thẻ tín dụng
                        </button>
                        <button type="button" onclick="selectPaymentMethod('QR')" id="btn-pay-qr"
                            style="flex:1; padding:14px; border-radius:12px; border:2px solid #333; background:#1a1a1a; color:#888; font-weight:700; cursor:pointer;">
                            <i class="fa-solid fa-qrcode"></i> Mã QR
                        </button>
                    </div>
                    <div id="panel-card" style="background:#1a1a1a; border:1px solid #333; border-radius:16px; padding:24px;">
                        <label style="display:block; font-size:11px; color:#888; margin-bottom:8px; text-transform:uppercase;">Số thẻ thanh toán</label>
                        <input type="text" id="payment-card-number" maxlength="19" placeholder="9704-0000-1111-0001"
                            autocomplete="off" spellcheck="false"
                            style="width:100%; padding:12px; background:#111; border:1px solid #333; border-radius:10px; color:white; margin-bottom:8px; font-family:monospace; letter-spacing:1px;">
                        <p style="font-size:10px; color:#666; margin-bottom:16px;">Nhập chính xác số thẻ trong hệ thống (VD: 9704-0000-1111-0001).</p>
                        <label style="display:block; font-size:11px; color:#888; margin-bottom:8px; text-transform:uppercase;">Mã PIN (6 số)</label>
                        <input type="password" id="payment-pin" maxlength="6" placeholder="123456"
                            autocomplete="off" inputmode="numeric"
                            style="width:100%; padding:12px; background:#111; border:1px solid #333; border-radius:10px; color:white;">
                        <p id="payment-pin-error" class="hidden" style="font-size:12px; color:#f87171; margin-top:8px; font-weight:700;"></p>
                        <p style="font-size:10px; color:#666; margin-top:8px;">Mã PIN trong database: <span style="font-family:monospace; color:#888;">123456</span></p>
                    </div>
                    <div id="panel-qr" class="hidden" style="background:#1a1a1a; border:1px solid #333; border-radius:16px; padding:24px; text-align:center;">
                        <img id="qr-code-image" src="" alt="QR" style="width:200px; height:200px; margin:0 auto 16px; border-radius:12px; background:white; padding:8px;">
                        <h3 style="font-size:18px; font-weight:800;">QUÉT MÃ ĐỂ THANH TOÁN</h3>
                        <p style="color:var(--text-muted); margin-top:8px; font-size:13px;">Mở ứng dụng ngân hàng hoặc ví điện tử</p>
                        <table class="qr-info-table" style="width:100%; margin-top:16px; font-size:12px; text-align:left; border-collapse:collapse; border:1px solid #333; border-radius:12px; overflow:hidden;">
                            <tr style="background:#111;"><td style="color:#888;padding:10px 12px;">Ngân hàng</td><td class="qr-bank-name" style="color:#fff;font-weight:700;text-align:right;padding:10px 12px;">—</td></tr>
                            <tr><td style="color:#888;padding:10px 12px;">Số tài khoản</td><td class="qr-account-number" style="color:#fff;font-weight:700;text-align:right;padding:10px 12px;">—</td></tr>
                            <tr style="background:#111;"><td style="color:#888;padding:10px 12px;">Chủ tài khoản</td><td class="qr-account-name" style="color:#fff;font-weight:700;text-align:right;padding:10px 12px;">—</td></tr>
                            <tr><td style="color:#888;padding:10px 12px;">Nội dung CK</td><td id="qr-transaction-code" style="color:#888;font-size:10px;text-align:right;padding:10px 12px;word-break:break-all;"></td></tr>
                            <tr style="background:#111;"><td style="color:#888;padding:10px 12px;">Số tiền</td><td id="qr-amount-display" style="color:var(--primary-color);font-weight:800;text-align:right;padding:10px 12px;">0đ</td></tr>
                        </table>
                        <button type="button" onclick="loadQrCode()" style="margin-top:14px;background:none;border:none;color:var(--text-muted);font-size:12px;cursor:pointer;text-decoration:underline;">Tạo lại mã QR</button>
                    </div>
                </div>

                <div class="booking-step-content hidden" id="step-4">
                    <button type="button" class="booking-step-back booking-step-back-inline" onclick="changeStep(-1)" style="margin-bottom:16px;">
                        <i class="fa-solid fa-arrow-left"></i>
                        <span class="booking-step-back-label">Quay lại thanh toán</span>
                    </button>
                    <h3 style="font-weight: 800; font-size: 18px; margin-bottom: 12px;">XÁC NHẬN ĐƠN ĐẶT VÉ</h3>
                    <p style="color: var(--text-muted); font-size: 13px; margin-bottom: 20px;">Kiểm tra lại thông tin trước khi thanh toán.</p>

                    <div style="background:#1a1a1a; border:1px solid #333; border-radius:16px; overflow:hidden;">
                        <div style="padding:20px; border-bottom:1px solid #333;">
                            <p style="font-size:10px; color:#888; text-transform:uppercase; margin-bottom:4px;">Phim</p>
                            <p id="confirm-movie-title" style="color:white; font-weight:800; font-size:17px;"></p>
                        </div>
                        <div style="padding:20px; border-bottom:1px solid #333; display:grid; grid-template-columns:1fr 1fr; gap:16px;">
                            <div>
                                <p style="font-size:10px; color:#888; text-transform:uppercase; margin-bottom:4px;">Ngày chiếu</p>
                                <p id="confirm-date" style="color:white; font-weight:700;"></p>
                            </div>
                            <div>
                                <p style="font-size:10px; color:#888; text-transform:uppercase; margin-bottom:4px;">Giờ chiếu</p>
                                <p id="confirm-time" style="color:var(--primary-color); font-weight:700;"></p>
                            </div>
                        </div>
                        <div style="padding:20px; border-bottom:1px solid #333;">
                            <p style="font-size:10px; color:#888; text-transform:uppercase; margin-bottom:12px;">Chi tiết ghế</p>
                            <div id="confirm-seats-list"></div>
                        </div>
                        <div style="padding:20px; border-bottom:1px solid #333;">
                            <p style="font-size:10px; color:#888; text-transform:uppercase; margin-bottom:4px;">Thanh toán</p>
                            <p id="confirm-payment-method" style="color:white; font-weight:700;"></p>
                            <p id="confirm-payment-detail" style="color:#888; font-size:13px; margin-top:4px;"></p>
                        </div>
                        <div style="padding:20px; display:flex; justify-content:space-between; align-items:center; background:#111;">
                            <span style="color:#888; font-size:12px; font-weight:700; text-transform:uppercase;">Tổng thanh toán</span>
                            <span id="confirm-total" style="color:var(--primary-color); font-size:22px; font-weight:800;"></span>
                        </div>
                    </div>

                    <label style="display:flex; align-items:flex-start; gap:12px; margin-top:20px; cursor:pointer;">
                        <input type="checkbox" id="confirm-agree" style="margin-top:3px; width:16px; height:16px; accent-color:var(--primary-color);">
                        <span style="font-size:13px; color:var(--text-muted);">
                            Tôi xác nhận thông tin đặt vé và phương thức thanh toán là chính xác.
                        </span>
                    </label>
                </div>

                <div class="booking-main-nav">
                    <button type="button" id="btn-booking-main-prev" class="btn-nav btn-back" onclick="changeStep(-1)">
                        <i class="fa-solid fa-arrow-left"></i>
                        <span class="booking-step-back-label">Quay lại</span>
                    </button>
                    <button type="button" id="btn-booking-main-next" class="btn-nav btn-next" onclick="changeStep(1)">Tiếp tục</button>
                </div>

            </div>

            <div class="booking-sidebar">
                <img id="modal-movie-poster" src="" alt="Poster" class="sidebar-poster">
                <h3 id="modal-movie-title" style="font-size: 20px; font-weight: 800; line-height: 1.2; margin-bottom: 20px;">Tên Phim</h3>
                
                <div class="summary-item">
                    <div class="summary-label">Rạp chiếu</div>
                    <div class="summary-value">Starlight Quận 1</div>
                </div>
                <div class="summary-item">
                    <div class="summary-label">Suất chiếu</div>
                    <div class="summary-value text-primary"><span id="summary-date">Hôm nay</span> | <span id="summary-time">--:--</span></div>
                </div>
                <div class="summary-item">
                    <div class="summary-label">Ghế đã chọn</div>
                    <div class="summary-value" id="summary-seats">Chưa chọn ghế</div>
                    <div id="summary-seats-detail" class="summary-seats-detail"></div>
                </div>
                
                <div class="total-price">
                    <div class="summary-label">Tổng tiền</div>
                    <div class="amount" id="summary-total">0đ</div>
                </div>

                <div class="booking-nav">
                    <button class="btn-nav btn-back" id="btn-booking-prev" onclick="changeStep(-1)">Quay lại</button>
                    <form id="submit-booking-form" action="${pageContext.request.contextPath}/customer/booking/checkout" method="POST" class="m-0 p-0">
                        <input type="hidden" name="movieId" id="form-movie-id">
                        <input type="hidden" name="showtimeId" id="form-showtime-id">
                        <input type="hidden" name="showTime" id="form-show-time">
                        <input type="hidden" name="showDate" id="form-show-date">
                        <input type="hidden" name="selectedSeats" id="form-selected-seats">
                        <input type="hidden" name="paymentMethod" id="form-payment-method" value="Card">
                        <input type="hidden" name="cardNumber" id="form-card-number">
                        <input type="hidden" name="paymentId" id="form-payment-id">
                        <input type="hidden" name="pinCode" id="form-pin-code">
                        <input type="hidden" name="qrTransactionCode" id="form-qr-transaction-code">
                        <button type="button" class="btn-nav btn-next" id="btn-booking-next" onclick="changeStep(1)">Tiếp tục</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <footer>
        <div class="footer-content">
            <div class="logo footer-logo">
                <div class="logo-icon"><i class="fa-solid fa-star"></i></div>
                <div class="logo-text"><span>STARLIGHT</span></div>
            </div>
            <div class="footer-desc">Hệ thống rạp chiếu phim chất lượng cao mang đến trải nghiệm đỉnh cao cho khán giả yêu điện ảnh.</div>
            <div class="footer-links">
                <h4>Chính sách</h4>
                <ul>
                    <li><a href="#">Điều khoản sử dụng</a></li>
                    <li><a href="#">Chính sách bảo mật</a></li>
                    <li><a href="#">Câu hỏi thường gặp</a></li>
                </ul>
            </div>
            <div class="footer-links">
                <h4>Kết nối</h4>
                <div style="display: flex; gap: 15px; font-size: 20px;">
                    <a href="#"><i class="fa-brands fa-facebook"></i></a>
                    <a href="#"><i class="fa-brands fa-instagram"></i></a>
                    <a href="#"><i class="fa-brands fa-youtube"></i></a>
                    <a href="#"><i class="fa-brands fa-tiktok"></i></a>
                </div>
            </div>
        </div>
        <div class="footer-bottom">
            <p>&copy; 2024 Starlight Cinema. All rights reserved.</p>
        </div>
    </footer>

    <script>
        const contextPath = "${pageContext.request.contextPath}";
        let lobbySelectedDate = "${selectedDate}";
        let calendarView = new Date(lobbySelectedDate + 'T12:00:00');
        const datesWithShowtimes = new Set();

        function formatDateDb(d) {
            const y = d.getFullYear();
            const m = String(d.getMonth() + 1).padStart(2, '0');
            const day = String(d.getDate()).padStart(2, '0');
            return y + '-' + m + '-' + day;
        }

        function formatDateDisplay(dateStr) {
            const p = dateStr.split('-');
            return p[2] + '/' + p[1] + '/' + p[0];
        }

        function escapeHtml(text) {
            const div = document.createElement('div');
            div.textContent = text || '';
            return div.innerHTML;
        }

        function renderMovieGrid(movies) {
            const grid = document.getElementById('movie-grid');
            if (!grid) return;
            if (!movies || movies.length === 0) {
                grid.innerHTML = '<p id="movie-grid-empty" class="text-gray-500" style="grid-column:1/-1;">Chưa có phim trong hệ thống.</p>';
                document.getElementById('movie-filter-empty')?.classList.add('hidden');
                return;
            }
            grid.innerHTML = movies.map(movie => {
                const tags = (movie.showtimes || []).map(t =>
                    '<span class="movie-showtime-tag">' + escapeHtml(t) + '</span>'
                ).join('');
                const title = escapeHtml(movie.title);
                const poster = escapeHtml(movie.posterUrl);
                return '<div class="movie-card" data-genre="' + escapeHtml(movie.genre) + '" data-title="' + title + '" onclick="openBooking(\'' + movie.id_Movie + '\', \'' + title.replace(/'/g, "\\'") + '\', \'' + poster + '\', ' + movie.basePrice + ')">' +
                    '<div class="movie-poster"><img src="' + poster + '" alt="' + title + '" onerror="this.src=\'https://via.placeholder.com/300x450?text=No+Poster\'">' +
                    '<div class="poster-overlay"><div class="hover-book-btn"><i class="fa-solid fa-ticket"></i> Đặt vé ngay</div></div></div>' +
                    '<div class="movie-info"><h4>' + title + '</h4><p>' + escapeHtml(movie.genre) + ' | ' + movie.duration + ' Phút</p>' +
                    (tags ? '<div class="movie-showtime-tags">' + tags + '</div>' : '') + '</div></div>';
            }).join('');
            const searchInput = document.getElementById('movie-search-input');
            filterMovies(getActiveGenre(), searchInput ? searchInput.value : '');
        }

        function loadMoviesForDate(dateStr) {
            lobbySelectedDate = dateStr;
            const titleEl = document.getElementById('section-movie-title');
            const labelEl = document.getElementById('calendar-selected-label');
            const display = formatDateDisplay(dateStr);
            if (titleEl) titleEl.textContent = 'Phim chiếu ngày ' + display;
            if (labelEl) labelEl.textContent = 'Đang xem: ' + display;

            fetch(contextPath + '/customer/api/movies-by-date?date=' + encodeURIComponent(dateStr))
                .then(res => res.json())
                .then(data => {
                    renderMovieGrid(data);
                    if (data && data.length) datesWithShowtimes.add(dateStr);
                    renderLobbyCalendar();
                })
                .catch(() => renderMovieGrid([]));
        }

        function renderLobbyCalendar() {
            const daysEl = document.getElementById('calendar-days');
            const monthLabel = document.getElementById('calendar-month-label');
            if (!daysEl || !monthLabel) return;

            const year = calendarView.getFullYear();
            const month = calendarView.getMonth();
            const monthNames = ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6',
                'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'];
            monthLabel.textContent = monthNames[month] + ' ' + year;

            const firstDay = new Date(year, month, 1);
            const startOffset = (firstDay.getDay() + 6) % 7;
            const daysInMonth = new Date(year, month + 1, 0).getDate();
            const todayStr = formatDateDb(new Date());

            daysEl.innerHTML = '';
            for (let i = 0; i < startOffset; i++) {
                const btn = document.createElement('button');
                btn.type = 'button';
                btn.className = 'calendar-day other-month';
                btn.disabled = true;
                btn.textContent = '';
                daysEl.appendChild(btn);
            }
            for (let d = 1; d <= daysInMonth; d++) {
                const dateObj = new Date(year, month, d);
                const dateStr = formatDateDb(dateObj);
                const btn = document.createElement('button');
                btn.type = 'button';
                btn.className = 'calendar-day';
                btn.textContent = d;
                if (dateStr < todayStr) {
                    btn.disabled = true;
                    btn.classList.add('other-month');
                }
                if (dateStr === todayStr) btn.classList.add('today');
                if (dateStr === lobbySelectedDate) btn.classList.add('selected');
                if (datesWithShowtimes.has(dateStr)) btn.classList.add('has-showtime');
                btn.addEventListener('click', () => {
                    if (dateStr < todayStr) return;
                    loadMoviesForDate(dateStr);
                });
                daysEl.appendChild(btn);
            }
        }

        function prefetchMonthShowtimeHints() {
            const year = calendarView.getFullYear();
            const month = calendarView.getMonth();
            const daysInMonth = new Date(year, month + 1, 0).getDate();
            const todayStr = formatDateDb(new Date());
            const promises = [];
            for (let d = 1; d <= daysInMonth; d++) {
                const dateStr = formatDateDb(new Date(year, month, d));
                if (dateStr < todayStr) continue;
                promises.push(
                    fetch(contextPath + '/customer/api/movies-by-date?date=' + encodeURIComponent(dateStr))
                        .then(r => r.json())
                        .then(list => { if (list && list.length) datesWithShowtimes.add(dateStr); })
                        .catch(() => {})
                );
            }
            Promise.all(promises).then(() => renderLobbyCalendar());
        }

        document.getElementById('cal-prev')?.addEventListener('click', () => {
            calendarView.setMonth(calendarView.getMonth() - 1);
            if (calendarView < new Date(new Date().getFullYear(), new Date().getMonth(), 1)) {
                calendarView = new Date(new Date().getFullYear(), new Date().getMonth(), 1);
            }
            renderLobbyCalendar();
            prefetchMonthShowtimeHints();
        });
        document.getElementById('cal-next')?.addEventListener('click', () => {
            calendarView.setMonth(calendarView.getMonth() + 1);
            renderLobbyCalendar();
            prefetchMonthShowtimeHints();
        });

        document.addEventListener('DOMContentLoaded', function() {
            datesWithShowtimes.add(lobbySelectedDate);
            renderLobbyCalendar();
            prefetchMonthShowtimeHints();
        });
        let currentStep = 1;
        let selectedTime = null;
        let selectedShowtimeId = null;
        let selectedSeats = [];
        let currentMovieId = null;
        let ticketPrice = 0;
        let paymentMethod = 'Card';
        let qrTransactionCode = '';

        function getBookingBackLabel(step) {
            if (step === 1) return 'Quay về trang chủ';
            if (step === 2) return 'Quay lại chọn suất';
            if (step === 3) return 'Quay lại chọn ghế';
            if (step === 4) return 'Quay lại thanh toán';
            return 'Quay lại';
        }

        function getBookingNextLabel(step) {
            if (step === 4) return 'Xác nhận & Thanh toán';
            if (step === 3) return 'Xem lại đơn hàng';
            return 'Tiếp tục';
        }

        function updateBookingNavLabels() {
            const backLabel = getBookingBackLabel(currentStep);
            const nextLabel = getBookingNextLabel(currentStep);

            const prevBtn = document.getElementById('btn-booking-prev');
            if (prevBtn) prevBtn.innerText = backLabel;

            const topBackLabel = document.getElementById('btn-booking-top-back-label');
            if (topBackLabel) topBackLabel.innerText = backLabel;

            document.querySelectorAll('#booking-modal .booking-step-back-label').forEach(el => {
                el.innerText = backLabel;
            });

            const nextBtn = document.getElementById('btn-booking-next');
            if (nextBtn) nextBtn.innerText = nextLabel;

            const mainNextBtn = document.getElementById('btn-booking-main-next');
            if (mainNextBtn) mainNextBtn.innerText = nextLabel;
        }

        // ==========================================
        // 1. RENDER 7 NGÀY & GỌI API LẤY SUẤT CHIẾU
        // ==========================================
        
        // Hàm tạo 7 nút ngày bắt đầu từ hôm nay
        function generateDateButtons() {
            const dateListContainer = document.getElementById('dynamic-date-list');
            dateListContainer.innerHTML = ''; // Clear cũ
            
            const today = new Date();
            const daysOfWeek = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];

            for (let i = 0; i < 7; i++) {
                let d = new Date();
                d.setDate(today.getDate() + i);

                let dayName = i === 0 ? 'Hôm nay' : daysOfWeek[d.getDay()];
                let dateNum = d.getDate();
                
                // Format YYYY-MM-DD để truyền xuống DB
                let tzoffset = (new Date()).getTimezoneOffset() * 60000;
                let fullDateStr = (new Date(d - tzoffset)).toISOString().split('T')[0];

                let btn = document.createElement('button');
                btn.className = 'date-btn ' + (i === 0 ? 'active' : '');
               
                btn.innerHTML = '<span>' + dayName + '</span><strong>' + dateNum + '</strong>';
                
                // Sự kiện khi click chọn ngày khác
                btn.onclick = () => selectDate(btn, fullDateStr, dayName, dateNum);
                
                dateListContainer.appendChild(btn);
            }
        }

        // Xử lý khi người dùng ấn vào 1 ngày bất kỳ
        function selectDate(element, dateStr, dayName, dateNum) {
            document.querySelectorAll('.date-btn').forEach(btn => btn.classList.remove('active'));
            element.classList.add('active');
            
            // Cập nhật lên sidebar (ĐÃ FIX: Nối chuỗi)
            document.getElementById('summary-date').innerText = dayName + ' ' + dateNum;
            
            // Reset giờ chiếu
            selectedTime = null;
            selectedShowtimeId = null;
            document.getElementById('summary-time').innerText = '--:--';
            document.getElementById('form-show-time').value = '';
            document.getElementById('form-showtime-id').value = '';

            // Gọi API lấy dữ liệu suất chiếu
            fetchShowtimes(currentMovieId, dateStr);
        }

        // Dùng AJAX fetch API
        // Dùng AJAX fetch API
// Dùng AJAX fetch API
        function fetchShowtimes(movieId, dateStr) {
            const timeSlotsContainer = document.getElementById('dynamic-time-slots');
            timeSlotsContainer.innerHTML = '<p style="color:var(--text-muted); font-size:14px; padding:10px 0;">Đang tải suất chiếu...</p>';

            const fetchUrl = contextPath + '/customer/api/showtimes?movieId=' + movieId + '&date=' + dateStr;

            fetch(fetchUrl, { headers: { 'Accept': 'application/json' } })
                .then(async response => {
                    // Nếu server báo lỗi (400, 404, 500...)
                    if (!response.ok) {
                        throw new Error("Lỗi Server " + response.status + ": Đường dẫn hoặc tham số không hợp lệ.");
                    }
                    
                    // Kiểm tra xem dữ liệu trả về có đúng là chuỗi JSON không hay là HTML (do bị bắt Login)
                    const contentType = response.headers.get("content-type");
                    if (contentType && contentType.indexOf("application/json") !== -1) {
                        return response.json();
                    } else {
                        throw new Error("Dữ liệu trả về không phải JSON! Rất có thể API đã bị chuyển hướng (Redirect) tới trang Login.");
                    }
                })
                .then(data => {
                    timeSlotsContainer.innerHTML = '';
                    if (data && data.length > 0) {
                        data.forEach(st => {
                            let timeStr = st.startTime;
                            let btn = document.createElement('button');
                            btn.className = 'time-slot';
                            btn.onclick = () => selectTime(btn, timeStr, st.id_Showtime);
                            btn.innerHTML = '<strong>' + timeStr + '</strong>';
                            timeSlotsContainer.appendChild(btn);
                        });
                    } else {
                        timeSlotsContainer.innerHTML = '<p style="color: #666; font-size:14px; padding:10px 0; font-style: italic;">Không có suất chiếu trong ngày này.</p>';
                    }
                })
                .catch(err => {
                    console.error('Chi tiết lỗi:', err);
                    // Đưa thẳng cái lỗi rõ ràng nhất ra giao diện để chúng ta biết đường sửa!
                    timeSlotsContainer.innerHTML = '<p style="color: #ff4444; font-size:14px; padding:10px 0;">' + err.message + '</p>';
                });
        }
        function openBooking(movieId, title, posterUrl, basePrice) {
            document.getElementById('booking-modal').classList.remove('hidden');
            document.body.style.overflow = 'hidden';
            
            ticketPrice = basePrice || 85000; 
            
            document.getElementById('modal-movie-title').innerText = title;
            document.getElementById('modal-movie-poster').src = posterUrl;
            
            currentMovieId = movieId;
            document.getElementById('form-movie-id').value = movieId; 
            
            selectedTime = null;
            selectedShowtimeId = null;
            selectedSeats = [];
            currentStep = 1;
            document.querySelectorAll('.booking-step-content').forEach(el => el.classList.add('hidden'));
            document.getElementById('step-1').classList.remove('hidden');
            document.querySelectorAll('.step-item').forEach(el => el.classList.remove('active'));
            document.getElementById('step-idx-1').classList.add('active');
            document.getElementById('confirm-agree').checked = false;
            updateBookingNavLabels();
            updateSummary();
            renderSeats(); 
            
            // Generate 7 ngày
            generateDateButtons();
            
            // Auto fetch suất chiếu của ngày "Hôm nay"
            let tzoffset = (new Date()).getTimezoneOffset() * 60000;
            let todayStr = (new Date(Date.now() - tzoffset)).toISOString().split('T')[0];
            fetchShowtimes(movieId, todayStr);
            document.getElementById('summary-date').innerText = "Hôm nay " + new Date().getDate();
            if (typeof selectPaymentMethod === 'function') selectPaymentMethod('Card');
        }

        function closeBooking() {
            document.getElementById('booking-modal').classList.add('hidden');
            document.body.style.overflow = 'auto';
            currentStep = 1;
            document.querySelectorAll('.booking-step-content').forEach(el => el.classList.add('hidden'));
            document.getElementById('step-1').classList.remove('hidden');
            document.querySelectorAll('.step-item').forEach(el => el.classList.remove('active'));
            document.getElementById('step-idx-1').classList.add('active');
            document.getElementById('confirm-agree').checked = false;
            updateBookingNavLabels();
        }

        function selectTime(element, time, showtimeId) {
            document.querySelectorAll('.time-slot').forEach(btn => btn.classList.remove('active'));
            element.classList.add('active');
            selectedTime = time;
            selectedShowtimeId = showtimeId;
            document.getElementById('summary-time').innerText = time;
            document.getElementById('form-show-time').value = time;
            document.getElementById('form-showtime-id').value = showtimeId;
            loadSeatsForShowtime(showtimeId);
        }

        function resolveSeatDisplayStatus(seat) {
            if (seat.status) return seat.status;
            if (seat.sold) return 'Sold';
            if (seat.unavailable) return 'Maintenance';
            return 'Available';
        }

        function loadSeatsForShowtime(showtimeId) {
            if (!showtimeId) return;
            fetch(contextPath + '/customer/api/seats?showtimeId=' + showtimeId, {
                headers: { 'Accept': 'application/json' }
            })
                .then(async res => {
                    if (!res.ok) throw new Error('Không tải được sơ đồ ghế (mã ' + res.status + ')');
                    return res.json();
                })
                .then(data => {
                    window._seatLayout = data || { totalRows: 0, totalCols: 0, seats: [] };
                    window._soldSeats = new Set();
                    window._unavailableSeats = new Set();
                    (data.seats || []).forEach(s => {
                        const st = resolveSeatDisplayStatus(s);
                        if (st === 'Sold') window._soldSeats.add(s.seatName);
                        if (st === 'Maintenance') window._unavailableSeats.add(s.seatName);
                    });
                    selectedSeats = [];
                    document.querySelectorAll('#form-selected-seats').forEach(el => { el.value = ''; });
                    renderSeats();
                    updateSummary();
                })
                .catch(err => {
                    alert(err.message || 'Không tải được sơ đồ ghế. Vui lòng chọn lại suất chiếu!');
                });
        }

        // ==========================================
        // 3. RENDER GHẾ VÀ ĐIỀU HƯỚNG
        // ==========================================
        function renderSeats() {
            const grid = document.getElementById('seat-grid');
            grid.innerHTML = '';
            const layout = window._seatLayout || { totalRows: 0, totalCols: 0, seats: [] };
            const totalRows = layout.totalRows || 0;
            const totalCols = layout.totalCols || 1;
            grid.style.gridTemplateColumns = 'repeat(' + totalCols + ', minmax(32px, 1fr))';

            const seatMap = {};
            (layout.seats || []).forEach(s => {
                seatMap[s.rowPos + '-' + s.colPos] = s;
            });

            for (let r = 1; r <= totalRows; r++) {
                for (let c = 1; c <= totalCols; c++) {
                    const seat = seatMap[r + '-' + c];
                    if (!seat) continue;
                    const seatId = seat.seatName;
                    const displayStatus = resolveSeatDisplayStatus(seat);
                    const div = document.createElement('div');
                    let className = 'seat';
                    if (displayStatus === 'Sold') className += ' sold';
                    else if (displayStatus === 'Maintenance') className += ' maintenance';
                    div.className = className;
                    div.innerText = seatId;
                    if (displayStatus === 'Sold') {
                        div.title = 'Ghế đã bán';
                        div.onclick = () => alert('Ghế ' + seatId + ' đã được đặt! Vui lòng chọn ghế khác.');
                    } else if (displayStatus === 'Maintenance') {
                        div.title = 'Ghế bảo trì';
                        div.onclick = () => alert('Ghế ' + seatId + ' đang bảo trì, không thể đặt!');
                    } else {
                        div.title = 'Ghế trống';
                        div.onclick = () => toggleSeat(div, seatId);
                    }
                    grid.appendChild(div);
                }
            }
        }

        function getSeatPrice() { return ticketPrice; }

        function toggleSeat(element, seatId) {
            if (element.classList.contains('sold')) {
                alert('Ghế ' + seatId + ' đã được đặt! Vui lòng chọn ghế khác.');
                return;
            }
            if (element.classList.contains('maintenance')) {
                alert('Ghế ' + seatId + ' đang bảo trì, không thể đặt!');
                return;
            }
            if(element.classList.contains('selected')) {
                element.classList.remove('selected');
                selectedSeats = selectedSeats.filter(s => s.id !== seatId);
            } else {
                if(selectedSeats.length >= 8) { alert('Bạn chỉ được chọn tối đa 8 ghế!'); return; }
                element.classList.add('selected');
                selectedSeats.push({ id: seatId });
            }
            document.getElementById('form-selected-seats').value = selectedSeats.map(s => s.id).join(',');
            updateSummary();
        }

        function updateSummary() {
            const fmt = n => new Intl.NumberFormat('vi-VN').format(n) + 'đ';
            const seatsEl = document.getElementById('summary-seats');
            const detailEl = document.getElementById('summary-seats-detail');

            if (selectedSeats.length === 0) {
                seatsEl.innerText = 'Chưa chọn ghế';
                if (detailEl) detailEl.innerHTML = '';
            } else {
                seatsEl.innerText = selectedSeats.map(s => s.id).join(', ');
                if (detailEl) {
                    detailEl.innerHTML = '';
                    selectedSeats.forEach(s => {
                        const price = getSeatPrice();
                        const row = document.createElement('div');
                        row.className = 'seat-price-row';
                        row.innerHTML =
                            '<span>Ghế <span class="seat-name">' + s.id + '</span></span>' +
                            '<span class="seat-price">' + fmt(price) + '</span>';
                        detailEl.appendChild(row);
                    });
                }
            }

            const total = selectedSeats.reduce((sum, s) => sum + getSeatPrice(), 0);
            document.getElementById('summary-total').innerText = fmt(total);
        }

        const CARD_NUMBER_PATTERN = /^9704-0000-1111-\d{4}$/;
        const PIN_LENGTH = 6;

        function maskCardNumber(value) {
            if (!value || value.length < 4) return value || '';
            return '**** **** **** ' + value.slice(-4);
        }

        function validateCardPaymentInput() {
            const cardInput = document.getElementById('payment-card-number');
            const pinInput = document.getElementById('payment-pin');
            const cardNumber = cardInput ? cardInput.value : '';
            const pin = pinInput ? pinInput.value : '';

            if (!cardNumber) {
                alert('Vui lòng nhập số thẻ thanh toán!');
                if (cardInput) cardInput.focus();
                return false;
            }
            if (!CARD_NUMBER_PATTERN.test(cardNumber)) {
                alert('Số thẻ thanh toán không hợp lệ! Vui lòng nhập chính xác theo định dạng: 9704-0000-1111-0001');
                if (cardInput) cardInput.focus();
                return false;
            }
            if (!pin) {
                alert('Vui lòng nhập mã PIN!');
                if (pinInput) pinInput.focus();
                return false;
            }
            if (pin.length !== PIN_LENGTH || !/^\d+$/.test(pin)) {
                alert('Mã PIN phải khớp chính xác với mã PIN của thẻ trong hệ thống (6 chữ số)!');
                if (pinInput) pinInput.focus();
                return false;
            }
            return true;
        }

        function showPinError(message) {
            const el = document.getElementById('payment-pin-error');
            if (!el) return;
            el.textContent = message || '';
            el.classList.toggle('hidden', !message);
            el.style.display = message ? 'block' : 'none';
        }

        function advanceBookingStep(n) {
            const newStep = currentStep + n;
            if (newStep < 1 || newStep > 4) return;
            document.getElementById('step-' + currentStep).classList.add('hidden');
            document.getElementById('step-idx-' + currentStep).classList.remove('active');
            currentStep = newStep;
            document.getElementById('step-' + currentStep).classList.remove('hidden');
            document.getElementById('step-idx-' + currentStep).classList.add('active');
            updateBookingNavLabels();
        }

        function verifyCardPinWithServer(cardNumber, pin) {
            const body = new URLSearchParams();
            body.append('cardNumber', cardNumber);
            body.append('pinCode', pin);
            return fetch(contextPath + '/customer/api/verify-card-pin', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'Accept': 'application/json'
                },
                body: body.toString()
            }).then(res => res.json());
        }

        function populateConfirmForm() {
            const total = selectedSeats.reduce((sum, s) => sum + getSeatPrice(), 0);
            const fmt = n => new Intl.NumberFormat('vi-VN').format(n) + 'đ';

            document.getElementById('confirm-movie-title').innerText = document.getElementById('modal-movie-title').innerText;
            document.getElementById('confirm-date').innerText = document.getElementById('summary-date').innerText;
            document.getElementById('confirm-time').innerText = selectedTime || '--:--';
            document.getElementById('confirm-total').innerText = fmt(total);

            const seatsList = document.getElementById('confirm-seats-list');
            seatsList.innerHTML = '';
            selectedSeats.forEach(s => {
                const price = getSeatPrice();
                const row = document.createElement('div');
                row.style.cssText = 'display:flex; justify-content:space-between; color:#ccc; font-size:14px; margin-bottom:8px;';
                row.innerHTML = '<span>Ghế <strong style="color:white">' + s.id + '</strong></span><span>' + fmt(price) + '</span>';
                seatsList.appendChild(row);
            });

            if (paymentMethod === 'Card') {
                const cardNumber = document.getElementById('payment-card-number').value;
                document.getElementById('confirm-payment-method').innerHTML = '<i class="fa-solid fa-credit-card"></i> Thẻ tín dụng';
                document.getElementById('confirm-payment-detail').innerText = 'Thẻ: ' + maskCardNumber(cardNumber);
            } else {
                document.getElementById('confirm-payment-method').innerHTML = '<i class="fa-solid fa-qrcode"></i> Mã QR';
                document.getElementById('confirm-payment-detail').innerText = qrTransactionCode
                    ? 'Mã giao dịch: ' + qrTransactionCode : 'Thanh toán qua ví điện tử / ngân hàng';
            }
            document.getElementById('confirm-agree').checked = false;
        }

        function submitBooking() {
            if (paymentMethod === 'Card') {
                document.getElementById('form-card-number').value = document.getElementById('payment-card-number').value;
                document.getElementById('form-payment-id').value = '';
                document.getElementById('form-pin-code').value = document.getElementById('payment-pin').value;
                document.getElementById('form-qr-transaction-code').value = '';
            } else {
                document.getElementById('form-card-number').value = '';
                document.getElementById('form-payment-id').value = '';
                document.getElementById('form-pin-code').value = '';
                document.getElementById('form-qr-transaction-code').value = qrTransactionCode || '';
            }
            document.getElementById('submit-booking-form').submit();
        }

        function changeStep(n) {
            if (n === -1 && currentStep === 1) {
                closeBooking();
                return;
            }

            if (n === 1) { 
                if (currentStep === 1 && !selectedTime) {
                    alert('Vui lòng chọn suất chiếu để tiếp tục!');
                    return;
                }
                if (currentStep === 2 && selectedSeats.length === 0) {
                    alert('Vui lòng chọn ít nhất một chỗ ngồi!');
                    return;
                }
                if (currentStep === 3) {
                    let checkLogin = "${sessionScope.loggedInUser != null ? 'true' : 'false'}";
                    if(checkLogin === 'false') {
                        alert("Vui lòng đăng nhập để tiến hành thanh toán!");
                        window.location.href = contextPath + "/login-customer";
                        return;
                    }
                    if (!selectedShowtimeId) {
                        alert('Vui lòng chọn suất chiếu!');
                        return;
                    }
                    if (paymentMethod === 'Card') {
                        if (!validateCardPaymentInput()) return;
                        showPinError('');
                        const cardNumber = document.getElementById('payment-card-number').value;
                        const pin = document.getElementById('payment-pin').value;
                        verifyCardPinWithServer(cardNumber, pin)
                            .then(function (data) {
                                if (!data.valid) {
                                    const msg = data.error || 'Mã PIN không chính xác! Vui lòng nhập đúng mã PIN của thẻ.';
                                    showPinError(msg);
                                    alert(msg);
                                    document.getElementById('payment-pin').focus();
                                    return;
                                }
                                showPinError('');
                                populateConfirmForm();
                                advanceBookingStep(1);
                            })
                            .catch(function () {
                                alert('Không thể xác minh mã PIN. Vui lòng thử lại.');
                            });
                        return;
                    } else if (paymentMethod === 'QR') {
                        if (!qrTransactionCode) {
                            alert('Vui lòng tạo mã QR thanh toán trước khi tiếp tục!');
                            loadQrCode();
                            return;
                        }
                    }
                    populateConfirmForm();
                }
                if (currentStep === 4) {
                    if (!document.getElementById('confirm-agree').checked) {
                        alert('Vui lòng xác nhận thông tin đặt vé trước khi thanh toán!');
                        return;
                    }
                    submitBooking();
                    return;
                }
                if (currentStep === 2) {
                    selectPaymentMethod('Card');
                    loadQrCode();
                }
            }

            advanceBookingStep(n);
        }

        function getActiveGenre() {
            const active = document.querySelector('.genre-btn.active');
            return active ? (active.dataset.genre || 'all') : 'all';
        }

        function filterMovies(genre, keyword) {
            const cards = document.querySelectorAll('#movie-grid .movie-card');
            const kw = (keyword || '').toLowerCase().trim();
            let visible = 0;
            cards.forEach(card => {
                const cardGenre = (card.dataset.genre || '').toLowerCase();
                const title = (card.dataset.title || '').toLowerCase();
                const matchGenre = !genre || genre === 'all' || cardGenre.includes((genre || '').toLowerCase());
                const matchKw = !kw || title.includes(kw) || cardGenre.includes(kw);
                const show = matchGenre && matchKw;
                card.style.display = show ? '' : 'none';
                if (show) visible++;
            });
            const emptyEl = document.getElementById('movie-filter-empty');
            if (emptyEl) emptyEl.classList.toggle('hidden', visible > 0 || cards.length === 0);
        }

        document.querySelectorAll('.genre-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                document.querySelectorAll('.genre-btn').forEach(b => b.classList.remove('active'));
                this.classList.add('active');
                const searchInput = document.getElementById('movie-search-input');
                filterMovies(this.dataset.genre || 'all', searchInput ? searchInput.value : '');
            });
        });

        const searchInput = document.getElementById('movie-search-input');
        if (searchInput) {
            searchInput.addEventListener('input', function() {
                filterMovies(getActiveGenre(), this.value);
            });
            searchInput.addEventListener('keydown', function(e) {
                if (e.key === 'Enter') {
                    const genre = getActiveGenre();
                    let url = contextPath + '/customer/movies?keyword=' + encodeURIComponent(this.value);
                    if (genre && genre !== 'all') url += '&genre=' + encodeURIComponent(genre);
                    window.location.href = url;
                }
            });
        }
    </script>
</body>