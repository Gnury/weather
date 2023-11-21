import 'dart:convert';

class Cities {
  final String name;
  final LocalNames localNames;
  final double lat;
  final double lon;
  final String country;
  final String state;

  Cities({
    required this.name,
    required this.localNames,
    required this.lat,
    required this.lon,
    required this.country,
    required this.state,
  });

  factory Cities.fromRawJson(String str) => Cities.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Cities.fromJson(Map<String, dynamic> json) => Cities(
    name: json["name"],
    localNames: LocalNames.fromJson(json["local_names"]),
    lat: json["lat"]?.toDouble(),
    lon: json["lon"]?.toDouble(),
    country: json["country"],
    state: json["state"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "local_names": localNames.toJson(),
    "lat": lat,
    "lon": lon,
    "country": country,
    "state": state,
  };
}

class LocalNames {
  final String ru;
  final String de;
  final String ko;
  final String sr;
  final String kn;
  final String et;
  final String uk;
  final String th;
  final String zh;
  final String fr;
  final String vi;
  final String ja;
  final String hi;
  final String en;

  LocalNames({
    required this.ru,
    required this.de,
    required this.ko,
    required this.sr,
    required this.kn,
    required this.et,
    required this.uk,
    required this.th,
    required this.zh,
    required this.fr,
    required this.vi,
    required this.ja,
    required this.hi,
    required this.en,
  });

  factory LocalNames.fromRawJson(String str) => LocalNames.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LocalNames.fromJson(Map<String, dynamic> json) => LocalNames(
    ru: json["ru"],
    de: json["de"],
    ko: json["ko"],
    sr: json["sr"],
    kn: json["kn"],
    et: json["et"],
    uk: json["uk"],
    th: json["th"],
    zh: json["zh"],
    fr: json["fr"],
    vi: json["vi"],
    ja: json["ja"],
    hi: json["hi"],
    en: json["en"],
  );

  Map<String, dynamic> toJson() => {
    "ru": ru,
    "de": de,
    "ko": ko,
    "sr": sr,
    "kn": kn,
    "et": et,
    "uk": uk,
    "th": th,
    "zh": zh,
    "fr": fr,
    "vi": vi,
    "ja": ja,
    "hi": hi,
    "en": en,
  };
}
