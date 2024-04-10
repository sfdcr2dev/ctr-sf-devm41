/**
 * @author Sebastian Vera
 * @description Data Transfer Object used to Transfer Data to THOR_ObjectCard.cmp
 */
public class THOR_ObjectCardDTO {
    /**
     * @author Sebastian Vera
     * @description label value pair for dropable body
     */
    public class LabelValuePair {
        /**
         * @description label of the pair
         */
        @AuraEnabled
        public String label { get; set; }

        /**
         * @description value of the pair
         */
        @AuraEnabled
        public String value { get; set; }
    }

    /**
     * @description true if card must display new animation
     */
    @AuraEnabled
    public boolean isNew { get; set; }

    /**
     * @description recordId
     */
    @AuraEnabled
    public String recordId { get; set; }

    /**
     * @description recordId
     */
    @AuraEnabled
    public String formGroup { get; set; }

    /**
     * @description title of the card
     */
    @AuraEnabled
    public String title { get; set; }

    /**
     * @description name of the card
     */
    @AuraEnabled
    public String name { get; set; }

    /**
     * @description label of the title
     */
    @AuraEnabled
    public String titleLabel { get; set; }

    /**
     * @description hidden body of the card
     */
    @AuraEnabled
    public LabelValuePair[] dropableBody { get; set; }

    /**
     * @description true if the card can be delete
     */
    @AuraEnabled
    public boolean isDeletable { get; set; }

    /**
     * @description status of the card
     */
    @AuraEnabled
    public String status { get; set; }

    /**
     * @description notification the card is related to
     */
    @AuraEnabled
    public String notification { get; set; }

    /**
     * @description converts the body map into array of LabelBody to use on card
     * @param bodyMap params to display on the dropable body
     */
    public void setDropableBody(Map<String, String> bodyMap) {
        dropableBody = new List<LabelValuePair>();

        Set<String> keys = bodyMap.keySet();
        for (String key : keys) {
            LabelValuePair pair = new LabelValuePair();
            pair.label = key;
            pair.value = bodyMap.get(key);
            dropableBody.add(pair);
        }
    }
}