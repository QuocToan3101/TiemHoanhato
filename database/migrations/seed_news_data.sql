-- ============================================================================
-- SEED: NEWS DATA - Tiệm Hoa nhà tớ
-- Categories: tips | birthday | opening | proposal | wedding | story | budget
-- Chạy sau khi đã chạy flowerstore-complete.sql
-- ============================================================================

USE flowerStore;

INSERT INTO news (
    title, slug, excerpt, content, image_url, category, author, views, is_published, published_date
) VALUES

-- ============================================================
-- CATEGORY: tips (Tips chọn hoa)
-- ============================================================
(
    'Gợi ý chọn bó hoa pastel cho ngày Giỗ Tổ Hùng Vương',
    'hoa-pastel-gio-to-hung-vuong',
    'Bó hoa pastel cho Giỗ Tổ nên ưu tiên Sen hồng, Cúc mẫu đơn hoặc Hồng kem. Phối màu nã nhặn (trắng - hồng phấn - xanh lơ) tạo vẻ đẹp thanh tao, thành kính.',
    '<h3>Ý nghĩa của hoa trong ngày Giỗ Tổ Hùng Vương</h3>
<p>Ngày 10/3 âm lịch hằng năm là dịp để toàn dân Việt Nam tưởng nhớ công ơn dựng nước của các Vua Hùng. Trong không khí trang nghiêm và thành kính đó, việc chọn một bó hoa phù hợp để dâng lên không chỉ thể hiện lòng tri ân mà còn giúp buổi lễ thêm phần trang trọng.</p>
<h3>Nên chọn loại hoa nào?</h3>
<p>Theo quan niệm truyền thống Việt Nam, những loài hoa thanh khiết, thuần khiết được ưu tiên trong các dịp tế lễ:</p>
<ul>
    <li><strong>Sen hồng</strong> – biểu tượng của sự thanh cao, tinh khiết trong văn hóa dân tộc.</li>
    <li><strong>Cúc trắng / Cúc vàng</strong> – tượng trưng cho sự trường thọ và lòng thành kính.</li>
    <li><strong>Hồng kem / Hồng trắng</strong> – màu sắc nhã nhặn, sang trọng mà không phô trương.</li>
    <li><strong>Cát tường trắng</strong> – mang ý nghĩa cầu chúc may mắn, bình an.</li>
</ul>
<h3>Bảng phối màu được gợi ý</h3>
<p>Hãy ưu tiên bảng màu <strong>trắng - hồng phấn - xanh lơ nhạt</strong>. Đây là tông màu thanh tao, không quá rực rỡ, phù hợp với không khí thiêng liêng của ngày lễ lớn.</p>
<h3>Cách bó và gói hoa</h3>
<p>Kiểu bó <strong>tròn đầy đặn</strong>, gói bằng giấy kraft nâu hoặc giấy trắng đục tạo vẻ đẹp giản dị mà trang trọng. Tránh sử dụng giấy bóng loáng hay nơ màu sặc sỡ – điều đó có thể làm giảm đi tính trang nghiêm.</p>
<p>Nếu muốn thêm phần ý nghĩa, bạn có thể kèm theo một thẻ nhỏ ghi dòng chữ: <em>"Uống nước nhớ nguồn"</em> hay <em>"Tri ân công đức Tổ tiên"</em>.</p>
<h3>Lời khuyên từ Tiệm</h3>
<p>Tiệm luôn có sẵn các mẫu bó hoa dành riêng cho những dịp lễ trọng đại. Hãy đặt trước ít nhất <strong>1–2 ngày</strong> để Tiệm chuẩn bị chu đáo nhất cho bạn nhé!</p>',
    'https://cdn.hstatic.net/files/200000846175/file/caf51f824f9dc2c39b8c.jpg',
    'tips',
    'Tiệm Hoa nhà tớ',
    528,
    1,
    '2026-03-17 08:00:00'
),

(
    '5 bí quyết giữ hoa tươi lâu mà ít ai biết',
    '5-bi-quyet-giu-hoa-tuoi-lau',
    'Đừng để bó hoa đẹp của bạn chỉ tồn tại vài ngày. Với những mẹo đơn giản này, hoa có thể tươi hơn bạn nghĩ rất nhiều.',
    '<h3>Tại sao hoa nhanh tàn?</h3>
<p>Rất nhiều bạn hỏi Tiệm: "Sao mua hoa về chỉ được 2–3 ngày là héo rồi?" Thực ra, tuổi thọ của hoa phụ thuộc rất nhiều vào cách chăm sóc sau khi mua về – không chỉ là chất lượng hoa ban đầu.</p>
<h3>Bí quyết 1: Cắt chéo cuống hoa trong nước</h3>
<p>Ngay khi mang hoa về, hãy <strong>ngâm cuống vào thau nước và cắt chéo 45°</strong>. Việc cắt dưới nước giúp ngăn bọt khí vào trong cuống, giúp hoa hút nước tốt hơn đáng kể.</p>
<h3>Bí quyết 2: Thêm một ít đường + giấm vào nước cắm hoa</h3>
<p>Pha <strong>1 thìa cà phê đường + vài giọt giấm trắng</strong> vào 500ml nước. Đường cung cấp dinh dưỡng, còn giấm giúp diệt khuẩn, ngăn nước trở nên đục.</p>
<h3>Bí quyết 3: Tránh xa điều hòa và ánh nắng trực tiếp</h3>
<p>Điều hòa làm khô không khí, còn ánh nắng trực tiếp khiến hoa mất nước nhanh. Hãy đặt hoa ở <strong>nơi thoáng mát, ánh sáng khuếch tán</strong>, cách xa lỗ thông gió.</p>
<h3>Bí quyết 4: Thay nước và rửa bình mỗi 2 ngày</h3>
<p>Vi khuẩn tích tụ trong nước là nguyên nhân hàng đầu khiến hoa nhanh tàn. Đừng quên <strong>rửa sạch bình hoa và thay nước hoàn toàn</strong> mỗi 2 ngày.</p>
<h3>Bí quyết 5: Bảo quản trong tủ lạnh qua đêm</h3>
<p>Nếu bạn muốn hoa tươi lâu hơn đặc biệt trong những ngày nóng, hãy thử <strong>đặt hoa vào ngăn mát tủ lạnh</strong> (không phải ngăn đá) qua đêm. Nhiệt độ thấp giúp làm chậm quá trình héo úa tự nhiên.</p>
<h3>Bonus: Loại bỏ lá phía dưới mực nước</h3>
<p>Lá ngâm trong nước sẽ thối và làm bẩn nước rất nhanh. Hãy <strong>tỉa sạch tất cả lá</strong> phía dưới đường mực nước ngay từ đầu.</p>',
    'https://images.unsplash.com/photo-1487070183336-b863922373d4?w=800',
    'tips',
    'Tiệm Hoa nhà tớ',
    1024,
    1,
    '2025-10-05 09:00:00'
),

