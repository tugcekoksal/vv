valueIsNull(value) {
  if (value == null || value == "") {
    return "No data";
  } else {
    return value!;
  }
}
