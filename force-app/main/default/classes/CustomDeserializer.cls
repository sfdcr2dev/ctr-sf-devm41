public class CustomDeserializer { //implements JSON.deserializeUntypedHandler
    
    public static string handleDeserialize(string jsonInput) {
        string serializeJSON;
        List<Object> fieldList = (List<Object>)JSON.deserializeUntyped(jsonInput);
        for(Object fld : fieldList){    
            Map<String,Object> data = (Map<String,Object>)fld;
            object graduatedGradeObj = data.get('graduatedGrade');
            if(graduatedGradeObj != null) {
                string trimGraduatedGrade = graduatedGradeObj.toString().trim();
                string graduatedGrade = trimGraduatedGrade;
                string grade = '';
                try {
                    grade = graduatedGrade;
                    data.put('graduatedGrade', grade);
                }
                catch (Exception e){
                    data.put('graduatedGrade','');
                }
            }
        }
        serializeJSON = JSON.serialize(fieldList);
        return serializeJSON;
    }
    
    /* public Object handleDeserialize(Type objType, Map<String, Object> jsonMap) {
        
        // Loop through the JSON map and replace null values for Decimal fields with 0
        for (String fieldName : jsonMap.keySet()) {
            Object fieldValue = jsonMap.get(fieldName);
            if (objType.getField(fieldName).getDescribe().getType() == Schema.DisplayType.DECIMAL) {
                if (fieldValue == null) {
                    jsonMap.put(fieldName, 0);
                }
            }
            else if (fieldValue instanceof Map<String, Object>) {
                jsonMap.put(fieldName, handleDeserialize(objType.getFieldType(fieldName), (Map<String, Object>) fieldValue));
            }
        }
        
        // Call the default JSON deserializer to handle the rest of the deserialization
        return JSON.deserializeUntyped(JSON.serialize(jsonMap), objType);
    } */
    
}