(
    'Ý nghĩa màu sắc hoa – Chọn đúng tông để nói đúng điều muốn nói',
    'y-nghia-mau-sac-hoa',
    'Màu sắc của hoa không chỉ là thẩm mỹ – đó còn là ngôn ngữ riêng, giúp bạn truyền tải cảm xúc mà đôi khi lời nói không thể diễn đạt hết.',
    '<h3>Hoa cũng có ngôn ngữ riêng</h3>
<p>Từ thời Victoria, người ta đã dùng hoa để "nói chuyện" với nhau mà không cần một lời. Ngày nay, dù ý nghĩa không còn quá cứng nhắc, nhưng màu sắc hoa vẫn mang những thông điệp rất riêng biệt mà bạn nên biết trước khi chọn tặng ai đó.</p>
<h3>Đỏ – Tình yêu mãnh liệt</h3>
<p><strong>Hồng đỏ</strong> là biểu tượng kinh điển của tình yêu đam mê, lãng mạn. Thích hợp cho Valentine, ngày kỷ niệm, hoặc lần đầu tỏ tình. Tuy nhiên, nếu tặng cho đối tác trong buổi họp mặt gia đình lần đầu, hãy cân nhắc – đôi khi quá "nóng" cũng làm người nhận ngại ngùng.</p>
<h3>Hồng – Dịu dàng và chăm sóc</h3>
<p><strong>Hồng phấn</strong> là tông màu của sự dịu dàng, yêu thương nhẹ nhàng. Thích hợp khi tặng mẹ, bạn gái, hay người thân. <strong>Hồng đậm</strong> thể hiện sự biết ơn và ngưỡng mộ.</p>
<h3>Trắng – Thuần khiết và tôn trọng</h3>
<p><strong>Hoa trắng</strong> mang ý nghĩa thanh khiết, trong sáng. Phù hợp cho đám cưới, sinh nhật người lớn tuổi, hay các dịp lễ trang trọng. Ở một số văn hóa, trắng gắn với tang lễ – hãy lưu ý tùy theo hoàn cảnh.</p>
<h3>Vàng – Tình bạn và sự lạc quan</h3>
<p><strong>Hoa vàng</strong> (hướng dương, cúc vàng) truyền tải năng lượng tích cực, niềm vui và tình bạn. Rất phù hợp khi thăm người ốm, chúc mừng thành công, hay đơn giản là tặng để làm ai đó mỉm cười.</p>
<h3>Tím – Bí ẩn và cao quý</h3>
<p><strong>Tím lavender</strong> là biểu tượng của sự thanh lịch, sang trọng và đôi chút bí ẩn. Thích hợp cho những món quà muốn gây ấn tượng mạnh hoặc dành cho người có gu thẩm mỹ tinh tế.</p>
<h3>Cam – Nhiệt huyết và sáng tạo</h3>
<p><strong>Cam</strong> là màu của sự nhiệt tình, sáng tạo và cởi mở. Tặng cho người bạn yêu quý, đồng nghiệp vui tính, hoặc ai đó đang bắt đầu hành trình mới.</p>
<h3>Mẹo từ Tiệm</h3>
<p>Đừng bó buộc quá vào quy tắc! Điều quan trọng nhất là <strong>bạn muốn nói gì với người nhận</strong>. Kể câu chuyện đó với Tiệm – Tiệm sẽ giúp bạn tạo ra bó hoa truyền tải đúng cảm xúc nhất.</p>',
    'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800',
    'tips',
    'Tiệm Hoa nhà tớ',
    762,
    1,
    '2026-03-05 10:00:00'
),

(
    'Cách chọn hoa theo cung hoàng đạo – Bạn đã thử chưa?',
    'chon-hoa-theo-cung-hoang-dao',
    'Mỗi cung hoàng đạo có một loài hoa "ruột" riêng. Tặng đúng hoa, bạn không chỉ khiến người nhận bất ngờ mà còn chứng tỏ sự tinh tế của mình.',
    '<h3>Ý tưởng tặng hoa theo cung hoàng đạo</h3>
<p>Bạn đã bao giờ nghĩ tới việc chọn hoa dựa theo cung hoàng đạo của người nhận chưa? Đây là cách tặng quà vừa độc đáo, vừa thể hiện sự quan tâm và hiểu biết về người ấy.</p>
<h3>Bạch Dương (21/3 – 19/4) – Hồng đỏ rực</h3>
<p>Mạnh mẽ, đam mê và dẫn đầu – Bạch Dương xứng đáng với những đóa hồng đỏ mạnh mẽ nhất.</p>
<h3>Kim Ngưu (20/4 – 20/5) – Cẩm chướng hồng</h3>
<p>Kiên nhẫn, yêu cái đẹp và trung thành. Cẩm chướng hồng với hương thơm nhẹ nhàng chính là loài hoa của Kim Ngưu.</p>
<h3>Song Tử (21/5 – 20/6) – Hoa lan trắng</h3>
<p>Linh hoạt, thông minh và đa dạng – hoa lan thanh lịch phù hợp với tính cách phong phú của Song Tử.</p>
<h3>Cự Giải (21/6 – 22/7) – Sen hồng</h3>
<p>Cảm xúc sâu sắc, gia đình là ưu tiên hàng đầu. Sen hồng – loài hoa của sự thuần khiết và tình thân – chính là loài hoa của Cự Giải.</p>
<h3>Sư Tử (23/7 – 22/8) – Hướng dương</h3>
<p>Nổi bật, ấm áp, tỏa sáng như mặt trời – Hướng dương là loài hoa sinh ra cho Sư Tử.</p>
<h3>Xử Nữ (23/8 – 22/9) – Cúc tana trắng</h3>
<p>Tỉ mỉ, gọn gàng và yêu sự tinh tế. Cúc tana trắng tinh khôi, sắc sảo phù hợp với Xử Nữ.</p>
<h3>Thiên Bình (23/9 – 22/10) – Hồng hồng phấn</h3>
<p>Cân bằng, yêu cái đẹp và nghệ thuật – hồng pastel nhẹ nhàng là lựa chọn hoàn hảo.</p>
<h3>Thiên Yết (23/10 – 21/11) – Hoa baby tím</h3>
<p>Bí ẩn, sâu sắc và mạnh mẽ. Hoa baby tím huyền bí chính là hình ảnh thu nhỏ của Thiên Yết.</p>
<h3>Nhân Mã (22/11 – 21/12) – Hướng dương cam</h3>
<p>Phiêu lưu, lạc quan và tự do. Hướng dương cam rực rỡ phù hợp với tâm hồn tự do của Nhân Mã.</p>
<h3>Ma Kết (22/12 – 19/1) – Tulip đỏ</h3>
<p>Kiên định, tham vọng và lịch sự. Tulip đỏ sang trọng là loài hoa của Ma Kết.</p>
<h3>Bảo Bình (20/1 – 18/2) – Phong lan xanh</h3>
<p>Độc đáo, sáng tạo và không theo số đông – hoa lan xanh hiếm gặp chính là Bảo Bình.</p>
<h3>Song Ngư (19/2 – 20/3) – Lily trắng</h3>
<p>Mơ mộng, nhạy cảm và lãng mạn. Lily trắng thanh thoát là loài hoa của Song Ngư.</p>',
    'https://images.unsplash.com/photo-1490750967868-88aa4486c946?w=800',
    'tips',
    'Tiệm Hoa nhà tớ',
    891,
    1,
    '2025-10-27 09:30:00'
),

