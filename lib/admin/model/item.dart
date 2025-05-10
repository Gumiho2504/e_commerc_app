class ItemState {
  final String? image;
  final bool isLoading;
  final String? seletedCategory;
  final List<String> categories;
  final List<String> colors;
  final List<String> sizes;
  final bool? isDiscount;
  final String? discountPercentage;

  ItemState(
    this.image,
    this.isLoading,
    this.seletedCategory,
    this.categories,
    this.colors,
    this.sizes,
    this.isDiscount,
    this.discountPercentage,
  );

  ItemState copyWith({
    String? image,
    bool? isLoading,
    String? seletedCategory,
    List<String>? categories,
    List<String>? color,
    List<String>? size,
    bool? isDiscount,
    String? discountPercentage,
  }) {
    return ItemState(
      image ?? this.image,
      isLoading ?? this.isLoading,
      seletedCategory ?? this.seletedCategory,
      categories ?? this.categories,
      color ?? colors,
      size ?? sizes,
      isDiscount ?? this.isDiscount,
      discountPercentage ?? this.discountPercentage,
    );
  }
}
