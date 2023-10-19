// app.bsky.richtext.facet
const String facet = "app.bsky.richtext.facet";
const String mention = "$facet#mention";
const String link = "$facet#link";

class Facet {
  final String? type;
  final ByteSlice index;
  final List<Feature> features;

  Facet(this.type, this.index, this.features);

  static List<Facet> list(List facetsMap) {
    List<Facet> facets = [];
    for (Map map in facetsMap) {
      String? type = map["\$type"];
      Facet facet =
          Facet(type, ByteSlice(map["index"]), featureList(map["features"]));
      facets.add(facet);
    }
    return facets;
  }

  static List<Feature> featureList(List mapList) {
    List<Feature> features = [];
    for (Map map in mapList) {
      features.add(Feature.get(map));
    }
    return features;
  }
}

class ByteSlice {
  int byteEnd;
  int byteStart;
  ByteSlice(Map map)
      : byteEnd = map["byteEnd"],
        byteStart = map["byteStart"];
}

abstract class Feature {
  final String type;
  Feature(this.type);

  static Feature get(Map map) {
    String type = map["\$type"];
    if (type == mention) {
      return Mention(type, map["did"]);
    } else {
      return Link(type, map["uri"]);
    }
  }
}

class Mention extends Feature {
  final String did;
  Mention(super.type, this.did);
}

class Link extends Feature {
  final String uri;
  Link(super.type, this.uri);
}