-- ============================================================
-- CATEGORY: birthday (Sinh nhật)
-- ============================================================
(
    'Bó hoa sinh nhật lý tưởng theo từng độ tuổi',
    'bo-hoa-sinh-nhat-theo-do-tuoi',
    'Tặng hoa sinh nhật không chỉ là tặng hoa – đó là tặng cả sự hiểu biết và quan tâm. Mỗi độ tuổi có một loại hoa "đúng gu" riêng.',
    '<h3>Tại sao cần chọn hoa phù hợp độ tuổi?</h3>
<p>Một bó hoa đẹp nhưng không phù hợp với người nhận có thể làm mất đi sự chân thành của món quà. Hãy để Tiệm giúp bạn chọn đúng – tặng đúng!</p>
<h3>Sinh nhật bé (3–12 tuổi)</h3>
<p>Trẻ em yêu màu sắc rực rỡ! Hãy chọn những bó hoa nhiều màu sắc: <strong>hướng dương vàng, đồng tiền cam, baby hồng</strong>. Kết hợp với gấu bông nhỏ hoặc bong bóng sẽ làm bé thích thú hơn nhiều.</p>
<h3>Sinh nhật thiếu niên (13–18 tuổi)</h3>
<p>Độ tuổi năng động, ưa sự mới lạ. Những bó hoa <strong>rainbow (nhiều tông màu)</strong>, hoa baby pastel, hoặc mix cúc tana – hướng dương sẽ rất "trend".</p>
<h3>Sinh nhật tuổi 20 – 30 (Bạn bè, người yêu)</h3>
<p>Đây là thế hệ yêu thích Instagram và aesthetic. <strong>Hoa pastel, hoa theo chủ đề màu</strong> (all-pink, all-white, dusty rose) sẽ "ăn ảnh" và làm người nhận cực thích. Đừng quên thêm thiệp handwritten!</p>
<h3>Sinh nhật tuổi 40 – 50 (Ba, mẹ, anh chị)</h3>
<p>Trang trọng và ấm cúng hơn. Những bó hoa <strong>lily trắng, hoa lan, hồng kem</strong> kết hợp với cẩm chướng tạo nên vẻ đẹp sang trọng, phù hợp để thể hiện lòng yêu thương và tôn trọng.</p>
<h3>Sinh nhật người cao tuổi (60 tuổi trở lên)</h3>
<p>Hãy ưu tiên những loài hoa <strong>bền lâu như lan hồ điệp, cúc đại đóa</strong>. Tông màu vàng, tím đậm, đỏ mang ý nghĩa trường thọ và phúc lành – người lớn tuổi rất ưa chuộng.</p>
<h3>Tip bonus từ Tiệm</h3>
<p>Nếu bạn không chắc chắn, hãy nhắn Tiệm số tuổi, giới tính và mối quan hệ với người nhận – Tiệm sẽ tư vấn ngay một mẫu phù hợp nhất!</p>',
    'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800',
    'birthday',
    'Tiệm Hoa nhà tớ',
    643,
    1,
    '2025-09-15 09:00:00'
),

(
    'Sinh nhật người yêu: Bó hoa hay hộp hoa – Chọn cái nào?',
    'sinh-nhat-nguoi-yeu-bo-hoa-hay-hop-hoa',
    'Mỗi kiểu đóng gói mang một câu chuyện khác nhau. Hãy cùng Tiệm phân tích để bạn chọn được "vũ khí bí mật" hoàn hảo nhất!',
    '<h3>Bó hoa truyền thống – Lãng mạn và kinh điển</h3>
<p>Bó hoa cầm tay vẫn là lựa chọn kinh điển nhất cho ngày sinh nhật người yêu. Khi người ấy nhận một bó hoa, khoảnh khắc đó có gì đó rất cinematic – như một cảnh phim lãng mạn. <strong>Phù hợp nhất</strong> khi bạn muốn tạo ấn tượng mạnh, đặc biệt trong buổi hẹn hò hoặc surprise.</p>
<h3>Hộp hoa – Sang trọng và tinh tế</h3>
<p>Hộp hoa (flower box) mang lại cảm giác như một hộp quà cao cấp. Nó <strong>bảo quản hoa tốt hơn</strong> khi vận chuyển, và cũng trông đẹp hơn khi chụp ảnh. Thích hợp khi gửi shipper hoặc tặng trong bữa tiệc có nhiều người.</p>
<h3>So sánh nhanh</h3>
<ul>
    <li><strong>Bó hoa:</strong> Lãng mạn hơn khi trao tay trực tiếp, phù hợp buổi hẹn hò</li>
    <li><strong>Hộp hoa:</strong> An toàn khi ship, photogenic, dễ để bàn trưng bày</li>
    <li><strong>Lọ hoa:</strong> Bền hơn, người nhận có thể cắm tại nhà, phù hợp tặng bạn gái thích decor</li>
</ul>
<h3>Tiệm gợi ý</h3>
<p>Nếu bạn sẽ gặp trực tiếp → <strong>Bó hoa</strong>. Nếu ship → <strong>Hộp hoa</strong>. Nếu người yêu thích sống ảo và decor phòng → <strong>Lọ hoa</strong>. Nếu vẫn chưa quyết được, nhắn Tiệm – Tiệm sẽ giúp bạn!</p>',
    'https://assets.flowerstore.ph/public/tenantVN/app/assets/images/variant/600_bXNu767VcApRx9uLCwLB4TUBT.webp',
    'birthday',
    'Tiệm Hoa nhà tớ',
    415,
    1,
    '2025-11-20 08:30:00'
),

