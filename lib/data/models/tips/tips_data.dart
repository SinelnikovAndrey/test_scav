

class Root {
  List<Tip?>? tips;

  Root({this.tips});

  Root.fromJson(Map<String, dynamic> json) {
    if (json['tips'] != null) {
      tips = <Tip>[];
      json['tips'].forEach((v) {
        tips!.add(Tip.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['tips'] = tips != null ? tips!.map((v) => v?.toJson()).toList() : '';
    return data;
  }
}

class Tip {
  String? id;
  String? photo;
  String? header;
  String? firstPoint;
  String? secondPoint;
  String? thirdPoint;
  String? forthPoint;

  Tip({
    this.id,
    this.header,
    this.firstPoint,
    this.secondPoint,
    this.thirdPoint,
    this.forthPoint,
    this.photo,
  });

  Tip.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    header = json['header'];
    firstPoint = json['firstPoint'];
    secondPoint = json['secondPoint'];
    thirdPoint = json['thirdPoint'];
    forthPoint = json['forthPoint'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['header'] = header;
    data['firstPoint'] = firstPoint;
    data['secondPoint'] = secondPoint;
    data['thirdPoint'] = thirdPoint;
    data['forthPoint'] = forthPoint;
    data['photo'] = photo;
    return data;
  }
}
