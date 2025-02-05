class ProductDetails {
  String? errorCode;
  String? errorMsg;
  List<Data>? data;

  ProductDetails({this.errorCode, this.errorMsg, this.data});

  ProductDetails.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['errorMsg'] = this.errorMsg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? sku;
  String? productType;
  Null? affiliateLink;
  int? userId;
  int? categoryId;
  int? subcategoryId;
  int? childcategoryId;
  Null? attributes;
  String? name;
  String? slug;
  String? photo;
  String? thumbnail;
  Null? file;
  Null? size;
  Null? sizeQty;
  Null? sizePrice;
  Null? sizeShopPrice;
  Null? color;
  int? price;
  int? previousPrice;
  String? details;
  int? stock;
  String? policy;
  int? status;
  Null? scrapUrl;
  int? scrapStatus;
  Null? scrapId;
  String? scrapJson;
  int? views;
  Null? tags;
  Null? features;
  Null? colors;
  int? productCondition;
  Null? ship;
  int? isMeta;
  Null? metaTag;
  Null? metaDescription;
  Null? youtube;
  String? type;
  Null? license;
  Null? licenseQty;
  Null? link;
  Null? platform;
  Null? region;
  Null? licenceType;
  Null? measure;
  int? featured;
  int? best;
  int? top;
  int? hot;
  int? latest;
  int? big;
  int? trending;
  int? sale;
  Null? salePercentage;
  int? commingSoon;
  String? createdAt;
  String? updatedAt;
  int? isDiscount;
  Null? discountDate;
  Null? wholeSellQty;
  Null? wholeSellDiscount;
  int? isCatalog;
  int? catalogId;
  Null? tax;
  int? showFront;
  String? brandId;
  List<String>? gallery;

  Data(
      {this.id,
      this.sku,
      this.productType,
      this.affiliateLink,
      this.userId,
      this.categoryId,
      this.subcategoryId,
      this.childcategoryId,
      this.attributes,
      this.name,
      this.slug,
      this.photo,
      this.thumbnail,
      this.file,
      this.size,
      this.sizeQty,
      this.sizePrice,
      this.sizeShopPrice,
      this.color,
      this.price,
      this.previousPrice,
      this.details,
      this.stock,
      this.policy,
      this.status,
      this.scrapUrl,
      this.scrapStatus,
      this.scrapId,
      this.scrapJson,
      this.views,
      this.tags,
      this.features,
      this.colors,
      this.productCondition,
      this.ship,
      this.isMeta,
      this.metaTag,
      this.metaDescription,
      this.youtube,
      this.type,
      this.license,
      this.licenseQty,
      this.link,
      this.platform,
      this.region,
      this.licenceType,
      this.measure,
      this.featured,
      this.best,
      this.top,
      this.hot,
      this.latest,
      this.big,
      this.trending,
      this.sale,
      this.salePercentage,
      this.commingSoon,
      this.createdAt,
      this.updatedAt,
      this.isDiscount,
      this.discountDate,
      this.wholeSellQty,
      this.wholeSellDiscount,
      this.isCatalog,
      this.catalogId,
      this.tax,
      this.showFront,
      this.brandId,
      this.gallery});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sku = json['sku'];
    productType = json['product_type'];
    affiliateLink = json['affiliate_link'];
    userId = json['user_id'];
    categoryId = json['category_id'];
    subcategoryId = json['subcategory_id'];
    childcategoryId = json['childcategory_id'];
    attributes = json['attributes'];
    name = json['name'];
    slug = json['slug'];
    photo = json['photo'];
    thumbnail = json['thumbnail'];
    file = json['file'];
    size = json['size'];
    sizeQty = json['size_qty'];
    sizePrice = json['size_price'];
    sizeShopPrice = json['size_shop_price'];
    color = json['color'];
    price = json['price'];
    previousPrice = json['previous_price'];
    details = json['details'];
    stock = json['stock'];
    policy = json['policy'];
    status = json['status'];
    scrapUrl = json['scrap_url'];
    scrapStatus = json['scrap_status'];
    scrapId = json['scrap_id'];
    scrapJson = json['scrap_json'];
    views = json['views'];
    tags = json['tags'];
    features = json['features'];
    colors = json['colors'];
    productCondition = json['product_condition'];
    ship = json['ship'];
    isMeta = json['is_meta'];
    metaTag = json['meta_tag'];
    metaDescription = json['meta_description'];
    youtube = json['youtube'];
    type = json['type'];
    license = json['license'];
    licenseQty = json['license_qty'];
    link = json['link'];
    platform = json['platform'];
    region = json['region'];
    licenceType = json['licence_type'];
    measure = json['measure'];
    featured = json['featured'];
    best = json['best'];
    top = json['top'];
    hot = json['hot'];
    latest = json['latest'];
    big = json['big'];
    trending = json['trending'];
    sale = json['sale'];
    salePercentage = json['sale_percentage'];
    commingSoon = json['comming_soon'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isDiscount = json['is_discount'];
    discountDate = json['discount_date'];
    wholeSellQty = json['whole_sell_qty'];
    wholeSellDiscount = json['whole_sell_discount'];
    isCatalog = json['is_catalog'];
    catalogId = json['catalog_id'];
    tax = json['tax'];
    showFront = json['show_front'];
    brandId = json['brand_id'];
    gallery = json['gallery'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sku'] = this.sku;
    data['product_type'] = this.productType;
    data['affiliate_link'] = this.affiliateLink;
    data['user_id'] = this.userId;
    data['category_id'] = this.categoryId;
    data['subcategory_id'] = this.subcategoryId;
    data['childcategory_id'] = this.childcategoryId;
    data['attributes'] = this.attributes;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['photo'] = this.photo;
    data['thumbnail'] = this.thumbnail;
    data['file'] = this.file;
    data['size'] = this.size;
    data['size_qty'] = this.sizeQty;
    data['size_price'] = this.sizePrice;
    data['size_shop_price'] = this.sizeShopPrice;
    data['color'] = this.color;
    data['price'] = this.price;
    data['previous_price'] = this.previousPrice;
    data['details'] = this.details;
    data['stock'] = this.stock;
    data['policy'] = this.policy;
    data['status'] = this.status;
    data['scrap_url'] = this.scrapUrl;
    data['scrap_status'] = this.scrapStatus;
    data['scrap_id'] = this.scrapId;
    data['scrap_json'] = this.scrapJson;
    data['views'] = this.views;
    data['tags'] = this.tags;
    data['features'] = this.features;
    data['colors'] = this.colors;
    data['product_condition'] = this.productCondition;
    data['ship'] = this.ship;
    data['is_meta'] = this.isMeta;
    data['meta_tag'] = this.metaTag;
    data['meta_description'] = this.metaDescription;
    data['youtube'] = this.youtube;
    data['type'] = this.type;
    data['license'] = this.license;
    data['license_qty'] = this.licenseQty;
    data['link'] = this.link;
    data['platform'] = this.platform;
    data['region'] = this.region;
    data['licence_type'] = this.licenceType;
    data['measure'] = this.measure;
    data['featured'] = this.featured;
    data['best'] = this.best;
    data['top'] = this.top;
    data['hot'] = this.hot;
    data['latest'] = this.latest;
    data['big'] = this.big;
    data['trending'] = this.trending;
    data['sale'] = this.sale;
    data['sale_percentage'] = this.salePercentage;
    data['comming_soon'] = this.commingSoon;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_discount'] = this.isDiscount;
    data['discount_date'] = this.discountDate;
    data['whole_sell_qty'] = this.wholeSellQty;
    data['whole_sell_discount'] = this.wholeSellDiscount;
    data['is_catalog'] = this.isCatalog;
    data['catalog_id'] = this.catalogId;
    data['tax'] = this.tax;
    data['show_front'] = this.showFront;
    data['brand_id'] = this.brandId;
    data['gallery'] = this.gallery;
    return data;
  }
}