-- ============================================================
-- CATEGORY: opening (Khai trương)
-- ============================================================
(
    'Chọn kệ hoa khai trương sao cho tinh tế mà vẫn sang trọng?',
    'chon-ke-hoa-khai-truong',
    'Không phải cứ thật to là sẽ đẹp – đôi khi một kệ hoa vừa phải, phối màu chuẩn và câu chúc được chăm chút lại gây ấn tượng hơn rất nhiều.',
    '<h3>Kệ hoa khai trương – Không chỉ là hoa</h3>
<p>Kệ hoa khai trương không chỉ là một món quà – đó là bộ mặt của buổi lễ. Một kệ hoa đẹp giúp gian hàng trở nên sang trọng, thu hút khách và tạo ấn tượng tốt cho chủ nhân từ ngày đầu tiên kinh doanh.</p>
<h3>Size kệ hoa phù hợp</h3>
<ul>
    <li><strong>Kệ nhỏ (60–80cm):</strong> Phù hợp căn hộ, quán café, spa nhỏ. Tiết kiệm không gian, vẫn đẹp.</li>
    <li><strong>Kệ vừa (100–120cm):</strong> Lựa chọn phổ biến nhất, phù hợp hầu hết loại hình kinh doanh.</li>
    <li><strong>Kệ lớn (150cm+):</strong> Dành cho khai trương showroom, nhà hàng, khách sạn – tạo điểm nhấn hoành tráng.</li>
</ul>
<h3>Màu sắc hoa khai trương</h3>
<p>Theo phong thủy và thẩm mỹ truyền thống:</p>
<ul>
    <li><strong>Đỏ + Vàng:</strong> May mắn, tài lộc – lựa chọn hàng đầu cho khai trương kinh doanh.</li>
    <li><strong>Trắng + Xanh lá:</strong> Hiện đại, tươi mới – phù hợp clinic, spa, thương hiệu minimalist.</li>
    <li><strong>Hồng + Trắng:</strong> Tinh tế, sang trọng – dành cho boutique, tiệm bánh, studio.</li>
    <li><strong>Cam + Vàng:</strong> Năng động, ấm áp – coffee shop, nhà hàng, studio.</li>
</ul>
<h3>Câu chúc trên kệ hoa</h3>
<p>Đây là phần nhiều người bỏ qua nhưng lại rất quan trọng. Hãy chuẩn bị sẵn câu chúc ý nghĩa, ngắn gọn:</p>
<ul>
    <li>"Chúc mừng khai trương – Vạn sự hanh thông"</li>
    <li>"Kính chúc quý đơn vị khai trương thịnh vượng"</li>
    <li>"Chúc mừng sự khởi đầu mới – Thành công vượt bậc!"</li>
</ul>
<h3>Đặt kệ hoa khai trương tại Tiệm</h3>
<p>Tiệm nhận thiết kế theo yêu cầu, có thể giao tận nơi và setup trước giờ khai trương. Đặt trước <strong>2–3 ngày</strong> để đảm bảo nguyên liệu đẹp nhất!</p>',
    'https://product.hstatic.net/200000846175/product/w6_57fe7e7ee65f4097aef741ba053a4609.jpg',
    'opening',
    'Tiệm Hoa nhà tớ',
    587,
    1,
    '2025-11-02 08:00:00'
),

(
    '10 mẫu kệ hoa khai trương đẹp nhất 2025 – 2026',
    '10-mau-ke-hoa-khai-truong-dep',
    'Tổng hợp 10 mẫu kệ hoa khai trương được đặt nhiều nhất tại Tiệm – từ phong cách hiện đại đến truyền thống, đảm bảo có mẫu hợp với mọi không gian.',
    '<h3>Top 10 mẫu kệ hoa khai trương 2025 – 2026</h3>
<p>Sau hơn 2 năm phục vụ hàng nghìn buổi khai trương, Tiệm đã tổng hợp được 10 mẫu kệ hoa được khách hàng yêu thích nhất. Mỗi mẫu đều có câu chuyện và phong cách riêng.</p>
<h3>1. Kệ hoa Phú Quý</h3>
<p>Đỏ – vàng – cam, hoa cúc đại đóa và hồng đỏ là chủ đạo. Mang ý nghĩa tài lộc dồi dào, phát tài phát lộc. Phù hợp mọi loại hình kinh doanh truyền thống.</p>
<h3>2. Kệ hoa Minimalist Trắng</h3>
<p>All-white với hoa lan, lily và hoa baby. Tinh tế, hiện đại, phù hợp cho spa, clinic thẩm mỹ, studio chụp ảnh.</p>
<h3>3. Kệ hoa Tropical</h3>
<p>Hướng dương – Bird of Paradise – lá chuối. Tươi mới, mạnh mẽ. Phù hợp café phong cách nhiệt đới, shop thời trang cá tính.</p>
<h3>4. Kệ hoa Hồng Pastel</h3>
<p>Hồng phấn – kem – trắng. Dịu dàng, lãng mạn. Được đặt nhiều nhất bởi các tiệm bánh, flower shop, studio cưới.</p>
<h3>5. Kệ hoa Đỏ Tươi</h3>
<p>Hồng đỏ 100%, thêm cẩm chướng đỏ. Truyền thống nhưng không bao giờ lỗi thời. Rất được ưa chuộng trong cộng đồng người Hoa và doanh nghiệp truyền thống.</p>
<h3>6. Kệ hoa Xanh Lá Hiện Đại</h3>
<p>Chủ yếu là lá, kết hợp hoa trắng điểm xuyết. Tiếp cận thiên nhiên, bền bỉ, phù hợp văn phòng, co-working space.</p>
<h3>7. Kệ hoa Vintage Lavender</h3>
<p>Tím – hồng đậm – trắng kem. Lãng mạn, cổ điển. Được đặt nhiều bởi boutique thời trang vintage, tiệm café phong cách Pháp.</p>
<h3>8. Kệ hoa Hướng Dương Rực Rỡ</h3>
<p>Hướng dương đơn giản nhưng rực rỡ. Năng lượng tốt, truyền cảm hứng. Phổ biến trong lĩnh vực giáo dục, startup.</p>
<h3>9. Kệ hoa Mix Bốn Mùa</h3>
<p>Phối nhiều loại hoa theo mùa, màu sắc đa dạng. Mỗi kệ là một tác phẩm nghệ thuật độc bản.</p>
<h3>10. Kệ hoa Custom theo Brand</h3>
<p>Tiệm thiết kế kệ hoa theo màu sắc brand của khách hàng – logo, tone màu, thông điệp. Đây là sản phẩm premium nhất của Tiệm.</p>',
    'https://assets.flowerstore.ph/public/tenantVN/app/assets/images/variant/600_sp68ye1DbggBfrnMvYM2oZKaC.webp',
    'opening',
    'Tiệm Hoa nhà tớ',
    334,
    1,
    '2025-12-01 09:00:00'
),

