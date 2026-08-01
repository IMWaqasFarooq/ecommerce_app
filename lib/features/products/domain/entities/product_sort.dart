enum ProductSort { featured, priceLowToHigh, priceHighToLow, ratingHighToLow, titleAZ }

extension ProductSortQuery on ProductSort {
  String? get sortByParam => switch (this) {
    ProductSort.featured => null,
    ProductSort.priceLowToHigh || ProductSort.priceHighToLow => 'price',
    ProductSort.ratingHighToLow => 'rating',
    ProductSort.titleAZ => 'title',
  };

  String? get orderParam => switch (this) {
    ProductSort.featured => null,
    ProductSort.priceLowToHigh || ProductSort.titleAZ => 'asc',
    ProductSort.priceHighToLow || ProductSort.ratingHighToLow => 'desc',
  };

  String get label => switch (this) {
    ProductSort.featured => 'Featured',
    ProductSort.priceLowToHigh => 'Price: Low to High',
    ProductSort.priceHighToLow => 'Price: High to Low',
    ProductSort.ratingHighToLow => 'Rating: High to Low',
    ProductSort.titleAZ => 'Name: A to Z',
  };
}
