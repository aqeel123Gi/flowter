bool areAppliedArabicFullNames(String text,String typedText){
  typedText = typedText.replaceAll("بن ", "");
  typedText = typedText.replaceAll(" ", "");
  typedText = typedText.replaceAll("أ", "ا");
  typedText = typedText.replaceAll("ة", "ه");


  text = text.replaceAll("بن ", "");
  text = text.replaceAll(" ", "");
  text = text.replaceAll("أ", "ا");
  text = text.replaceAll("ة", "ه");


  return text.contains(typedText);
}