-- ============================================================
-- CATEGORY: proposal (Cầu hôn)
-- ============================================================
(
    'Bó hoa cầu hôn hoàn hảo: Chọn sao cho đúng ý?',
    'bo-hoa-cau-hon-hoan-hao',
    'Một khoảnh khắc trọng đại cần một bó hoa đặc biệt. Hãy để Tiệm giúp bạn tìm được "chìa khóa" cho trái tim người ấy.',
    '<h3>Cầu hôn – Khoảnh khắc không thể quên</h3>
<p>Lời cầu hôn chỉ xảy ra một lần trong đời. Và trong khoảnh khắc thiêng liêng đó, bó hoa bạn cầm trên tay không chỉ là hoa – đó là cả tấm lòng, là câu chuyện tình yêu bạn muốn kể lại mãi mãi.</p>
<h3>Hoa hồng đỏ – Lựa chọn kinh điển</h3>
<p><strong>99 bông hồng đỏ</strong> là con số may mắn và truyền thống. Nhưng đừng quá cứng nhắc – hãy hỏi cô ấy thích màu gì, loại hoa gì. Đôi khi một bó tulip hồng hay hoa baby pastel lại "đánh trúng tim" hơn.</p>
<h3>Chọn màu theo tính cách của cô ấy</h3>
<ul>
    <li><strong>Cô ấy mạnh mẽ, cá tính:</strong> Hồng đỏ rực, cúc họa mi trắng</li>
    <li><strong>Cô ấy dịu dàng, nữ tính:</strong> Hồng phấn, tulip hồng, baby trắng</li>
    <li><strong>Cô ấy hiện đại, minimalist:</strong> Hoa lily trắng, hoa lan</li>
    <li><strong>Cô ấy vintage, lãng mạn:</strong> Hoa hồng kem, cẩm tú cầu tím</li>
    <li><strong>Cô ấy yêu thiên nhiên:</strong> Hướng dương, hoa dại mix lá xanh</li>
</ul>
<h3>Số lượng hoa có ý nghĩa gì?</h3>
<ul>
    <li>1 bông = "Anh chỉ yêu mình em"</li>
    <li>12 bông = "Yêu em mỗi tháng trong năm"</li>
    <li>99 bông = "Yêu em mãi mãi"</li>
    <li>101 bông = "Anh yêu em hơn tất cả"</li>
    <li>365 bông = "Yêu em mỗi ngày trong năm"</li>
</ul>
<h3>Gợi ý combo cầu hôn từ Tiệm</h3>
<p>Tiệm có thể tạo bó hoa cầu hôn theo yêu cầu, kết hợp thêm: hộp nhẫn ẩn trong hoa, petal rải dưới chân, hoặc thiệp handwritten với lời nhắn riêng. Hãy nhắn Tiệm trước <strong>3–5 ngày</strong> để được chuẩn bị tốt nhất!</p>',
    'https://images.unsplash.com/photo-1490750967868-88aa4486c946?w=800',
    'proposal',
    'Tiệm Hoa nhà tớ',
    1245,
    1,
    '2025-10-12 10:00:00'
),

(
    'Kế hoạch cầu hôn bằng hoa – Từng bước một',
    'ke-hoach-cau-hon-bang-hoa',
    'Bạn muốn tạo ra một buổi cầu hôn bằng hoa thật đặc biệt nhưng chưa biết bắt đầu từ đâu? Tiệm đã lên kế hoạch chi tiết cho bạn rồi!',
    '<h3>Bước 1: Chọn địa điểm</h3>
<p>Địa điểm quyết định phong cách trang trí hoa. Một số gợi ý phổ biến:</p>
<ul>
    <li><strong>Tại nhà:</strong> Rải cánh hoa hồng dẫn từ cửa vào phòng, đặt nến và hoa trang trí góc phòng.</li>
    <li><strong>Nhà hàng:</strong> Đặt hoa trước trên bàn, yêu cầu nhà hàng hỗ trợ khoảnh khắc đặc biệt.</li>
    <li><strong>Ngoài trời:</strong> Công viên, bãi biển – cần hoa bền hơn (lily, hướng dương).</li>
    <li><strong>Sân thượng / rooftop:</strong> Trang trí đèn fairy lights + hoa tươi = cực romantic.</li>
</ul>
<h3>Bước 2: Chọn hoa và palette màu</h3>
<p>Hỏi người ấy thích màu gì – một cách tự nhiên, không để lộ kế hoạch. Sau đó nhắn Tiệm để thiết kế bó hoa phù hợp.</p>
<h3>Bước 3: Chuẩn bị kịch bản</h3>
<p>Đừng chỉ nghĩ đến hoa – hãy nghĩ đến toàn bộ "màn trình diễn": Bạn sẽ nói gì? Bạn sẽ quỳ gối không? Có ai giúp bạn quay video không?</p>
<h3>Bước 4: Đặt hoa trước ít nhất 3 ngày</h3>
<p>Tiệm cần thời gian để chuẩn bị hoa tươi nhất, đóng gói đẹp nhất. Đặt muộn có thể không đảm bảo chất lượng hoa.</p>
<h3>Bước 5: Ngày N – Kiểm tra hoa và chuẩn bị tâm lý</h3>
<p>Hoa sẽ được giao đúng giờ. Bạn chỉ cần: hít thở, tự tin, và nói từ trái tim. Chúc bạn thành công!</p>',
    'https://assets.flowerstore.ph/public/tenantVN/app/assets/images/variant/600_CKhC13Q1AiaYHG2LAe3IH8nDM.webp',
    'proposal',
    'Tiệm Hoa nhà tớ',
    678,
    1,
    '2025-12-15 10:00:00'
),

