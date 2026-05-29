package dao;

import model.CardTemplate;

import java.util.ArrayList;
import java.util.List;

public class CardTemplateDAO {

    public List<CardTemplate> getTemplatesByCategory(String category) {
        List<CardTemplate> list = new ArrayList<>();

        if(category == null) {
            return list;
        }

        switch (category.toLowerCase()) {
            case "sinh nhật":
                list.add(new CardTemplate(
                        1,
                        "Thiệp sinh nhật ngọt ngào",
                        "images/cards/birthday1.jpg",
                        "Sinh nhật",
                        "Chúc bạn tuổi mới nhiều niềm vui"
                ));

                list.add(new CardTemplate(
                        2,
                        "Thiệp chúc mừng đáng yêu",
                        "images/cards/birthday2.jpg",
                        "Sinh nhật",
                        "Happy Birthday"
                ));
                break;

            case "tình yêu":
                list.add(new CardTemplate(
                        3,
                        "Thiệp tình yêu",
                        "images/cards/love1.jpg",
                        "Tình yêu",
                        "Mãi yêu em"
                ));
                break;

            case "khai trương":
                list.add(new CardTemplate(
                        4,
                        "Thiệp khai trương",
                        "images/cards/opening1.jpg",
                        "Khai trương",
                        "Chúc phát tài phát lộc"
                ));
                break;
        }

        return list;
    }
}