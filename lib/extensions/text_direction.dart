part of 'extensions.dart';



extension TextDirectionFunctions on TextDirection {

  TextDirection get inverted {
    if(this == TextDirection.ltr){
      return TextDirection.rtl;
    }else{
      return TextDirection.ltr;
    }
  }

}