-- ============================================================
-- CATEGORY: wedding (Đám cưới)
-- ============================================================
(
    '5 xu hướng hoa cưới hot nhất năm 2026',
    '5-xu-huong-hoa-cuoi-2026',
    'Xu hướng hoa cưới 2026 đang chuyển dịch mạnh sang phong cách tự nhiên, bền vững và cá nhân hóa. Cùng Tiệm khám phá top 5 trend hot nhất!',
    '<h3>Xu hướng 1: Hoa theo mùa địa phương (Locally Sourced)</h3>
<p>Năm 2026, các cặp đôi ngày càng ưa chuộng hoa được trồng ngay trong nước – vừa tươi hơn, vừa thể hiện trách nhiệm với môi trường. Hoa Sen, cúc mẫu đơn, hướng dương nội địa đang trở thành lựa chọn phổ biến.</p>
<h3>Xu hướng 2: Wildflower – Hoa dại tự nhiên</h3>
<p>Bó cưới phong cách "vừa hái từ đồng cỏ" với hoa dại, cỏ xanh, hoa nhỏ li ti đang được rất nhiều cô dâu modern lựa chọn. Nó mang lại cảm giác tự do, chân thực và thơ mộng.</p>
<h3>Xu hướng 3: Monochromatic – Đơn sắc nhưng đa tầng</h3>
<p>Tất cả một màu nhưng với nhiều sắc độ khác nhau. Ví dụ: all-white với ivory, kem, trắng tinh. Hay all-pink với blush, dusty rose, hot pink. Hiệu ứng visual cực kỳ mạnh mẽ và sang trọng.</p>
<h3>Xu hướng 4: Hoa khô (Dried Flowers) kết hợp hoa tươi</h3>
<p>Pampas grass, hoa bất tử khô, lá eucalyptus khô kết hợp với hoa tươi tạo nên vẻ đẹp bohemian vintage đang rất được yêu thích trong năm 2026.</p>
<h3>Xu hướng 5: Hoa cưới theo concept màu outfit</h3>
<p>Cô dâu ngày nay chọn hoa cưới phối với màu áo dâu – không nhất thiết phải là áo trắng. Áo xanh sage → hoa trắng + xanh. Áo champagne → hoa kem + vàng nhạt. Sự phối hợp này tạo nên bộ ảnh cưới đẹp đồng bộ.</p>',
    'https://assets.flowerstore.ph/public/tenantVN/app/assets/images/variant/600_SSoLNVacaA2GL1LWtH2xzAT8D.webp',
    'wedding',
    'Tiệm Hoa nhà tớ',
    923,
    1,
    '2026-01-10 09:00:00'
),

(
    'Checklist hoa cưới đầy đủ: Từ bó cầm tay đến trang trí sảnh',
    'checklist-hoa-cuoi-day-du',
    'Chuẩn bị hoa cho đám cưới không chỉ là bó cầm tay của cô dâu. Hãy cùng Tiệm lên checklist hoàn chỉnh để không sót item nào!',
    '<h3>Tại sao cần lên kế hoạch hoa cưới sớm?</h3>
<p>Hoa cưới thường chiếm 10–15% tổng ngân sách đám cưới. Việc lên kế hoạch sớm giúp bạn:</p>
<ul>
    <li>Đặt hoa hiếm trước khi hết mùa</li>
    <li>Thương lượng giá tốt hơn</li>
    <li>Có thời gian thử nhiều mẫu khác nhau</li>
    <li>Tránh rush fee (phí làm gấp)</li>
</ul>
<h3>Checklist hoa cưới cho cô dâu & chú rể</h3>
<ul>
    <li>☑ Bó hoa cầm tay cô dâu (bridal bouquet)</li>
    <li>☑ Hoa cài áo chú rể (boutonnière)</li>
    <li>☑ Hoa đội đầu / vương miện hoa (nếu có)</li>
    <li>☑ Hoa trang trí váy cưới (nếu cần)</li>
</ul>
<h3>Checklist hoa cưới cho đoàn phù dâu phù rể</h3>
<ul>
    <li>☑ Bó hoa mini cho phù dâu (matching hoặc complementary với bó cô dâu)</li>
    <li>☑ Hoa cài áo cho phù rể</li>
    <li>☑ Vòng hoa tay (wrist corsage) cho mẹ hai bên</li>
</ul>
<h3>Checklist hoa trang trí không gian</h3>
<ul>
    <li>☑ Hoa bàn tiệc (centerpiece) – mỗi bàn một mẫu hoặc đồng nhất</li>
    <li>☑ Hoa trang trí cổng cưới / backdrop chụp ảnh</li>
    <li>☑ Hoa lối đi / rải cánh hoa</li>
    <li>☑ Hoa trang trí bàn ký tên</li>
    <li>☑ Hoa trang trí xe cô dâu</li>
    <li>☑ Hoa trang trí cầu thang / cột / hành lang</li>
</ul>
<h3>Timeline đặt hoa</h3>
<ul>
    <li><strong>6 tháng trước:</strong> Tham khảo phong cách, gặp florist để trao đổi concept</li>
    <li><strong>3 tháng trước:</strong> Chốt design và đặt cọc</li>
    <li><strong>2 tuần trước:</strong> Xác nhận lại số lượng và thay đổi (nếu có)</li>
    <li><strong>1 ngày trước:</strong> Hoa được giao hoặc setup tại venue</li>
</ul>',
    'https://assets.flowerstore.ph/public/tenantVN/app/assets/images/variant/600_FG3iwtog9ZjAd14Dl4ksfDcGc.webp',
    'wedding',
    'Tiệm Hoa nhà tớ',
    456,
    1,
    '2025-12-20 09:00:00'
),

