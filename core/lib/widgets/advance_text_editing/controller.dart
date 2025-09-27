part of 'advance_text_field.dart';

class AdvancedTextFieldController{

  bool validated = false;
  String validationMessage = "";

  TextEditingController textEditing = TextEditingController();
  late Future<bool?> Function() validate;

  late void Function(String text,bool validate) changeText;


  late void Function() requestFocus;




  void clear(){
    textEditing.clear();
  }


  String get trimmedText => textEditing.text.trim();

  static bool allValidated(List<AdvancedTextFieldController> controllers){
    for(var c in controllers){
      if(!c.validated){
        return false;
      }
    }
    return true;
  }
  static addListenerForList(List<AdvancedTextFieldController> controllers,void Function() function){
    for(var c in controllers){
      c.textEditing.addListener(function);
    }
  }
  static removeListenerForList(List<AdvancedTextFieldController> controllers){
    for(var c in controllers){
      c.textEditing.removeListener((){});
    }
  }
  static bool validateList(List<AdvancedTextFieldController> controllers){
    for(var c in controllers){
      c.validate();
    }
    return AdvancedTextFieldController.allValidated(controllers);
  }


  static Future<String?> validateAndReturnNonValidatedMessage(List<AdvancedTextFieldController> controllers)async{
    for(var c in controllers){
      await c.validate();
      if(c.validated==false){
        return c.validationMessage;
      }
    }
    return null;
  }


  static Map<String,String> _globalCharConversion = const {};
  static void setGlobalCharConversion(Map<String,String> map){
    _globalCharConversion = map;
  }

}