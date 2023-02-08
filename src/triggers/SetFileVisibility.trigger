trigger SetFileVisibility on ContentDocumentLink (before insert) {
    for(ContentDocumentLink cdl : Trigger.new) {
        cdl.Visibility = 'AllUsers';
    }
}