-- ============================================================
-- CATEGORY: story (Story từ Tiệm)
-- ============================================================
(
    'Một ngày chuẩn bị 20 đơn "tỏ tình" cùng nhà tớ',
    'mot-ngay-chuan-bi-20-don-to-tinh',
    'Có những ngày Tiệm nhận rất nhiều đơn "bí mật" – người gửi giấu tên, chỉ nhắn một câu: "Nhờ Tiệm giúp em nói phần còn lại nhé…".',
    '<h3>Ngày Valentine... nhưng không phải 14/2</h3>
<p>Người ta thường nghĩ tình yêu chỉ nở rộ vào ngày 14/2. Nhưng làm ở Tiệm lâu, tụi mình nhận ra: tình yêu không có lịch. Có những ngày thứ Ba bình thường, Tiệm nhận đến 20 đơn hoa "tỏ tình" chỉ trong buổi sáng.</p>
<h3>Đơn đặc biệt nhất hôm đó</h3>
<p>Một anh chàng nhắn lúc 7 giờ sáng: <em>"Chị ơi, em cần bó hoa đẹp nhất, có thể giao trước 12 giờ không? Em không biết cô ấy thích gì, chỉ biết cô ấy rất thích màu xanh và cô ấy... thích ăn phở."</em></p>
<p>Tiệm phải mất một lúc để không cười. Rồi nhẹ nhàng hỏi thêm: Cô ấy là người sống tối giản hay ưa cầu kỳ? Cô ấy hay đăng ảnh hoa không? Cô ấy bao nhiêu tuổi?</p>
<p>Và từ những câu hỏi tưởng không liên quan đó, Tiệm đã tạo ra một bó hoa baby xanh pastel mix tulip trắng – giản dị, sạch sẽ, tinh tế. Anh ấy nhắn lại lúc 1 giờ chiều: <em>"Cô ấy khóc rồi. Cảm ơn chị nhiều lắm."</em></p>
<h3>Bí mật của Tiệm</h3>
<p>Chúng tớ không chỉ bán hoa. Chúng tớ bán <strong>khoảnh khắc</strong>. Mỗi bó hoa rời Tiệm là một câu chuyện – có người hồi hộp cầm trên tay, có người run run đứng chờ trước cửa nhà người ấy, có người đặt trước bàn và chờ cô ấy đến ngồi xuống...</p>
<p>Và Tiệm – dù không có mặt ở đó – cũng cảm nhận được phần nào niềm vui ấy.</p>
<h3>Nếu bạn cũng đang "cần Tiệm giúp nói phần còn lại"</h3>
<p>Nhắn Tiệm nhé. Tụi mình lắng nghe, hỏi thêm chút, rồi tạo ra một bó hoa đúng với câu chuyện của bạn. Vì hoa không nói chuyện bằng tên – hoa nói chuyện bằng cảm xúc.</p>',
    'https://cdn.hstatic.net/files/200000846175/file/z5318389113228_bf05d1d394f756ddf038d8894726eb4c_cf4c6b6a880841b6b51d904a62b0035c.jpg',
    'story',
    'Tiệm Hoa nhà tớ',
    1876,
    1,
    '2025-10-25 09:00:00'
),

(
    'Bí mật của những bó hoa "triệu view"',
    'bi-mat-bo-hoa-trieu-view',
    'Mỗi tuần có hàng chục bó hoa từ Tiệm lên mạng xã hội và "viral" một cách tự nhiên. Bí mật là gì? Tiệm sẽ kể thật!',
    '<h3>Hoa đẹp chưa đủ</h3>
<p>Tụi mình từng nghĩ: hoa đẹp thì tự nhiên sẽ được chia sẻ. Nhưng sau hơn 2 năm, Tiệm nhận ra: điều khiến một bó hoa "viral" không phải chỉ là hoa đẹp – mà là <strong>cảm xúc đi kèm với nó</strong>.</p>
<h3>Bó hoa của chị Lan</h3>
<p>Chị đặt bó hoa tặng mẹ nhân dịp mẹ xuất viện sau ca phẫu thuật. Chị nhờ Tiệm viết thiệp: <em>"Mẹ ơi, con chờ mẹ về nhà."</em> Bó hoa hướng dương vàng rực, đơn giản. Chị đăng ảnh lên Facebook. Hai ngày sau, bài viết có 50,000 lượt chia sẻ.</p>
<p>Tiệm không bao giờ quên điều đó.</p>
<h3>Công thức của những bó hoa "triệu view"</h3>
<ul>
    <li><strong>Câu chuyện thật:</strong> Không ai chia sẻ vì hoa đẹp – người ta chia sẻ vì câu chuyện chạm vào tim.</li>
    <li><strong>Ánh sáng tự nhiên:</strong> Chụp gần cửa sổ, ánh sáng mềm vào buổi sáng – ảnh hoa đẹp nhất.</li>
    <li><strong>Khoảnh khắc thật:</strong> Ảnh người cầm hoa, ảnh hoa để trên bàn sáng, ảnh con bé ôm hoa cười... đều thu hút hơn ảnh product thuần túy.</li>
    <li><strong>Caption có linh hồn:</strong> Đừng chỉ viết "Tặng hoa cho bạn". Kể câu chuyện đằng sau.</li>
</ul>
<h3>Tiệm và những khoảnh khắc ấy</h3>
<p>Chúng tớ không cần hoa mình "viral". Điều Tiệm muốn là mỗi bó hoa đến đúng tay người cần nó, đúng lúc người cần nhất. Còn viral – chỉ là thêm.</p>',
    'https://assets.flowerstore.ph/public/tenantVN/app/assets/images/variant/600_bBBFucpYIQS5SINkFD5HDyejy.webp',
    'story',
    'Tiệm Hoa nhà tớ',
    2134,
    1,
    '2025-10-20 10:00:00'
),

(
    'Hoa pastel cho mùa cuối năm – Góc nhìn từ Tiệm',
    'hoa-pastel-mua-cuoi-nam',
    'Cuối năm là mùa của những cuộc hội ngộ, chia tay và cả những lời chưa kịp nói. Tiệm muốn kể về mùa hoa pastel và những câu chuyện đặc biệt nhất.',
    '<h3>Tháng 11 – Mùa hoa pastel về</h3>
<p>Cứ mỗi năm, khi những cơn gió đầu mùa đông thổi nhẹ qua Sài Gòn, Tiệm lại thấy mình bận hơn. Không phải vì Tết hay Valentine – mà vì <strong>mùa cuối năm</strong> là lúc người ta nhớ nhau nhiều hơn.</p>
<h3>Hoa pastel – Màu của khoảng lặng</h3>
<p>Pastel không rực rỡ. Pastel không ồn ào. Pastel giống như khoảnh khắc bạn ngồi một mình, nhâm nhi ly cà phê, nhìn ra cửa sổ và bỗng nhiên nhớ ai đó rất nhiều.</p>
<p>Trong tháng 11 năm ngoái, bó hoa được đặt nhiều nhất tại Tiệm là: <strong>hoa baby trắng kem mix hồng phấn, gói giấy kraft, không thiệp, chỉ nhờ Tiệm ghi: "Bạn ổn không?"</strong></p>
<h3>Bó hoa của cô gái tên Linh</h3>
<p>Cô ấy đặt hoa tặng cho chính mình. Tiệm hỏi tại sao. Cô ấy bảo: <em>"Năm nay em tự vượt qua nhiều thứ lắm. Em muốn tự thưởng cho bản thân."</em></p>
<p>Tiệm làm bó hoa đẹp nhất có thể. Và thêm một tấm thiệp nhỏ, không theo yêu cầu: <em>"Tiệm tự hào về bạn."</em></p>
<h3>Mùa cuối năm – Tiệm luôn ở đây</h3>
<p>Dù bạn tặng hoa cho ai, hay chỉ muốn mua hoa cho chính mình – Tiệm luôn ở đây. Hãy nhắn Tiệm câu chuyện của bạn. Tụi mình sẽ tạo ra bó hoa xứng đáng với nó.</p>',
    'https://cdn.hstatic.net/files/200000846175/file/caf51f824f9dc2c39b8c.jpg',
    'story',
    'Tiệm Hoa nhà tớ',
    1542,
    1,
    '2025-11-09 08:00:00'
),

