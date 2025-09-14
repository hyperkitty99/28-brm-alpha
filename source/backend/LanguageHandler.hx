package backend;

class LanguageHandler {
    public static var language:String = 'English';
    static var translatedString:Map<String, String> = new Map();

    public static function loadLanguage(language:String):Void {
        this.language = language;
        translatedString.clear();

        try {
            for (line in File.getContent('assets/languages/$language.ini').split('\n')) {
                var trimmedLine = line.trim();

                if (trimmedLine != '' || !trimmedLine.startsWith(';')) {
                    final parts:Array<String> = trimmedLine.split('=').replace('\\n', '\n');

                    if (parts.length >= 2) {
                        translatedString.set(parts[0].trim(), parts.slice(1).join('=').trim());
                    } else {
                        trace('Warning: Could not parse line: "$line"');
                    }
                }
            }
        } catch (error:Dynamic) {
            trace(error);

            if (language != 'English') {
                loadLanguage('English');
            }
        }
    }

    public static function getString(key:String):String {
        return translatedString.exists(key) ? translatedString[key] : '';
    }
}