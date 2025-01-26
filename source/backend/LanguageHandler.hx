package backend;

@:publicFields class LanguageHandler {
    private static var thetheLanguage = 'English';
    private static var thetheString:Map<String, String> = new Map<String, String>();

    static function __init__() loadLanguage(thetheLanguage);

    inline static function loadLanguage(language:String) {
        try {
            for (entry in File.getContent('assets/languages/$language.ini').split('\n')) {
                if (entry != '') {
                    final keyValue = entry.split('=');
                    thetheString.set(keyValue[0].trim(), keyValue[1].trim());
                }
            }
        } catch (error:Dynamic) {
            trace('skill issue!! heres the error ig: $error');
            if (language != 'English') loadLanguage('English');
        }
    }

    static function switchLanguage(language:String) {
        thetheString.clear();
        loadLanguage(thetheLanguage = language);
    }

    static function getString(key:String) {
        if (thetheString.exists(key))
            return thetheString[key].replace('\\n', '\n');
        else
            trace('minor spelling mistake: $key');

        return '';
    }
}