-- ============================================================
-- CATEGORY: budget (Ngân sách)
-- ============================================================
(
    'Tặng hoa với ngân sách vừa phải nhưng vẫn thật chỉn chu',
    'tang-hoa-ngan-sach-vua-phai',
    'Bạn không cần chi quá nhiều để có một bó hoa xinh. Ưu tiên hoa nội địa, phối khéo và chọn gói đúng cách – bó hoa của bạn sẽ vẫn rất ấn tượng.',
    '<h3>Ngân sách vừa phải – Vẫn có thể tặng hoa đẹp!</h3>
<p>Rất nhiều bạn ngại tặng hoa vì nghĩ phải chi nhiều mới đẹp. Thực ra, bí quyết nằm ở việc <strong>chọn đúng loại hoa, phối đúng màu, và gói đúng cách</strong> – không nhất thiết phải đắt tiền.</p>
<h3>Chọn hoa nội địa giá tốt</h3>
<ul>
    <li><strong>Cúc mẫu đơn:</strong> Đẹp, bền, giá rất phải chăng. Có nhiều màu từ vàng, cam, đỏ, tím, trắng.</li>
    <li><strong>Cát tường:</strong> Thanh tao, nhẹ nhàng. Giá thấp nhưng visual rất đẹp.</li>
    <li><strong>Hoa đồng tiền:</strong> Bền lâu, nhiều màu. Phù hợp mix với nhiều loại hoa khác.</li>
    <li><strong>Hoa baby:</strong> Giá thấp nhưng tạo độ đầy và bông cho bó hoa cực tốt.</li>
</ul>
<h3>Phối hoa khéo = Bó hoa đẹp hơn hẳn</h3>
<p>Thay vì mua 1 loại hoa đắt tiền, hãy thử mix 2–3 loại hoa giá bình dân lại với nhau:</p>
<ul>
    <li>Cát tường trắng + Hoa baby xanh + Lá fern = Cực tinh tế</li>
    <li>Cúc mẫu đơn hồng + Đồng tiền cam + Baby trắng = Tươi vui, đầy đặn</li>
    <li>Hướng dương + Đồng tiền vàng + Cỏ xanh = Năng động, nhiều năng lượng</li>
</ul>
<h3>Gói đẹp cũng nâng tầm bó hoa</h3>
<p>Giấy gói đóng góp 30% vào vẻ đẹp tổng thể. Hãy thử:</p>
<ul>
    <li>Giấy kraft nâu: Vintage, tối giản – rất Instagram</li>
    <li>Giấy trắng đục: Tinh tế, sạch sẽ, phù hợp mọi dịp</li>
    <li>Giấy nhám pastel: Nữ tính, đáng yêu</li>
</ul>
<h3>Tránh "bẫy" khi mua hoa giá rẻ</h3>
<ul>
    <li>Tránh mua hoa đã nở hết – sẽ héo sau 1–2 ngày</li>
    <li>Hỏi kỹ hoa được nhập từ đâu, ngày nào</li>
    <li>Ưu tiên mua ở cửa hàng uy tín dù giá có nhỉnh hơn chút – hoa tươi hơn, bền hơn nhiều</li>
</ul>',
    'https://file.hstatic.net/200000846175/article/6_d6bdb32719444cc5ad4a6193f4c065f1_master.png',
    'budget',
    'Tiệm Hoa nhà tớ',
    734,
    1,
    '2025-10-18 09:00:00'
),

(
    '5 mẫu bó hoa "an toàn" nhưng không nhàm chán',
    '5-mau-bo-hoa-an-toan',
    'Không biết chọn gì? Đây là 5 mẫu bó hoa Tiệm đã kiểm nghiệm qua hàng nghìn đơn hàng – ai nhận cũng thích, dịp nào tặng cũng ổn.',
    '<h3>Mẫu 1: Bó baby + hồng phấn</h3>
<p>Kết hợp hoa baby trắng mịn với hồng phấn nhỏ. Nhẹ nhàng, nữ tính, không bao giờ sai. Phù hợp sinh nhật, cảm ơn, thăm hỏi. Giá tầm trung, visual rất đẹp.</p>
<h3>Mẫu 2: Hướng dương mix cúc tana</h3>
<p>Hướng dương vàng rực kết hợp cúc tana trắng nhỏ. Tươi vui, năng lượng cao. Phù hợp chúc mừng tốt nghiệp, khai trương nhỏ, tặng bạn bè. Rất được khen vì "dễ chịu".</p>
<h3>Mẫu 3: Cát tường trắng tinh</h3>
<p>All-white cát tường kết hợp lá bạc. Tinh tế, tối giản, phù hợp người gu hiện đại. Không bao giờ lỗi thời và cực kỳ photogenic.</p>
<h3>Mẫu 4: Đồng tiền cam mix baby</h3>
<p>Đồng tiền cam rực rỡ phối cùng hoa baby trắng và lá fern. Ấm áp, vui tươi. Phù hợp thăm người ốm (vì cam = năng lượng tích cực), chúc mừng thăng chức.</p>
<h3>Mẫu 5: Pastel mix (hồng + tím nhạt + trắng)</h3>
<p>Bó hoa mix nhiều tông pastel – mơ mộng như một bức tranh. Được đặt nhiều nhất vào mùa lễ hội. Thích hợp cho sinh nhật bạn gái, tặng mẹ, tặng chị em.</p>
<h3>Gợi ý từ Tiệm</h3>
<p>Nếu bạn thực sự không biết chọn gì, cứ nhắn Tiệm: "Nhờ Tiệm chọn giúp mình" – Tiệm sẽ hỏi thêm một vài thông tin nhỏ rồi tạo ra bó hoa phù hợp nhất. Không charge thêm phí tư vấn đâu nhé!</p>',
    'https://assets.flowerstore.ph/public/tenantVN/app/assets/images/variant/600_OkPm914OAMEvHX1aWNFBP3Fio.jpg',
    'budget',
    'Tiệm Hoa nhà tớ',
    567,
    1,
    '2025-11-03 08:30:00'
);

-- ============================================================
-- Kiểm tra kết quả
-- ============================================================
SELECT
    id,
    title,
    slug,
    category,
    author,
    views,
    is_published,
    DATE_FORMAT(published_date, '%d/%m/%Y') AS published
FROM news
ORDER BY published_date DESC;
