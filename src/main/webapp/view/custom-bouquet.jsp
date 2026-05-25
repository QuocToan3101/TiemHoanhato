<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Tạo bó hoa của riêng bạn</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/view/css/font-awesome.min.css" />
    <style>
        :root {
            --bg: #faf6f1;
            --panel: rgba(255, 255, 255, 0.82);
            --panel-strong: #ffffff;
            --text: #3f2c24;
            --muted: #7a6256;
            --primary: #b06a46;
            --primary-dark: #8f5435;
            --accent: #d8a37f;
            --line: rgba(143, 84, 53, 0.16);
            --shadow: 0 20px 50px rgba(74, 46, 33, 0.12);
        }

        * { box-sizing: border-box; }
        body {
            margin: 0;
            font-family: Inter, "Segoe UI", Arial, sans-serif;
            color: var(--text);
            background:
                radial-gradient(circle at top left, rgba(227, 193, 166, 0.35), transparent 28%),
                radial-gradient(circle at top right, rgba(182, 122, 86, 0.14), transparent 24%),
                linear-gradient(180deg, #fffaf6 0%, var(--bg) 100%);
        }

        .page-shell {
            min-height: 100vh;
        }

        .page-hero {
            position: relative;
            overflow: hidden;
            padding: 72px 0 40px;
        }

        .page-hero::before,
        .page-hero::after {
            content: "";
            position: absolute;
            border-radius: 999px;
            pointer-events: none;
            filter: blur(8px);
        }

        .page-hero::before {
            width: 220px;
            height: 220px;
            background: rgba(188, 128, 91, 0.12);
            top: -40px;
            right: -50px;
        }

        .page-hero::after {
            width: 260px;
            height: 260px;
            background: rgba(216, 163, 127, 0.18);
            left: -80px;
            bottom: -120px;
        }

        .container {
            width: min(1240px, calc(100% - 32px));
            margin: 0 auto;
        }

        .hero-grid {
            display: grid;
            grid-template-columns: 1.12fr 0.88fr;
            gap: 26px;
            align-items: stretch;
        }

        .hero-card,
        .form-card,
        .summary-card,
        .tips-card {
            background: var(--panel);
            backdrop-filter: blur(18px);
            -webkit-backdrop-filter: blur(18px);
            border: 1px solid var(--line);
            box-shadow: var(--shadow);
        }

        .hero-card {
            border-radius: 34px;
            padding: 32px;
        }

        .eyebrow {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 10px 14px;
            border-radius: 999px;
            background: rgba(176, 106, 70, 0.1);
            color: var(--primary-dark);
            font-weight: 700;
            letter-spacing: 0.2px;
            font-size: 0.95rem;
        }

        .hero-title {
            margin: 16px 0 14px;
            font-size: clamp(2.5rem, 5vw, 4.5rem);
            line-height: 0.98;
            letter-spacing: -0.03em;
        }

        .hero-copy {
            max-width: 720px;
            font-size: 1.07rem;
            line-height: 1.85;
            color: var(--muted);
            margin: 0 0 22px;
        }

        .hero-badges {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 26px;
        }

        .hero-badge {
            padding: 10px 14px;
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.8);
            border: 1px solid rgba(176, 106, 70, 0.12);
            color: var(--text);
            font-weight: 600;
        }

        .hero-cta-row {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            margin-bottom: 28px;
        }

        .btn-primary,
        .btn-secondary {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            min-height: 56px;
            padding: 0 18px;
            border-radius: 999px;
            text-decoration: none;
            font-weight: 700;
            transition: transform 0.25s ease, box-shadow 0.25s ease, background 0.25s ease;
        }

        .btn-primary {
            color: #fff;
            background: linear-gradient(135deg, #ba7b53 0%, var(--primary) 56%, var(--primary-dark) 100%);
            box-shadow: 0 18px 34px rgba(176, 106, 70, 0.28);
        }

        .btn-secondary {
            color: var(--text);
            background: rgba(255, 255, 255, 0.82);
            border: 1px solid rgba(176, 106, 70, 0.16);
        }

        .btn-primary:hover,
        .btn-secondary:hover { transform: translateY(-2px); }

        .hero-stats {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 12px;
        }

        .stat {
            padding: 16px;
            border-radius: 20px;
            background: rgba(255, 255, 255, 0.82);
            border: 1px solid rgba(176, 106, 70, 0.1);
        }

        .stat strong {
            display: block;
            font-size: 1.2rem;
            margin-bottom: 4px;
        }

        .stat span { color: var(--muted); font-size: 0.95rem; }

        .right-stack {
            display: grid;
            gap: 18px;
        }

        .summary-card,
        .tips-card {
            border-radius: 28px;
            padding: 24px;
        }

        .summary-card h3,
        .tips-card h3,
        .form-card h2 {
            margin: 0 0 14px;
            font-size: 1.35rem;
        }

        .summary-hero {
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 18px;
        }

        .summary-circle {
            width: 88px;
            height: 88px;
            border-radius: 26px;
            background: linear-gradient(135deg, rgba(186, 123, 83, 0.18), rgba(176, 106, 70, 0.06));
            display: grid;
            place-items: center;
            font-size: 2rem;
        }

        .summary-grid {
            display: grid;
            gap: 12px;
        }

        .summary-item {
            display: flex;
            justify-content: space-between;
            gap: 12px;
            padding: 12px 14px;
            border-radius: 18px;
            background: rgba(255, 255, 255, 0.78);
            border: 1px solid rgba(176, 106, 70, 0.08);
        }

        .summary-item span { color: var(--muted); }
        .summary-item strong { text-align: right; max-width: 52%; }

        .form-wrap {
            padding: 8px 0 70px;
        }

        .form-card {
            border-radius: 34px;
            padding: 28px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 18px;
        }

        .field {
            display: grid;
            gap: 10px;
        }

        .field label {
            font-weight: 700;
            color: var(--text);
        }

        .field select,
        .field input[type="text"],
        .field input[type="number"],
        .field textarea {
            width: 100%;
            border-radius: 18px;
            border: 1px solid rgba(140, 91, 66, 0.18);
            background: rgba(255, 255, 255, 0.92);
            color: var(--text);
            padding: 14px 16px;
            font-size: 1rem;
            outline: none;
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
        }

        .field select:focus,
        .field input:focus,
        .field textarea:focus {
            border-color: rgba(176, 106, 70, 0.44);
            box-shadow: 0 0 0 4px rgba(176, 106, 70, 0.08);
        }

        .field textarea {
            min-height: 116px;
            resize: vertical;
        }

        .field-full {
            grid-column: 1 / -1;
        }

        .chips {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .chip {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 11px 14px;
            border-radius: 999px;
            border: 1px solid rgba(176, 106, 70, 0.12);
            background: rgba(255, 255, 255, 0.8);
            cursor: pointer;
            user-select: none;
            transition: transform 0.2s ease, border-color 0.2s ease, background 0.2s ease;
        }

        .chip input { display: none; }
        .chip.active {
            background: linear-gradient(135deg, rgba(186, 123, 83, 0.12), rgba(176, 106, 70, 0.08));
            border-color: rgba(176, 106, 70, 0.34);
            transform: translateY(-1px);
        }

        .controls {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            margin-top: 22px;
        }

        .panel-note {
            margin-top: 18px;
            padding: 16px 18px;
            border-radius: 22px;
            background: rgba(176, 106, 70, 0.08);
            color: var(--muted);
            line-height: 1.7;
        }

        .sticky-summary {
            position: sticky;
            top: 92px;
        }

        .summary-color {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .summary-swatch {
            width: 18px;
            height: 18px;
            border-radius: 50%;
            border: 1px solid rgba(0,0,0,.06);
        }

        .floating-back {
            position: fixed;
            right: 18px;
            bottom: 18px;
            z-index: 999;
            width: 58px;
            height: 58px;
            border-radius: 50%;
            border: none;
            color: white;
            background: linear-gradient(135deg, #ba7b53, #8f5435);
            box-shadow: 0 16px 30px rgba(143, 84, 53, 0.3);
            cursor: pointer;
        }

        @media (max-width: 1024px) {
            .hero-grid { grid-template-columns: 1fr; }
            .sticky-summary { position: static; }
        }

        @media (max-width: 768px) {
            .page-hero { padding-top: 24px; }
            .hero-card, .summary-card, .tips-card, .form-card { padding: 20px; border-radius: 24px; }
            .form-grid { grid-template-columns: 1fr; }
            .hero-stats { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<div class="page-shell">
    <%@ include file="partials/header.jsp" %>

    <section class="page-hero">
        <div class="container hero-grid">
            <div class="hero-card">
                <div class="eyebrow">✦ Custom Bouquet Studio</div>
                <h1 class="hero-title">Hãy tạo những bó hoa của riêng bạn</h1>
                <p class="hero-copy">
                    Tự tay phối nên một bó hoa thật riêng biệt cho người bạn thương. Chọn loại hoa, hoa chính,
                    hoa phụ, số lượng, giấy gói và phụ kiện đi kèm để Tiệm Hoa Nhà Tớ gợi ý bố cục tinh tế,
                    sang trọng và phù hợp phong cách quà tặng hiện đại.
                </p>

                <div class="hero-badges">
                    <span class="hero-badge">Thiết kế theo tone màu</span>
                    <span class="hero-badge">Gợi ý theo dịp tặng</span>
                    <span class="hero-badge">Tối ưu cho quà tặng & sự kiện</span>
                </div>

                <div class="hero-cta-row">
                    <a class="btn-primary" href="#custom-form">Bắt đầu custom ngay</a>
                    <a class="btn-secondary" href="${pageContext.request.contextPath}/san-pham?category=bo-hoa">Xem mẫu bó hoa sẵn</a>
                </div>

                <div class="hero-stats">
                    <div class="stat">
                        <strong>6 bước</strong>
                        <span>Chọn nhanh, dễ hiểu</span>
                    </div>
                    <div class="stat">
                        <strong>Style hiện đại</strong>
                        <span>Card, ánh sáng, spacing tinh tế</span>
                    </div>
                    <div class="stat">
                        <strong>Gợi ý thông minh</strong>
                        <span>Hỗ trợ same color / same occasion</span>
                    </div>
                </div>
            </div>

            <div class="right-stack sticky-summary">
                <div class="summary-card">
                    <h3>Tóm tắt bó hoa</h3>
                    <div class="summary-hero">
                        <div class="summary-circle">💐</div>
                        <div>
                            <div style="font-weight:800; font-size:1.1rem;">Bloom Signature</div>
                            <div style="color: var(--muted);">Mẫu phối mặc định để bạn bắt đầu</div>
                        </div>
                    </div>

                    <div class="summary-grid">
                        <div class="summary-item">
                            <span>Loại hoa</span>
                            <strong id="summary-flower-type">Hoa tươi mix</strong>
                        </div>
                        <div class="summary-item">
                            <span>Hoa chính</span>
                            <strong id="summary-main-flower">Hoa hồng kem</strong>
                        </div>
                        <div class="summary-item">
                            <span>Hoa phụ</span>
                            <strong id="summary-support-flower">Baby trắng</strong>
                        </div>
                        <div class="summary-item">
                            <span>Số lượng</span>
                            <strong id="summary-quantity">15 cành</strong>
                        </div>
                        <div class="summary-item">
                            <span>Giấy gói</span>
                            <strong id="summary-wrap">Kraft pastel</strong>
                        </div>
                        <div class="summary-item">
                            <span>Phụ kiện</span>
                            <strong id="summary-accessory">Nơ lụa + thiệp</strong>
                        </div>
                        <div class="summary-item">
                            <span>Màu chủ đạo</span>
                            <strong class="summary-color"><span class="summary-swatch" id="summary-color-swatch" style="background:#d8b1a0;"></span><span id="summary-color">Hồng kem</span></strong>
                        </div>
                    </div>
                </div>

                <div class="tips-card">
                    <h3>Gợi ý phong cách</h3>
                    <div class="summary-grid">
                        <div class="summary-item"><span>Wedding</span><strong>Thanh lịch, mềm mại</strong></div>
                        <div class="summary-item"><span>Birthday</span><strong>Rực rỡ, vui tươi</strong></div>
                        <div class="summary-item"><span>Valentine</span><strong>Lãng mạn, nổi bật</strong></div>
                        <div class="summary-item"><span>Luxury</span><strong>Tối giản, cao cấp</strong></div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="form-wrap" id="custom-form">
        <div class="container">
            <div class="form-card">
                <h2>Thiết kế bó hoa</h2>
                <p style="margin:0 0 20px; color: var(--muted); line-height:1.75;">
                    Chỉnh từng thành phần để tạo một bó hoa riêng, phù hợp ngân sách và dịp tặng của bạn.
                </p>

                <div class="form-grid">
                    <div class="field">
                        <label>Loại hoa</label>
                        <select id="flowerType">
                            <option>Hoa tươi mix</option>
                            <option>Hoa hồng</option>
                            <option>Tulip</option>
                            <option>Cẩm tú cầu</option>
                            <option>Mẫu đơn</option>
                            <option>Baby / hoa phụ</option>
                        </select>
                    </div>
                    <div class="field">
                        <label>Hoa chính</label>
                        <select id="mainFlower">
                            <option>Hoa hồng kem</option>
                            <option>Hoa hồng đỏ</option>
                            <option>Tulip pastel</option>
                            <option>Mẫu đơn</option>
                            <option>Cẩm tú cầu</option>
                            <option>Hướng dương</option>
                        </select>
                    </div>
                    <div class="field">
                        <label>Hoa phụ</label>
                        <select id="supportFlower">
                            <option>Baby trắng</option>
                            <option>Thanh liễu</option>
                            <option>Lá bạc</option>
                            <option>Lá măng</option>
                            <option>Cúc nhí</option>
                            <option>Không thêm</option>
                        </select>
                    </div>
                    <div class="field">
                        <label>Số lượng</label>
                        <select id="quantity">
                            <option>9 cành</option>
                            <option>15 cành</option>
                            <option>19 cành</option>
                            <option>25 cành</option>
                            <option>31 cành</option>
                            <option>51 cành</option>
                        </select>
                    </div>
                    <div class="field">
                        <label>Giấy gói</label>
                        <select id="wrap">
                            <option>Kraft pastel</option>
                            <option>Giấy Hàn Quốc</option>
                            <option>Giấy lụa cao cấp</option>
                            <option>Giấy bóng mờ</option>
                            <option>Giấy đen sang trọng</option>
                            <option>Giấy trắng tối giản</option>
                        </select>
                    </div>
                    <div class="field">
                        <label>Dịp tặng</label>
                        <select id="occasion">
                            <option>Birthday</option>
                            <option>Valentine</option>
                            <option>Wedding</option>
                            <option>Luxury</option>
                            <option>Minimal</option>
                            <option>Thank you</option>
                        </select>
                    </div>
                    <div class="field field-full">
                        <label>Màu chủ đạo</label>
                        <div class="chips" id="colorChips">
                            <label class="chip active"><input type="radio" name="color" value="#d8b1a0" checked />Hồng kem</label>
                            <label class="chip"><input type="radio" name="color" value="#d9c2a2" />Be sữa</label>
                            <label class="chip"><input type="radio" name="color" value="#c96f7c" />Hồng đậm</label>
                            <label class="chip"><input type="radio" name="color" value="#c8d9c0" />Xanh sage</label>
                            <label class="chip"><input type="radio" name="color" value="#d7a36a" />Cam pastel</label>
                            <label class="chip"><input type="radio" name="color" value="#4f3a33" />Tone trầm</label>
                        </div>
                    </div>
                    <div class="field field-full">
                        <label>Phụ kiện đi kèm</label>
                        <div class="chips" id="accessoryChips">
                            <label class="chip active"><input type="checkbox" value="Nơ lụa" checked />Nơ lụa</label>
                            <label class="chip active"><input type="checkbox" value="Thiệp" checked />Thiệp</label>
                            <label class="chip"><input type="checkbox" value="Ruy băng" />Ruy băng</label>
                            <label class="chip"><input type="checkbox" value="Túi đựng" />Túi đựng</label>
                            <label class="chip"><input type="checkbox" value="Tag tên" />Tag tên</label>
                        </div>
                    </div>
                    <div class="field field-full">
                        <label>Ghi chú / thông điệp</label>
                        <textarea id="note" placeholder="Ví dụ: Tặng sinh nhật bạn gái, thích tone hồng kem nhẹ nhàng và sang."></textarea>
                    </div>
                </div>

                <div class="controls">
                    <a class="btn-primary" href="${pageContext.request.contextPath}/san-pham?category=bo-hoa">Xem gợi ý sản phẩm</a>
                    <button class="btn-secondary" type="button" id="resetCustom">Khôi phục mặc định</button>
                    <button class="btn-secondary" type="button" id="copyCustom">Sao chép cấu hình</button>
                </div>

                <div class="panel-note">
                    Gợi ý: sau khi chọn xong, bạn có thể dùng cấu hình này để đặt hàng hoặc gửi cho shop để được tư vấn bó hoa phù hợp hơn với ngân sách và dịp tặng.
                </div>
            </div>
        </div>
    </section>
</div>

<button class="floating-back" type="button" onclick="window.scrollTo({top:0, behavior:'smooth'})">↑</button>

<script>
    const contextPath = '${pageContext.request.contextPath}';

    const summaryMap = {
        flowerType: document.getElementById('summary-flower-type'),
        mainFlower: document.getElementById('summary-main-flower'),
        supportFlower: document.getElementById('summary-support-flower'),
        quantity: document.getElementById('summary-quantity'),
        wrap: document.getElementById('summary-wrap'),
        accessory: document.getElementById('summary-accessory'),
        color: document.getElementById('summary-color'),
        swatch: document.getElementById('summary-color-swatch'),
    };

    const fields = {
        flowerType: document.getElementById('flowerType'),
        mainFlower: document.getElementById('mainFlower'),
        supportFlower: document.getElementById('supportFlower'),
        quantity: document.getElementById('quantity'),
        wrap: document.getElementById('wrap'),
        occasion: document.getElementById('occasion'),
        note: document.getElementById('note'),
    };

    function getSelectedAccessories() {
        return Array.from(document.querySelectorAll('#accessoryChips input[type="checkbox"]:checked'))
            .map((input) => input.value);
    }

    function updateChipState(groupSelector, inputType) {
        document.querySelectorAll(`${groupSelector} .chip`).forEach((chip) => {
            const input = chip.querySelector(`input[type="${inputType}"]`);
            if (!input) return;
            chip.classList.toggle('active', input.checked);
        });
    }

    function updateSummary() {
        summaryMap.flowerType.textContent = fields.flowerType.value;
        summaryMap.mainFlower.textContent = fields.mainFlower.value;
        summaryMap.supportFlower.textContent = fields.supportFlower.value;
        summaryMap.quantity.textContent = fields.quantity.value;
        summaryMap.wrap.textContent = fields.wrap.value;
        const accessories = getSelectedAccessories();
        summaryMap.accessory.textContent = accessories.length ? accessories.join(' + ') : 'Không thêm';
        const selectedColor = document.querySelector('#colorChips input[name="color"]:checked');
        if (selectedColor) {
            summaryMap.swatch.style.background = selectedColor.value;
            summaryMap.color.textContent = selectedColor.parentElement.textContent.trim();
        }
    }

    Object.values(fields).forEach((field) => {
        if (!field) return;
        field.addEventListener('change', updateSummary);
        field.addEventListener('input', updateSummary);
    });

    document.querySelectorAll('#colorChips input[name="color"]').forEach((input) => {
        input.addEventListener('change', () => {
            document.querySelectorAll('#colorChips .chip').forEach((chip) => {
                const radio = chip.querySelector('input[name="color"]');
                chip.classList.toggle('active', radio && radio.checked);
            });
            updateSummary();
        });
    });

    document.querySelectorAll('#accessoryChips input[type="checkbox"]').forEach((input) => {
        input.addEventListener('change', () => {
            updateChipState('#accessoryChips', 'checkbox');
            updateSummary();
        });
    });

    document.getElementById('resetCustom').addEventListener('click', () => {
        fields.flowerType.value = 'Hoa tươi mix';
        fields.mainFlower.value = 'Hoa hồng kem';
        fields.supportFlower.value = 'Baby trắng';
        fields.quantity.value = '15 cành';
        fields.wrap.value = 'Kraft pastel';
        fields.occasion.value = 'Birthday';
        fields.note.value = '';

        document.querySelectorAll('#colorChips input[name="color"]').forEach((input, index) => {
            input.checked = index === 0;
        });

        document.querySelectorAll('#accessoryChips input[type="checkbox"]').forEach((input) => {
            input.checked = input.value === 'Nơ lụa' || input.value === 'Thiệp';
        });

        updateChipState('#colorChips', 'radio');
        updateChipState('#accessoryChips', 'checkbox');
        updateSummary();
    });

    document.getElementById('copyCustom').addEventListener('click', async () => {
        const accessories = getSelectedAccessories().join(', ');
        const color = document.querySelector('#colorChips input[name="color"]:checked');
        const text = [
            `Loại hoa: ${fields.flowerType.value}`,
            `Hoa chính: ${fields.mainFlower.value}`,
            `Hoa phụ: ${fields.supportFlower.value}`,
            `Số lượng: ${fields.quantity.value}`,
            `Giấy gói: ${fields.wrap.value}`,
            `Dịp tặng: ${fields.occasion.value}`,
            `Màu chủ đạo: ${color ? color.parentElement.textContent.trim() : ''}`,
            `Phụ kiện: ${accessories || 'Không thêm'}`,
            `Ghi chú: ${fields.note.value || 'Không có'}`,
        ].join('\n');

        try {
            await navigator.clipboard.writeText(text);
            alert('Đã sao chép cấu hình bó hoa.');
        } catch (error) {
            alert('Không thể sao chép tự động, vui lòng thử lại.');
        }
    });

    updateChipState('#colorChips', 'radio');
    updateChipState('#accessoryChips', 'checkbox');
    updateSummary();
</script>
</body>
</html>
