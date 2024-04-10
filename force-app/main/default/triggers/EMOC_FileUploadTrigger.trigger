trigger EMOC_FileUploadTrigger on ContentVersion (after insert,after update) {
    List<ContentVersion> ContentVersionList = Trigger.new;
    if(Trigger.IsAfter && (Trigger.IsInsert || Trigger.IsUpdate)) {
        EMOC_FileUploadTriggerHandler.onAfterUpload(ContentVersionList);
    }
}